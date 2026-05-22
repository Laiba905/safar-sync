import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ==========================================
  // 1. TRAVEL NETWORK (Friends System - Item #2)
  // ==========================================
  
  // Search user by email (Blueprint logic)
  Future<QuerySnapshot> searchUserByEmail(String email) {
    return _db.collection('users').where('email', isEqualTo: email).get();
  }

  // Get Friend Requests
  Stream<QuerySnapshot> getFriendRequests(String userId) {
    return _db
        .collection('friend_requests')
        .where('to', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  // Get Friends List
  Stream<DocumentSnapshot> getUserData(String userId) {
    return _db.collection('users').doc(userId).snapshots();
  }

  // Send friend request
  Future<void> sendFriendRequest(String fromId, String toId) async {
    await _db.collection('friend_requests').add({
      'from': fromId,
      'to': toId,
      'status': 'pending', // pending, accepted, declined
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Friend Request Accept karna (Batch write use kiya h taake dono taraf update ho)
  Future<void> acceptFriendRequest(String requestId, String userId, String friendId) async {
    WriteBatch batch = _db.batch();
    
    // 1. Request status update
    batch.update(_db.collection('friend_requests').doc(requestId), {'status': 'accepted'});
    
    // 2. User ki friends list mein izafa
    batch.update(_db.collection('users').doc(userId), {
      'friends': FieldValue.arrayUnion([friendId])
    });
    
    // 3. Friend ki list mein user ka izafa
    batch.update(_db.collection('users').doc(friendId), {
      'friends': FieldValue.arrayUnion([userId])
    });
    
    await batch.commit();
  }

  // Friend Request Reject karna
  Future<void> declineFriendRequest(String requestId) async {
    await _db.collection('friend_requests').doc(requestId).update({'status': 'declined'});
  }

  // ==========================================
  // 2. TRIP & ITINERARY MANAGEMENT (Item #3)
  // ==========================================

  // Get User Trips
  Stream<QuerySnapshot> getUserTrips(String userId) {
    return _db
        .collection('trips')
        .where('members', arrayContains: userId)
        .snapshots();
  }

  // Image Upload logic for Trips
  Future<String?> uploadTripImage(String tripId, File imageFile) async {
    try {
      Reference ref = _storage.ref().child('trip_images').child('$tripId.jpg');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint("Image Upload Error: $e");
      return null;
    }
  }

  // Naya Trip create karna (Destination, Dates, Buddies)
  Future<String?> createTrip({
    required String creatorId,
    required String title,
    required String description,
    required String destination,
    required double latitude,
    required double longitude,
    required DateTime startDate,
    required DateTime endDate,
    required List<String> buddies,
  }) async {
    try {
      DocumentReference doc = _db.collection('trips').doc();
      
      // Map preview image URL (Using a static map API based on trip location)
      String imageUrl = 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=12&size=600x300&key=AIzaSyB6wXBd_0LYj19kyPbD8KQ8Fb3cTKWwZoE';

      // Ensure members list is unique and contains the creator
      List<String> finalMembers = {creatorId, ...buddies}.toList();

      await doc.set({
        'title': title,
        'description': description,
        'createdBy': creatorId,
        'destination': destination,
        'latitude': latitude,
        'longitude': longitude,
        'startDate': Timestamp.fromDate(startDate),
        'endDate': Timestamp.fromDate(endDate),
        'members': finalMembers,
        'createdAt': FieldValue.serverTimestamp(),
        'imageUrl': imageUrl,
      });
      return doc.id;
    } catch (e) {
      debugPrint("Trip Creation Error: $e");
      return null;
    }
  }

  // Daily Activity add karna (Itinerary Timeline)
  Future<void> addActivity(String tripId, String title, DateTime time) async {
    await _db.collection('trips').doc(tripId).collection('itinerary').add({
      'title': title,
      'time': Timestamp.fromDate(time),
      'isDone': false,
    });
  }

  // Activity status update karna
  Future<void> updateActivityStatus(String tripId, String activityId, bool isDone) async {
    await _db.collection('trips').doc(tripId).collection('itinerary').doc(activityId).update({
      'isDone': isDone,
    });
  }

  // Delete Trip (Creator only)
  Future<void> deleteTrip(String tripId) async {
    // Note: In production, you'd also delete subcollections and images.
    await _db.collection('trips').doc(tripId).delete();
  }

  // Leave Trip (Member)
  Future<void> leaveTrip(String tripId, String userId) async {
    await _db.collection('trips').doc(tripId).update({
      'members': FieldValue.arrayRemove([userId])
    });
  }

  // Itinerary Fetch karna
  Stream<QuerySnapshot> getTripItinerary(String tripId) {
    return _db
        .collection('trips')
        .doc(tripId)
        .collection('itinerary')
        .orderBy('time', descending: false)
        .snapshots();
  }

  // ==========================================
  // 3. GROUP EXPENSE SPLITTER (Item #7)
  // ==========================================
  
  // Expense add karna aur share calculate karna
  Future<void> addExpense(String tripId, {
    required String description,
    required double totalAmount,
    required String payerId,
    required String payerName,
    required List<String> splitAmong,
  }) async {
    await _db.collection('trips').doc(tripId).collection('expenses').add({
      'description': description,
      'amount': totalAmount,
      'payerId': payerId,
      'payerName': payerName,
      'splitAmong': splitAmong,
      'sharePerPerson': totalAmount / splitAmong.length, // Split logic
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get Trip Expenses
  Stream<QuerySnapshot> getTripExpenses(String tripId) {
    return _db
        .collection('trips')
        .doc(tripId)
        .collection('expenses')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // ==========================================
  // 4. REAL-TIME CHAT (Item #6)
  // ==========================================
  
  // Group Chat (Trip Based)
  Stream<QuerySnapshot> getChatMessages(String tripId) {
    return _db
        .collection('trips')
        .doc(tripId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> sendMessage(String tripId, String senderId, String text) async {
    await _db.collection('trips').doc(tripId).collection('messages').add({
      'senderId': senderId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Individual Chat (Direct Messaging)
  // Chat ID logic: sort(userId1, userId2) to always get same room
  String _getChatId(String uid1, String uid2) {
    List<String> ids = [uid1, uid2];
    ids.sort();
    return ids.join('_');
  }

  Stream<QuerySnapshot> getPrivateMessages(String uid1, String uid2) {
    String chatId = _getChatId(uid1, uid2);
    return _db
        .collection('private_chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> sendPrivateMessage(String fromId, String toId, String text) async {
    String chatId = _getChatId(fromId, toId);
    await _db.collection('private_chats').doc(chatId).collection('messages').add({
      'senderId': fromId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
    // Update last message in parent doc
    await _db.collection('private_chats').doc(chatId).set({
      'lastMessage': text,
      'lastTimestamp': FieldValue.serverTimestamp(),
      'members': [fromId, toId],
    }, SetOptions(merge: true));
  }
}
