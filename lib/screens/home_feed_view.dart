import 'package:flutter/material.dart';
import 'create_trip_screen.dart';
import 'trip_details_screen.dart';
import 'profile_screen.dart';
import '../main.dart';

class HomeFeedView extends StatefulWidget {
  const HomeFeedView({super.key});

  @override
  State<HomeFeedView> createState() => _HomeFeedViewState();
}

class _HomeFeedViewState extends State<HomeFeedView> {
  // Upcoming Trips List
  final List<Map<String, dynamic>> _upcomingTrips = [
    {
      'title': 'Murree Short Trip',
      'description': 'A quick weekend getaway with college friends to enjoy the weather.',
      'locationName': 'Murree, Punjab',
      'dateRange': '25 May - 28 May 2026',
      'imageUrl': 'https://images.unsplash.com/photo-1581793745862-99fde7fa73d2?w=500',
      'latitude': 33.9070,
      'longitude': 73.3943,
      'weatherTemp': '16°C',
      'weatherCondition': 'Rainy',
      'weatherHumidity': '80%',
      'weatherWind': '15 km/h',
    },
    {
      'title': 'Hunza Valley Exploration',
      'description': 'Exploring Altit and Baltit forts, Attabad lake, and Passu Cones.',
      'locationName': 'Hunza, Gilgit-Baltistan',
      'dateRange': '10 June - 18 June 2026',
      'imageUrl': 'https://images.unsplash.com/photo-1624555130581-1d9cca783bc0?w=500',
      'latitude': 36.3167,
      'longitude': 74.6500,
      'weatherTemp': '12°C',
      'weatherCondition': 'Cloudy',
      'weatherHumidity': '45%',
      'weatherWind': '8 km/h',
    }
  ];

  // Past Trips Section List
  final List<Map<String, dynamic>> _pastTrips = [
    {
      'title': 'Skardu Adventure',
      'description': 'Beautiful cold desert and Shangrila resort memories.',
      'locationName': 'Skardu, Baltistan',
      'dateRange': '12 Aug - 18 Aug 2025',
      'imageUrl': 'https://images.unsplash.com/photo-1589308078059-be1415eab4c3?w=500',
      'latitude': 35.2981,
      'longitude': 75.6333,
      'weatherTemp': '22°C',
      'weatherCondition': 'Sunny',
      'weatherHumidity': '40%',
      'weatherWind': '10 km/h',
    }
  ];

  void _navigateToCreateTrip() async {
    final newTrip = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateTripScreen()),
    );

    if (newTrip != null && newTrip is Map<String, dynamic>) {
      setState(() {
        if (newTrip['imageUrl'] == null) {
          newTrip['imageUrl'] = 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=500';
        }
        _upcomingTrips.insert(0, newTrip);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('SafarSync', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          ValueListenableBuilder<String>(
            valueListenable: profileImageNotifier,
            builder: (context, currentImg, _) {
              return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen())),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(currentImg),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Section 1: Upcoming Trips ---
            Text('Upcoming Trips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
            const SizedBox(height: 12),
            _upcomingTrips.isEmpty
                ? const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Text('No upcoming trips planned yet.'))
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _upcomingTrips.length,
              itemBuilder: (context, index) => _buildTripCard(context, _upcomingTrips[index], theme),
            ),

            const SizedBox(height: 24),

            // --- Section 2: Past Trips ---
            Text('Past Trips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface.withValues(alpha: 0.7))),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _pastTrips.length,
              itemBuilder: (context, index) => _buildTripCard(context, _pastTrips[index], theme, isPast: true),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateTrip,
        backgroundColor: const Color(0xFF0D9488),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }

  Widget _buildTripCard(BuildContext context, Map<String, dynamic> trip, ThemeData theme, {bool isPast = false}) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TripDetailsScreen(trip: trip))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(image: NetworkImage(trip['imageUrl']), fit: BoxFit.cover),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Colors.black.withValues(alpha: 0.1), Colors.black.withValues(alpha: 0.85)],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                    child: Text(trip['dateRange'] ?? 'Dates', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isPast ? Colors.grey.withValues(alpha: 0.6) : const Color(0xFF0D9488),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(_getWeatherIcon(trip['weatherCondition'] ?? ''), size: 14, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(trip['weatherTemp'] ?? 'N/A', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(trip['title'] ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 4),
              Text(trip['description'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.8))),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.location_on_rounded, size: 16, color: Color(0xFF0D9488)),
                  const SizedBox(width: 4),
                  Expanded(child: Text(trip['locationName'] ?? '', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.9)))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String condition) {
    if (condition.toLowerCase() == 'rainy') return Icons.umbrella_rounded;
    if (condition.toLowerCase() == 'cloudy') return Icons.cloud_rounded;
    return Icons.wb_sunny_rounded;
  }
}