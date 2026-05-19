import 'package:flutter/material.dart';
import 'home_feed_view.dart';
import 'buddies_screen.dart';
//import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // 4 Core Application Functional Views
  final List<Widget> _pages = [
    const HomeFeedView(), // Index 0: Active Trips Dashboard
    const BuddiesScreen(), // Index 1: Friends Module
    const Center(child: Text('💬 Group Chat Screen\n(Coming Soon)', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 16))), // Index 2: Chats
    const Center(child: Text('🤖 AI Assistant Planner\n(Coming Soon)', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 16))), // Index 3: SafarAI
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),

      // Dynamic Page Router Switch
      body: _pages[_currentIndex],

      // Persistent Floating Action Button (Plan Trip Trigger)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Future Trip Blueprint creation bottom sheet action hook
        },
        backgroundColor: const Color(0xFF00695C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
      ),

      // Modern 4-Tab Custom Bottom Navigation Row
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0D9488),
        unselectedItemColor: Colors.grey.shade500,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed, // Layout scaling for 4 distinct anchors
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Handle smooth horizontal tracking shift
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'Trips'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline_rounded), label: 'Friends'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline_rounded), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.psychology_outlined), label: 'SafarAI'),
        ],
      ),
    );
  }
}