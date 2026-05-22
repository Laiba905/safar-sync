import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'create_trip_screen.dart';
import 'trip_details_screen.dart';
import 'profile_screen.dart';
import '../providers/trip_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/network_provider.dart';
import '../models/trip_model.dart';
import '../main.dart';
import 'package:intl/intl.dart';

class HomeFeedView extends StatefulWidget {
  const HomeFeedView({super.key});

  @override
  State<HomeFeedView> createState() => _HomeFeedViewState();
}

class _HomeFeedViewState extends State<HomeFeedView> {
  @override
  void initState() {
    super.initState();
    // Data is now initialized in HomeScreen to avoid conflicts
  }

  void _navigateToCreateTrip() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateTripScreen()),
    );
  }

  // 🗺️ Map location open function
  Future<void> _openMap(double lat, double lon) async {
    final String urlString = "https://www.google.com/maps/search/?api=1&query=$lat,$lon";
    try {
      if (await canLaunchUrlString(urlString)) {
        await launchUrlString(urlString, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Error launching map: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tripProvider = Provider.of<TripProvider>(context);
    final trips = tripProvider.trips;

    final now = DateTime.now();
    final upcomingTrips = trips.where((t) => t.endDate.isAfter(now)).toList();
    final pastTrips = trips.where((t) => t.endDate.isBefore(now)).toList();

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
      body: tripProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF0D9488)))
          : RefreshIndicator(
        onRefresh: () async {
          final userId = Provider.of<AuthProvider>(context, listen: false).user?.uid;
          if (userId != null) {
            Provider.of<TripProvider>(context, listen: false).fetchUserTrips(userId);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Section 1: Upcoming Trips ---
              Text('Upcoming Trips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
              const SizedBox(height: 12),
              upcomingTrips.isEmpty
                  ? const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Text('No upcoming trips planned yet.'))
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: upcomingTrips.length,
                itemBuilder: (context, index) => _buildTripCard(context, upcomingTrips[index], theme),
              ),

              const SizedBox(height: 24),

              // --- Section 2: Past Trips ---
              if (pastTrips.isNotEmpty) ...[
                Text('Past Trips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface.withValues(alpha: 0.7))),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pastTrips.length,
                  itemBuilder: (context, index) => _buildTripCard(context, pastTrips[index], theme, isPast: true),
                ),
              ],
            ],
          ),
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

  // 📄 TRIP CARD WIDGET WITH WEATHER BUTTON INTEGRATION
  Widget _buildTripCard(BuildContext context, TripModel trip, ThemeData theme, {bool isPast = false}) {
    final dateRange = "${DateFormat('dd MMM').format(trip.startDate)} - ${DateFormat('dd MMM yyyy').format(trip.endDate)}";

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TripDetailsScreen(trip: {
        'id': trip.id,
        'title': trip.title,
        'description': trip.description,
        'destination': trip.destination,
        'latitude': trip.latitude,
        'longitude': trip.longitude,
        'members': trip.members,
        'startDate': trip.startDate,
        'endDate': trip.endDate,
        'createdBy': trip.createdBy,
        'imageUrl': trip.imageUrl,
      }))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
              image: NetworkImage(trip.imageUrl ?? 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=500'),
              fit: BoxFit.cover
          ),
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
                    child: Text(dateRange, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),

                  // ☀️ WEATHER ICON: Navigates to Weather Tab in Details
                  if (!isPast)
                    Row(
                      children: [
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.wb_sunny_rounded, color: Colors.amber, size: 20),
                            onPressed: () {
                              String formattedDate = "${trip.startDate.year}-${trip.startDate.month.toString().padLeft(2, '0')}-${trip.startDate.day.toString().padLeft(2, '0')}";
                              Provider.of<TripProvider>(context, listen: false).fetchWeatherForTripDay(
                                  trip.latitude,
                                  trip.longitude,
                                  formattedDate
                              );

                              Navigator.push(context, MaterialPageRoute(builder: (context) => TripDetailsScreen(trip: {
                                'id': trip.id,
                                'title': trip.title,
                                'description': trip.description,
                                'destination': trip.destination,
                                'latitude': trip.latitude,
                                'longitude': trip.longitude,
                                'members': trip.members,
                                'startDate': trip.startDate,
                                'endDate': trip.endDate,
                                'createdBy': trip.createdBy,
                                'imageUrl': trip.imageUrl,
                              })));
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 🗺️ MAP ICON: Opens external map
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.map_rounded, color: Color(0xFF0D9488), size: 20),
                            onPressed: () => _openMap(trip.latitude, trip.longitude),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const Spacer(),
              Text(trip.title.isNotEmpty ? trip.title : trip.destination,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.location_on_rounded, size: 16, color: Color(0xFF0D9488)),
                  const SizedBox(width: 4),
                  Expanded(child: Text(trip.destination, style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.9)))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}