import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../database_service.dart';
import '../models/user_model.dart';

class FriendRequest {
  final String requestId;
  final UserModel user;
  FriendRequest({required this.requestId, required this.user});
}

class NetworkProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  List<UserModel> _searchResults = [];
  bool _isSearching = false;

  List<FriendRequest> _pendingRequests = [];
  UserModel? _currentUserData;
  StreamSubscription? _requestsSubscription;
  StreamSubscription? _userDataSubscription;

  List<UserModel> get searchResults => _searchResults;
  bool get isSearching => _isSearching;
  List<FriendRequest> get pendingRequests => _pendingRequests;
  UserModel? get currentUserData => _currentUserData;

  // Listen to friend requests and user data (friends list)
  void init(String userId) {
    _requestsSubscription?.cancel();
    _userDataSubscription?.cancel();

    // Listen to friend requests
    _requestsSubscription = _dbService.getFriendRequests(userId).listen((snapshot) async {
      debugPrint("Friend requests snapshot received: ${snapshot.docs.length} docs");
      List<FriendRequest> requests = [];
      for (var doc in snapshot.docs) {
        String fromId = doc['from'];
        // Fetch user info for each request
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(fromId).get();
        if (userDoc.exists) {
          UserModel user = UserModel.fromMap(userDoc.data() as Map<String, dynamic>)..id = userDoc.id;
          requests.add(FriendRequest(requestId: doc.id, user: user));
        }
      }
      _pendingRequests = requests;
      notifyListeners();
    });

    // Listen to current user data for friends list
    _userDataSubscription = _dbService.getUserData(userId).listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        _currentUserData = UserModel.fromMap(data)..id = snapshot.id;
        debugPrint("User data updated, friends count: ${_currentUserData?.friends.length}");
        _fetchFriendsData(); // Fetch details for the friends list
        notifyListeners();
      }
    });
  }

  List<UserModel> _friends = [];
  List<UserModel> get friends => _friends;

  Future<void> _fetchFriendsData() async {
    if (_currentUserData == null || _currentUserData!.friends.isEmpty) {
      _friends = [];
      notifyListeners();
      return;
    }

    try {
      List<UserModel> friendList = [];
      // Use whereIn for efficiency if friends list is not huge
      // Firestore whereIn supports up to 30 elements (increased from 10)
      List<String> friendIds = _currentUserData!.friends;
      
      // If many friends, we might need to chunk this, but for now 30 is usually enough
      if (friendIds.isNotEmpty) {
        // Fetching in chunks of 30
        for (var i = 0; i < friendIds.length; i += 30) {
          var end = (i + 30 < friendIds.length) ? i + 30 : friendIds.length;
          var chunk = friendIds.sublist(i, end);
          
          QuerySnapshot friendSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .where(FieldPath.documentId, whereIn: chunk)
              .get();
              
          for (var doc in friendSnapshot.docs) {
            friendList.add(UserModel.fromMap(doc.data() as Map<String, dynamic>)..id = doc.id);
          }
        }
      }
      
      _friends = friendList;
      debugPrint("Fetched ${_friends.length} friends details");
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching friends data: $e");
    }
  }

  // Search users by email
  Future<void> searchUsers(String email) async {
    _isSearching = true;
    notifyListeners();

    QuerySnapshot snapshot = await _dbService.searchUserByEmail(email);
    _searchResults = snapshot.docs
        .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>)..id = doc.id)
        .toList();

    _isSearching = false;
    notifyListeners();
  }

  // Send friend request
  Future<void> sendRequest(String fromId, String toId) async {
    await _dbService.sendFriendRequest(fromId, toId);
  }

  // Accept request
  Future<void> acceptRequest(String requestId, String userId, String friendId) async {
    try {
      await _dbService.acceptFriendRequest(requestId, userId, friendId);
      // Success snackbar handled in UI
    } catch (e) {
      debugPrint("Accept Request Error: $e");
    }
  }

  // Decline request
  Future<void> declineRequest(String requestId) async {
    await _dbService.declineFriendRequest(requestId);
  }

  // Generate Dummy Data for Testing
  Future<void> seedDummyData(String currentUserId) async {
    final batch = FirebaseFirestore.instance.batch();
    
    // 1. Create a dummy user
    String dummyId = "dummy_user_123";
    DocumentReference dummyRef = FirebaseFirestore.instance.collection('users').doc(dummyId);
    batch.set(dummyRef, {
      'uid': dummyId,
      'name': 'Zain (Dummy)',
      'email': 'zain@dummy.com',
      'friends': [],
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 2. Create a pending request to YOU
    DocumentReference requestRef = FirebaseFirestore.instance.collection('friend_requests').doc();
    batch.set(requestRef, {
      'from': dummyId,
      'to': currentUserId,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });

    await batch.commit();
    debugPrint("Dummy data seeded to Firestore!");
  }

  @override
  void dispose() {
    _requestsSubscription?.cancel();
    _userDataSubscription?.cancel();
    super.dispose();
  }
}
