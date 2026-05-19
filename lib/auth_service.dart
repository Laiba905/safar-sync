import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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
        // User ka data Firestore ke 'users' collection mai save karein
        await _db.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'phoneNumber': '', // Abhi khali chor rahe hain, baad mai update ho sakta hai
          'createdAt': FieldValue.serverTimestamp(),
          'role': 'passenger', // Default role (passenger/driver)
        });
      }
      return user;
    } catch (e) {
      print("Signup Error: ${e.toString()}");
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
      print("Login Error: ${e.toString()}");
      return null;
    }
  }

  // ==========================================
  // 2. PHONE NUMBER (OTP) FUNCTIONS
  // ==========================================

  // SEND OTP: User Ke Phone Par 6-Digit Verification Code Bhejna
  Future<void> sendOTP(String phoneNumber, Function(String) onCodeSent) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Android baaz auqat automatically SMS read kar ke login kar leta hai
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Phone Auth Failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          // Yeh verificationId frontend screen ko pass karni hai taakay verification ho sakay
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print("Send OTP Error: ${e.toString()}");
    }
  }

  // VERIFY OTP: User Ka Likhay Huay OTP Ko Check Kar Ke Login Karna
  Future<User?> verifyOTP(String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthCredential(
        providerId: 'phone',
        signInMethod: 'phone',
        verificationId: verificationId,
        smsCode: smsCode,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      // Agar yeh naya phone user hai, to iska data bhi Firestore mai save karein
      if (user != null) {
        DocumentSnapshot userDoc = await _db.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          await _db.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'name': 'Phone User', // Default temporary name
            'email': '',
            'phoneNumber': user.phoneNumber,
            'createdAt': FieldValue.serverTimestamp(),
            'role': 'passenger',
          });
        }
      }
      return user;
    } catch (e) {
      print("OTP Verification Error: ${e.toString()}");
      return null;
    }
  }

  // ==========================================
  // 3. COMMON FUNCTIONS
  // ==========================================

  // LOGOUT: Account Sign Out Karne Ke Liye
  Future<void> signOut() async {
    await _auth.signOut();
  }
}