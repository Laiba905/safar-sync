import 'package:flutter/material.dart';
import 'profile_screen.dart';

class HomeFeedView extends StatefulWidget {
  const HomeFeedView({super.key});

  @override
  State<HomeFeedView> createState() => _HomeFeedViewState();
}

class _HomeFeedViewState extends State<HomeFeedView> {
  // Global reference variable keeping check on user's active photo state
  String _currentHomeAvatar = 'data:image/jpeg;base64,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';

  // State modification method updates parent view reference cleanly
  void _updateAvatarData(String newImageUri) {
    setState(() {
      _currentHomeAvatar = newImageUri;
    });
  }

  // Mock datasets matching your premium layout preview
  final List<Map<String, dynamic>> _upcomingTrips = const [
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

  final List<Map<String, String>> _pastTrips = const [
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
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.menu_rounded, color: theme.colorScheme.onSurface),
          onPressed: () {},
        ),
        title: Text(
          'SafarSync',
          style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface, fontSize: 20),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () async {
                // Awaiting return value from the ProfileScreen stack pop
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );

                // If result is sent back, refresh home picture dynamically
                if (result != null && result is String) {
                  _updateAvatarData(result);
                }
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(_currentHomeAvatar),
              ),
            ),
          )
        ],
      ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Upcoming Adventures',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('View All', style: TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _upcomingTrips.length,
                  itemBuilder: (context, index) => _buildUpcomingCard(context, _upcomingTrips[index]),
                ),
                const SizedBox(height: 24),
                Text(
                  'Past Journeys',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _pastTrips.length,
                  itemBuilder: (context, index) => _buildPastTile(context, _pastTrips[index]),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUpcomingCard(BuildContext context, Map<String, dynamic> trip) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(theme.brightness == Brightness.dark ? 0.3 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
                child: Image.network(trip['image'], height: 180, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xFF80F1E3), borderRadius: BorderRadius.circular(20)),
                  child: Text(trip['daysLeft'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF004D40))),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trip['title'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                        const SizedBox(width: 4),
                        Text(trip['location'], style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 13)),
                      ],
                    ),
                  ],
                ),
                _buildAvatarStack(trip['buddies']),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAvatarStack(int buddyCount) {
    return SizedBox(
      width: 65,
      height: 28,
      child: Stack(
        children: [
          const Positioned(
            left: 0,
            child: CircleAvatar(radius: 13, backgroundImage: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=100')),
          ),
          if (buddyCount > 1)
            const Positioned(
              left: 14,
              child: CircleAvatar(radius: 13, backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=100')),
            ),
          if (buddyCount > 2)
            Positioned(
              left: 28,
              child: CircleAvatar(
                radius: 13,
                backgroundColor: Colors.grey.shade300,
                child: const Text('+2', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black54)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPastTile(BuildContext context, Map<String, String> pastTrip) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.network(pastTrip['image']!, width: 48, height: 48, fit: BoxFit.cover),
        ),
        title: Text(pastTrip['title']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: theme.colorScheme.onSurface)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(pastTrip['details']!, style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 12)),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
        onTap: () {},
      ),
    );
  }
}