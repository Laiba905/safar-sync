import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      // Custom Sleek App Bar
      appBar: AppBar(
        automaticallyImplyLeading: false, // Back arrow hidden on home dashboard
        title: Row(
          children: [
            Image.asset('assets/images/logo1.png', height: 35),
            const SizedBox(width: 10),
            Text(
              'SafarSync',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {
              // Friend requests notification screen open karne ke liye logic
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              // Sign out logic
              Navigator.of(context).pushReplacementNamed('/'); // Back to login splash flow
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          indicatorColor: theme.colorScheme.primary,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(icon: Icon(Icons.explore_outlined), text: "Upcoming Trips"),
            Tab(icon: Icon(Icons.history_toggle_off_rounded), text: "Past History"),
          ],
        ),
      ),

      // Dashboard Body Panels
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWeb = constraints.maxWidth > 600;
          return TabBarView(
            controller: _tabController,
            children: [
              _buildTripList(isUpcoming: true, isWeb: isWeb),
              _buildTripList(isUpcoming: false, isWeb: isWeb),
            ],
          );
        },
      ),

      // FAB for creating new trip
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Open Create Trip Sheet/Form
        },
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Plan New Trip'),
      ),

      // Bottom Navigation for main module routing
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.onSurface.withValues(alpha: 0.4),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            // Handle cross screen navigation (e.g., index 1 will open Travel Buddies list)
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_max_rounded),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: 'Travel Buddies',
          ),
        ],
      ),
    );
  }

  // Helper Widget to render Grid or List view dynamically according to device width
  Widget _buildTripList({required bool isUpcoming, required bool isWeb}) {
    // Temporary hardcoded structural layout data
    final dummyTrips = isUpcoming
        ? [
      {'title': 'Hunza Valley Expedition', 'date': 'June 15 - June 22, 2026', 'buddies': '3 Friends Syncing'},
      {'title': 'Islamabad Dev Meetup', 'date': 'July 02 - July 05, 2026', 'buddies': '2 Friends Syncing'}
    ]
        : [
      {'title': 'Murree Winter Getaway', 'date': 'Jan 10 - Jan 14, 2026', 'buddies': 'Solo Trip'}
    ];

    return ListView.builder(
      padding: EdgeInsets.symmetric(
          horizontal: isWeb ? MediaQuery.of(context).size.width * 0.2 : 16.0,
          vertical: 16.0
      ),
      itemCount: dummyTrips.length,
      itemBuilder: (context, index) {
        final trip = dummyTrips[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
              child: Icon(Icons.flight_takeoff_rounded, color: Theme.of(context).colorScheme.secondary),
            ),
            title: Text(
              trip['title']!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(trip['date']!, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.sync_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(trip['buddies']!, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onTap: () {
              // Master Trip Inner Hub routing executes here
            },
          ),
        );
      },
    );
  }
}