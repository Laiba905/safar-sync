import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'theme/app_theme.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized before app launch
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase ko app start hotay hi initialize karein taake baad mein crash na ho
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafarSync',
      debugShowCheckedModeBanner: false,

      // ☀️ Light Mode Theme Configuration
      theme: AppTheme.lightTheme,

      // 🌙 Dark Mode Theme Configuration
      darkTheme: AppTheme.darkTheme,

      // 🔄 System settings ke mutabik automatic light/dark switch hoga
      themeMode: ThemeMode.system,

      // 🚀 App starting point set to Animated Splash Screen
      home: const SplashScreen(),
    );
  }
}

// Note: Mahnoor ka banaya hua InitializerWidget abhi neechay moujud hai,
// jab aap Splash Screen se direct user auth status check karengi, tab yeh use hoga.
class InitializerWidget extends StatelessWidget {
  const InitializerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Firebase Firestore test message log
          FirebaseFirestore.instance.collection('test_collection').add({
            'message': 'Hello Mahnoor, Firebase is working!',
            'time': DateTime.now().toString(),
          });

          return Scaffold(
            appBar: AppBar(
              title: const Text('Safar Sync'),
              backgroundColor: Colors.blue,
            ),
            body: const Center(
              child: Text('Firebase Initialized and Data Sent!'),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}