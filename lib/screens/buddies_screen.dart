import 'package:flutter/material.dart';

class BuddiesScreen extends StatefulWidget {
  const BuddiesScreen({super.key});

  @override
  State<BuddiesScreen> createState() => _BuddiesScreenState();
}

class _BuddiesScreenState extends State<BuddiesScreen> {
  // Mock data for travel buddies
  final List<Map<String, String>> _myBuddies = [
    {'name': 'Mahnoor Khan', 'status': 'Planning Hunza', 'image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=150'},
    {'name': 'Ahmed Raza', 'status': 'Exploring Skardu', 'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=150'},
    {'name': 'Laiba Ali', 'status': 'Online', 'image': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=150'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        title: const Text(
          'Travel Network',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded, color: Color(0xFF0D9488)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search Bar for finding new buddies
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for travel buddies...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
            const SizedBox(height: 24),

            // 📩 Sync Requests Section (Incoming)
            const Text(
              'Sync Requests (2)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            _buildRequestTile('Zainab Sheikh', 'Mutual Friend: Ahmed'),

            const SizedBox(height: 24),

            // 👥 My Network (Active Buddies)
            const Text(
              'My Travel Squad',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _myBuddies.length,
              itemBuilder: (context, index) {
                final buddy = _myBuddies[index];
                return _buildBuddyTile(buddy);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Request Tile Widget
  Widget _buildRequestTile(String name, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2F1), // Light Teal background
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 20, backgroundColor: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D9488),
              minimumSize: const Size(60, 32),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Accept', style: TextStyle(fontSize: 12, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Active Buddy Tile Widget
  Widget _buildBuddyTile(Map<String, String> buddy) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(buddy['image']!),
        ),
        title: Text(buddy['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(buddy['status']!, style: const TextStyle(fontSize: 12)),
        trailing: IconButton(
          icon: const Icon(Icons.chat_bubble_outline_rounded, size: 20, color: Color(0xFF0D9488)),
          onPressed: () {},
        ),
      ),
    );
  }
}