import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Local state variable for profile picture
  String _profileImage = 'data:image/jpeg;base64,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';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PopScope(
      // When user presses hardware back or custom back button, it passes the current image back
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pop(_profileImage);
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.colorScheme.onSurface),
            onPressed: () => Navigator.of(context).pop(_profileImage),
          ),
          title: Text(
            'My Profile',
            style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface, fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 👤 Profile Header Section
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(_profileImage),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          // Simulating picture change (Mahnoor will wire ImagePicker here)
                          setState(() {
                            _profileImage = 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200';
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Mock Picture Updated! Now go back to check.')),
                          );
                        },
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: Color(0xFF0D9488),
                          child: Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Ayesha Khan',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
              ),
              const SizedBox(height: 4),
              Text(
                'ayesha.cs@gmail.com',
                style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              ),
              const SizedBox(height: 24),

              // 📊 Travel Stats Row Card
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.08)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('3', 'Upcoming', theme),
                    Container(height: 30, width: 1, color: theme.colorScheme.onSurface.withValues(alpha: 0.15)),
                    _buildStatItem('5', 'Past Trips', theme),
                    Container(height: 30, width: 1, color: theme.colorScheme.onSurface.withValues(alpha: 0.15)),
                    _buildStatItem('12', 'Buddies', theme),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 🛠️ Settings List Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Account Settings',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface.withValues(alpha: 0.8)),
                ),
              ),
              const SizedBox(height: 12),

              _buildSettingTile(Icons.phone_outlined, 'Phone Number', '+92 300 1234567', theme),
              _buildSettingTile(Icons.directions_car_filled_outlined, 'Travel Role', 'Passenger', theme),
              _buildSettingTile(Icons.calendar_today_rounded, 'Member Since', 'May 2026', theme),

              const SizedBox(height: 24),

              // 🚪 Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.red.withValues(alpha: 0.1) : const Color(0xFFFFEBEE),
                    foregroundColor: Colors.redAccent.shade700,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded, color: Colors.redAccent.shade700),
                      const SizedBox(width: 8),
                      const Text('Log Out', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label, ThemeData theme) {
    return Column(
      children: [
        Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
      ],
    );
  }

  Widget _buildSettingTile(IconData icon, String title, String value, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.06)),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0D9488)),
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        trailing: Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
        ),
      ),
    );
  }
}