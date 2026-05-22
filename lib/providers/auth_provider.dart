import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  AuthProvider() {
    // Auth state ko listen karein
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // Sign Up Logic
  Future<bool> signUp(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    User? user = await _authService.signUpWithEmail(name, email, password);
    if (user != null) {
      _user = user;
    }
    
    _isLoading = false;
    notifyListeners();
    return user != null;
  }

  // Login Logic
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    User? user = await _authService.loginWithEmail(email, password);
    if (user != null) {
      _user = user;
    }
    
    _isLoading = false;
    notifyListeners();
    return user != null;
  }

  // Logout Logic
  Future<void> logout() async {
    await _authService.signOut();
  }
}
