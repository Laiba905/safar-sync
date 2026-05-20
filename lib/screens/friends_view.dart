import 'package:flutter/material.dart';

class FriendsView extends StatefulWidget {
  const FriendsView({super.key});

  @override
  State<FriendsView> createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView> {
  // 1. Existing Friends Data
  final List<Map<String, String>> _allFriends = [
    {'name': 'Zain Ahmed', 'status': 'Traveling to Murree', 'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100'},
    {'name': 'Mahnoor Khan', 'status': 'Coding App Backend', 'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100'},
    {'name': 'Hamza Ali', 'status': 'Exploring Skardu', 'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100'},
  ];

  // 2. Incoming Friend Requests Data
  final List<Map<String, String>> _friendRequests = [
    {'name': 'Sana Bilal', 'mutual': '3 mutual friends', 'avatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100'},
    {'name': 'Omar Farooq', 'mutual': '1 mutual friend', 'avatar': 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=100'},
  ];

  // Search Queries
  String _existingFriendsQuery = '';
  final _globalSearchController = TextEditingController();
  bool _isSearchingGlobally = false;
  Map<String, String>? _globalSearchResult;

  // Global User Database Simulation (For finding new friends)
  final List<Map<String, String>> _globalUsersDb = [
    {'name': 'Bilal Raza', 'username': '@bilalraza', 'avatar': 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=100'},
    {'name': 'Ayesha Siddiqui', 'username': '@ayesha_s', 'avatar': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100'},
  ];

  // Handle Global Search Trigger
  void _handleGlobalSearch(String value) {
    if (value.trim().isEmpty) {
      setState(() {
        _isSearchingGlobally = false;
        _globalSearchResult = null;
      });
      return;
    }

    final result = _globalUsersDb.firstWhere(
          (user) => user['name']!.toLowerCase().contains(value.toLowerCase()) ||
          user['username']!.toLowerCase().contains(value.toLowerCase()),
      orElse: () => {},
    );

    setState(() {
      _isSearchingGlobally = true;
      if (result.isNotEmpty) {
        _globalSearchResult = result;
      } else {
        _globalSearchResult = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filter existing friends locally based on search bar input
    final filteredFriends = _allFriends.where((friend) {
      return friend['name']!.toLowerCase().contains(_existingFriendsQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Travel Buddies', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // 🔎 SEARCH 1: Existing Friends Search Bar
            // ==========================================
            TextField(
              onChanged: (val) {
                setState(() {
                  _existingFriendsQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search from existing friends...',
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF0D9488)),
                filled: true,
                fillColor: theme.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // ➕ SEARCH 2: Add New Friends (Global Search Panel)
            // ==========================================
            Text(
                'Find New Travel Partners',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _globalSearchController,
              onSubmitted: _handleGlobalSearch,
              decoration: InputDecoration(
                hintText: 'Enter name or username (e.g. Bilal)...',
                prefixIcon: const Icon(Icons.person_add_alt_1_rounded, color: Color(0xFF0D9488)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward_rounded, color: Color(0xFF0D9488)),
                  onPressed: () => _handleGlobalSearch(_globalSearchController.text),
                ),
                filled: true,
                fillColor: theme.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),

            // Global Search Results UI Area
            if (_isSearchingGlobally) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF0D9488).withOpacity(0.2)),
                ),
                child: _globalSearchResult != null
                    ? ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(backgroundImage: NetworkImage(_globalSearchResult!['avatar']!)),
                  title: Text(_globalSearchResult!['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(_globalSearchResult!['username']!, style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5))),
                  trailing: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Friend Request Sent to ${_globalSearchResult!['name']!}'))
                      );
                      setState(() {
                        _globalSearchController.clear();
                        _isSearchingGlobally = false;
                        _globalSearchResult = null;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D9488),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: const Text('Connect', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('No traveler found with that name.', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5), fontSize: 13)),
                ),
              ),
            ],
            const SizedBox(height: 28),

            // ==========================================
            // 📥 SECTION 3: Friend Requests Panel (Accept/Reject)
            // ==========================================
            if (_friendRequests.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'Friend Requests',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF0D9488), borderRadius: BorderRadius.circular(10)),
                    child: Text('${_friendRequests.length}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _friendRequests.length,
                itemBuilder: (context, index) {
                  final req = _friendRequests[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(14)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      leading: CircleAvatar(backgroundImage: NetworkImage(req['avatar']!)),
                      title: Text(req['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      subtitle: Text(req['mutual']!, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.5))),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Accept Button
                          IconButton(
                            icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF0D9488), size: 28),
                            onPressed: () {
                              setState(() {
                                _allFriends.add({
                                  'name': req['name']!,
                                  'status': 'Just joined your circle',
                                  'avatar': req['avatar']!,
                                });
                                _friendRequests.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${req['name']} added to friends!'))
                              );
                            },
                          ),
                          // Reject Button
                          IconButton(
                            icon: const Icon(Icons.cancel_rounded, color: Colors.redAccent, size: 28),
                            onPressed: () {
                              setState(() {
                                _friendRequests.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],

            // ==========================================
            // 👥 SECTION 4: Friends List View
            // ==========================================
            Text(
                'My Circle (${_allFriends.length})',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)
            ),
            const SizedBox(height: 12),
            filteredFriends.isEmpty
                ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text('No friends found matching search.', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4))),
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredFriends.length,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  leading: CircleAvatar(backgroundImage: NetworkImage(filteredFriends[index]['avatar']!)),
                  title: Text(filteredFriends[index]['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(filteredFriends[index]['status']!, style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5), fontSize: 13)),
                  trailing: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF0D9488), size: 20),
                  onTap: () {
                    // Standard action simulation trigger
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}