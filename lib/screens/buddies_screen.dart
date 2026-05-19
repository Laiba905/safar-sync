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
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      // Hardcoded colors ki jagah theme settings use ki hain taake system ke mutabik badal sakein
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Travel Network',
          style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
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
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Search for travel buddies...',
                hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5)),
                prefixIcon: Icon(Icons.search_rounded, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                filled: true,
                fillColor: theme.cardColor, // Dark mode mein automatic dark container ho jayega
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
            const SizedBox(height: 24),

            // 📩 Sync Requests Section (Incoming)
            Text(
              'Sync Requests (2)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
            ),
            const SizedBox(height: 12),
            _buildRequestTile(context, 'Zainab Sheikh', 'Mutual Friend: Ahmed'),

            const SizedBox(height: 24),

            // 👥 My Network (Active Buddies)
            Text(
              'My Travel Squad',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _myBuddies.length,
              itemBuilder: (context, index) {
                final buddy = _myBuddies[index];
                return _buildBuddyTile(context, buddy);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Request Tile Widget - Theme optimized
  Widget _buildRequestTile(BuildContext context, String name, String subtitle) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // Dark mode mein subtle dark color aur light mode mein light teal background
        color: isDark ? theme.cardColor : const Color(0xFFE0F2F1),
        borderRadius: BorderRadius.circular(16),
        border: isDark ? Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)) : null,
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=150'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)
                ),
                Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.6))
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D9488),
              minimumSize: const Size(60, 32),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: const Text('Accept', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // Active Buddy Tile Widget - Theme optimized
  Widget _buildBuddyTile(BuildContext context, Map<String, String> buddy) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(theme.brightness == Brightness.dark ? 0.2 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4)
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          radius: 22,
          backgroundImage: NetworkImage(buddy['image']!),
        ),
        title: Text(
            buddy['name']!,
            style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)
        ),
        subtitle: Text(
            buddy['status']!,
            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.6))
        ),
        trailing: IconButton(
          icon: const Icon(Icons.chat_bubble_outline_rounded, size: 20, color: Color(0xFF0D9488)),
          onPressed: () {},
        ),
      ),
    );
  }
}