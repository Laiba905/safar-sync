import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Placeholder static data to perfectly match the UI preview
  final List<Map<String, dynamic>> _upcomingTrips = [
    {
      'title': 'Summer in Amalfi',
      'location': 'Italy • 7 Days',
      'daysLeft': 'In 12 Days',
      'image': 'https://images.unsplash.com/photo-1533900298318-6b8da08a523e?q=80&w=500&auto=format&fit=crop',
      'buddies': 3,
    },
    {
      'title': 'Kyoto Serenity',
      'location': 'Japan • 9 Days',
      'daysLeft': 'Nov 14 - Nov 22',
      'image': 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?q=80&w=500&auto=format&fit=crop',
      'buddies': 2,
    },
    {
      'title': 'Greek Islands',
      'location': 'Greece • 8 Days',
      'daysLeft': 'Dec 02 - Dec 10',
      'image': 'https://images.unsplash.com/photo-1533105079780-92b9be482077?q=80&w=500&auto=format&fit=crop',
      'buddies': 1,
    }
  ];

  final List<Map<String, String>> _pastTrips = [
    {
      'title': 'Winter in Moscow',
      'details': 'Jan 2024 • 5 Travelers',
      'image': 'https://images.unsplash.com/photo-1513326738677-b964603b136d?q=80&w=150&auto=format&fit=crop'
    },
    {
      'title': 'Parisian Escape',
      'details': 'Oct 2023 • Solo',
      'image': 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=150&auto=format&fit=crop'
    }
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Clean off-white background from reference

      // 1. App Bar Configuration
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.black87),
          onPressed: () {},
        ),
        title: const Text(
          'SafarSync',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 20),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=100&auto=format&fit=crop'),
            ),
          )
        ],
      ),

      // 2. Main Dashboard Body (Scrollable Layout)
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWeb = constraints.maxWidth > 600;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWeb ? MediaQuery.of(context).size.width * 0.2 : 20.0,
              vertical: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Upcoming Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Upcoming Adventures',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('View All', style: TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                const SizedBox(height: 10),

                // Upcoming Feed List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _upcomingTrips.length,
                  itemBuilder: (context, index) {
                    final trip = _upcomingTrips[index];
                    return _buildUpcomingCard(trip);
                  },
                ),

                const SizedBox(height: 24),
                // Past Section Header
                const Text(
                  'Past Journeys',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 16),

                // Past Feed List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _pastTrips.length,
                  itemBuilder: (context, index) {
                    final pastTrip = _pastTrips[index];
                    return _buildPastTile(pastTrip);
                  },
                ),
                const SizedBox(height: 80), // Spatial safety margin for FAB
              ],
            ),
          );
        },
      ),

      // 3. Compact Circular Action Floating Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Bottom sheet framework link matches previous module perfectly
        },
        backgroundColor: const Color(0xFF00695C), // Premium deep teal green matching image
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
      ),

      // 4. Stylized Bottom Navigation Row
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0D9488),
        unselectedItemColor: Colors.grey.shade500,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'Trips'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline_rounded), label: 'Buddies'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
        ],
      ),
    );
  }

  // Card Widget Builder for Upcoming Adventures
  Widget _buildUpcomingCard(Map<String, dynamic> trip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Image Section with Floating Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
                child: Image.network(
                  trip['image'],
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF80F1E3).withValues(alpha: 0.9), // Bright soft teal badge
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    trip['daysLeft'],
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF004D40)),
                  ),
                ),
              ),
            ],
          ),

          // Metadata Content Segment
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip['title'],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(trip['location'], style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                      ],
                    ),
                  ],
                ),

                // Overlapped Avatars Stack Mockup
                _buildAvatarStack(trip['buddies']),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Quick helper widget for stacked overlay profile miniatures
  Widget _buildAvatarStack(int buddyCount) {
    return SizedBox(
      width: 65,
      height: 28,
      child: Stack(
        children: [
          const Positioned(
            left: 0,
            child: CircleAvatar(
              radius: 13,
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=100&auto=format&fit=crop'),
            ),
          ),
          if (buddyCount > 1)
            const Positioned(
              left: 14,
              child: CircleAvatar(
                radius: 13,
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=100&auto=format&fit=crop'),
              ),
            ),
          if (buddyCount > 2)
            Positioned(
              left: 28,
              child: CircleAvatar(
                radius: 13,
                backgroundColor: Colors.grey.shade200,
                child: const Text('+2', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black54)),
              ),
            ),
        ],
      ),
    );
  }

  // Row Tile Widget Builder for Past Journeys
  Widget _buildPastTile(Map<String, String> pastTrip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.network(
            pastTrip['image']!,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          pastTrip['title']!,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            pastTrip['details']!,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade400),
        onTap: () {},
      ),
    );
  }
}