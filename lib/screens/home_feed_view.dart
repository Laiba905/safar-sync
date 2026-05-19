import 'package:flutter/material.dart';
//import 'profile_screen.dart';

class HomeFeedView extends StatelessWidget {
  const HomeFeedView({super.key});

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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              // onTap: () {
              //   // Route seamlessly push to Profile management window overlay
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => const ProfileScreen()),
              //   );
              // },
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=100&auto=format&fit=crop'),
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
              crossAxisAlignment:  CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Upcoming Adventures', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
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
                  itemBuilder: (context, index) => _buildUpcomingCard(_upcomingTrips[index]),
                ),
                const SizedBox(height: 24),
                const Text('Past Journeys', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
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

  Widget _buildUpcomingCard(Map<String, dynamic> trip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
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
                    Text(trip['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
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
                backgroundColor: Colors.grey.shade200,
                child: const Text('+2', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black54)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPastTile(BuildContext context, Map<String, String> pastTrip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.network(pastTrip['image']!, width: 48, height: 48, fit: BoxFit.cover),
        ),
        title: Text(pastTrip['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(pastTrip['details']!, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade400),
        onTap: () {},
      ),
    );
  }
}