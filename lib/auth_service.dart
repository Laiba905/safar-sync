import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // debugPrint ke liye

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Blueprint Day 2: Auth state changes monitor karne ke liye stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current User ID hasil karne ke liye (helpful for queries)
  String? get currentUserUid => _auth.currentUser?.uid;

  // ==========================================
  // 1. EMAIL/PASSWORD FUNCTIONS
  // ==========================================

  // SIGN UP: Naya Account Banane Aur Firestore Mai Data Save Karne Ke Liye
  Future<User?> signUpWithEmail(String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        // Blueprint Day 1: User ka data Firestore ke 'users' collection mai save karein
        await _db.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'phoneNumber': '', 
          'createdAt': FieldValue.serverTimestamp(),
          'friends': [], // Travel Network (Friends System) ke liye empty array
        });
      }
      return user;
    } catch (e) {
      debugPrint("Signup Error: ${e.toString()}");
      return null;
    }
  }

  // LOGIN: Pehle Se Bane Email Account Mai Log In Ke Liye
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      debugPrint("Login Error: ${e.toString()}");
      return null;
    }
  }

  // ==========================================
  // 2. PHONE NUMBER (OTP) FUNCTIONS
  // ==========================================

  Future<void> sendOTP(String phoneNumber, Function(String) onCodeSent) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint("Phone Auth Failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      debugPrint("Send OTP Error: ${e.toString()}");
    }
  }

  Future<User?> verifyOTP(String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      if (user != null) {
        DocumentSnapshot userDoc = await _db.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          await _db.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'name': 'Phone User',
            'email': '',
            'phoneNumber': user.phoneNumber,
            'createdAt': FieldValue.serverTimestamp(),
            'friends': [],
          });
        }
      }
      return user;
    } catch (e) {
      debugPrint("OTP Verification Error: ${e.toString()}");
      return null;
    }
  }

  // ==========================================
  // 3. COMMON FUNCTIONS
  // ==========================================

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
