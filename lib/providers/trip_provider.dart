import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../database_service.dart';
import '../models/trip_model.dart';
import '../models/expense_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TripProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  List<TripModel> _trips = [];
  bool _isLoading = false;

  // Real-time chat messages for active trip
  List<DocumentSnapshot> _chatMessages = [];
  StreamSubscription? _chatSubscription;

  // Expenses for active trip
  List<ExpenseModel> _expenses = [];
  StreamSubscription? _expenseSubscription;

  // Member names cache
  Map<String, String> _memberNames = {};
  Map<String, String> get memberNames => _memberNames;

  Future<void> fetchMemberNames(List<dynamic> userIds) async {
    for (dynamic rawId in userIds) {
      String id = rawId.toString();
      if (!_memberNames.containsKey(id)) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(id).get();
        if (doc.exists) {
          _memberNames[id] = doc.data()?['name'] ?? 'Unknown';
          notifyListeners();
        }
      }
    }
  }

  // Itinerary for active trip
  List<DocumentSnapshot> _itinerary = [];
  StreamSubscription? _itinerarySubscription;

  List<TripModel> get trips => _trips;
  bool get isLoading => _isLoading;
  List<DocumentSnapshot> get chatMessages => _chatMessages;
  List<ExpenseModel> get expenses => _expenses;
  List<DocumentSnapshot> get itinerary => _itinerary;

  StreamSubscription? _tripsSubscription;
  String? _currentListeningUserId;

  // User ke trips ko load karna (Real-time & Robust)
  void fetchUserTrips(String userId) {
    if (_currentListeningUserId == userId && _tripsSubscription != null) return;

    debugPrint("DEBUG: Starting trip listener for $userId");
    _currentListeningUserId = userId;
    _isLoading = true;
    notifyListeners();

    _tripsSubscription?.cancel();
    _tripsSubscription = _dbService.getUserTrips(userId).listen((snapshot) {
      debugPrint("DEBUG: Received trips snapshot with ${snapshot.docs.length} docs");
      try {
        List<TripModel> fetchedTrips = [];
        for (var doc in snapshot.docs) {
          try {
            fetchedTrips.add(TripModel.fromFirestore(doc));
          } catch (e) {
            debugPrint("DEBUG: Error parsing individual trip ${doc.id}: $e");
          }
        }

        _trips = fetchedTrips;
        _trips.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        _isLoading = false;
        notifyListeners();
      } catch (e) {
        debugPrint("DEBUG: General error in trips listener: $e");
        _isLoading = false;
        notifyListeners();
      }
    }, onError: (error) {
      debugPrint("DEBUG: Firestore Stream Error: $error");
      _isLoading = false;
      notifyListeners();
    });
  }

  // Real-time Chat listener
  void listenToChat(String tripId) {
    _chatSubscription?.cancel();
    _chatSubscription = _dbService.getChatMessages(tripId).listen((snapshot) {
      _chatMessages = snapshot.docs;
      notifyListeners();
    });
  }

  // Send message
  Future<void> sendMessage(String tripId, String senderId, String text) async {
    await _dbService.sendMessage(tripId, senderId, text);
  }

  // Expenses Listener
  void listenToExpenses(String tripId) {
    _expenseSubscription?.cancel();
    _expenseSubscription = _dbService.getTripExpenses(tripId).listen((snapshot) {
      _expenses = snapshot.docs.map((doc) => ExpenseModel.fromFirestore(doc)).toList();
      notifyListeners();
    });
  }

  // Itinerary Listener
  void listenToItinerary(String tripId) {
    _itinerarySubscription?.cancel();
    _itinerarySubscription = _dbService.getTripItinerary(tripId).listen((snapshot) {
      _itinerary = snapshot.docs;
      notifyListeners();
    });
  }

  // Toggle Activity
  Future<void> toggleActivityStatus(String tripId, String activityId, bool currentStatus) async {
    await _dbService.updateActivityStatus(tripId, activityId, !currentStatus);
  }

  // Add Activity
  Future<void> addActivity(String tripId, String title, DateTime time) async {
    await _dbService.addActivity(tripId, title, time);
  }

  // =========================================================================
  // 💵 UPDATED EXPENSE FUNCTIONS (ADD, EDIT, & DELETE INTEGRATED)
  // =========================================================================

  // Add Expense
  Future<void> addExpense(String tripId, {
    required String description,
    required double totalAmount,
    required String payerId,
    required String payerName,
    required List<String> splitAmong,
  }) async {
    await _dbService.addExpense(
      tripId,
      description: description,
      totalAmount: totalAmount,
      payerId: payerId,
      payerName: payerName,
      splitAmong: splitAmong,
    );
  }

  // Edit Expense (✅ NEWLY ADDED)
  Future<void> editExpense(
      String tripId,
      String expenseId, {
        required String description,
        required double totalAmount,
      }) async {
    try {
      // Direct Firestore sub-collection database update target trigger
      await FirebaseFirestore.instance
          .collection('trips')
          .doc(tripId)
          .collection('expenses')
          .doc(expenseId)
          .update({
        'description': description,
        'totalAmount': totalAmount,
      });
      notifyListeners();
    } catch (e) {
      debugPrint("Provider Layer Error updating expense: $e");
    }
  }

  // Delete Expense (✅ NEWLY ADDED)
  Future<void> deleteExpense(String tripId, String expenseId) async {
    try {
      // Real-time document destruction from cloud architecture
      await FirebaseFirestore.instance
          .collection('trips')
          .doc(tripId)
          .collection('expenses')
          .doc(expenseId)
          .delete();
      notifyListeners();
    } catch (e) {
      debugPrint("Provider Layer Error deleting expense: $e");
    }
  }

  @override
  void dispose() {
    _chatSubscription?.cancel();
    _expenseSubscription?.cancel();
    _itinerarySubscription?.cancel();
    _tripsSubscription?.cancel();
    super.dispose();
  }

  // =========================================================================
  // WEATHER DATA STATE & FUNCTIONS (FIXED CONST ERROR)
  // =========================================================================
  Map<String, dynamic>? _currentWeather;
  List<dynamic> _forecast = [];
  bool _isWeatherLoading = false;
  Map<String, dynamic>? _specificDayWeather;

  Map<String, dynamic>? get currentWeather => _currentWeather;
  List<dynamic> get forecast => _forecast;
  bool get isWeatherLoading => _isWeatherLoading;
  Map<String, dynamic>? get specificDayWeather => _specificDayWeather;

  final String _apiKey = '8db9f34f7196cf047249a56c3866c891';

  // Fetch function via coordinates
  Future<void> fetchWeather(double lat, double lon) async {
    _isWeatherLoading = true;
    notifyListeners();

    try {
      // 1. Current Weather
      final currentUrl = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric');
      final currentRes = await http.get(currentUrl);

      // 2. 5-Day Forecast
      final forecastUrl = Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$_apiKey&units=metric');
      final forecastRes = await http.get(forecastUrl);

      if (currentRes.statusCode == 200) {
        _currentWeather = json.decode(currentRes.body);
      }
      if (forecastRes.statusCode == 200) {
        final decodedData = json.decode(forecastRes.body);
        if (decodedData != null && decodedData['list'] != null) {
          final List<dynamic> fullList = decodedData['list'];
          _forecast = fullList.where((item) => item['dt_txt'].contains('12:00:00')).toList();
        } else {
          _forecast = [];
        }
      } else {
        _forecast = [];
      }
    } catch (e) {
      debugPrint("Weather API Error: $e");
    } finally {
      _isWeatherLoading = false;
      notifyListeners();
    }
  }

  // Specific trip date ke mutabiq weather filter karne ka function
  Future<void> fetchWeatherForTripDay(double lat, double lon, String tripStartDate) async {
    _isWeatherLoading = true;
    _specificDayWeather = null;
    notifyListeners();

    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$_apiKey&units=metric');

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final decodedData = json.decode(res.body);
        final List<dynamic> fullList = decodedData['list'];

        bool dayFound = false;
        for (var item in fullList) {
          String txtDate = item['dt_txt'];
          if (txtDate.contains(tripStartDate)) {
            _specificDayWeather = item;
            dayFound = true;
            break;
          }
        }

        if (!dayFound && fullList.isNotEmpty) {
          _specificDayWeather = fullList.first;
        }
      }
    } catch (e) {
      debugPrint("Trip Day Weather Filter Error: $e");
    } finally {
      _isWeatherLoading = false;
      notifyListeners();
    }
  }

  // =========================================================================
  // TRIP MANIPULATION FUNCTIONS
  // =========================================================================
  Future<bool> createNewTrip({
    required String creatorId,
    required String title,
    required String description,
    required String destination,
    required double latitude,
    required double longitude,
    required DateTime startDate,
    required DateTime endDate,
    required List<String> memberIds,
  }) async {
    _isLoading = true;
    notifyListeners();

    String? tripId = await _dbService.createTrip(
      creatorId: creatorId,
      title: title,
      description: description,
      destination: destination,
      latitude: latitude,
      longitude: longitude,
      startDate: startDate,
      endDate: endDate,
      buddies: memberIds,
    );

    _isLoading = false;
    notifyListeners();
    return tripId != null;
  }

  Future<void> deleteTrip(String tripId) async {
    await _dbService.deleteTrip(tripId);
  }

  Future<void> leaveTrip(String tripId, String userId) async {
    await _dbService.leaveTrip(tripId, userId);
  }
}