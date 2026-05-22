import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ✅ Fixed Imports using absolute package paths
import 'package:safar_sync/providers/auth_provider.dart';
import 'package:safar_sync/providers/trip_provider.dart';
import 'package:safar_sync/providers/network_provider.dart';
import 'package:safar_sync/screens/home_feed_view.dart';
import 'package:safar_sync/screens/friends_view.dart';
import 'package:safar_sync/screens/chats_view.dart';
import 'package:safar_sync/screens/safar_ai_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.uid;
      if (userId != null) {
        Provider.of<TripProvider>(context, listen: false).fetchUserTrips(userId);
        Provider.of<NetworkProvider>(context, listen: false).init(userId);
      }
    });
  }

  final List<Widget> _views = [
    const HomeFeedView(),
    const FriendsView(),
    const ChatsView(),
    const SafarAiView(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _views,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.cardColor,
        selectedItemColor: const Color(0xFF0D9488),
        unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.4),
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), activeIcon: Icon(Icons.explore), label: 'Trips'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline_rounded), activeIcon: Icon(Icons.people_rounded), label: 'Friends'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline_rounded), activeIcon: Icon(Icons.chat_bubble_rounded), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome_outlined), activeIcon: Icon(Icons.auto_awesome), label: 'SafarAI'),
        ],
      ),
    );
  }
}
