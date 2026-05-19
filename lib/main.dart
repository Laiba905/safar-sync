import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  // 1. Flutter ko ready karein
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. runApp ko foran chalayein taake screen blank na rahe
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Safar Sync',
      home: const InitializerWidget(),
    );
  }
}

// Yeh widget check karega ke Firebase load hua ya nahi
class InitializerWidget extends StatelessWidget {
  const InitializerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Firebase initialization yahan ho rahi hai
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        // Agar initialize ho gaya toh Home Screen dikhayein
        if (snapshot.connectionState == ConnectionState.done) {
          
          // Test data bhejte waqt app ko rokna nahi chahiye
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

        // Agar error aaye
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        // Jab tak load ho raha hai, loading spinner dikhayein
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
