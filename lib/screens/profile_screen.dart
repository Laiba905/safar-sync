import 'package:flutter/material.dart';
import '../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Edit name dialog handler
  void _showEditNameDialog() {
    final theme = Theme.of(context);
    final controller = TextEditingController(text: profileNameNotifier.value);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardColor,
        title: const Text('Edit Name', style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF0D9488)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                profileNameNotifier.value = controller.text.trim();
                setState(() {});
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D9488)),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        child: Column(
          children: [
            // --- Profile Image Layout Stack ---
            Center(
              child: Stack(
                children: [
                  ValueListenableBuilder<String>(
                    valueListenable: profileImageNotifier,
                    builder: (context, currentImg, _) {
                      return CircleAvatar(
                        radius: 55,
                        backgroundImage: NetworkImage(currentImg),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(0xFF0D9488),
                      child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // --- Name Edit Widget Row ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 32),
                ValueListenableBuilder<String>(
                  valueListenable: profileNameNotifier,
                  builder: (context, currentName, _) {
                    return Text(
                      currentName,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 18, color: Color(0xFF0D9488)),
                  onPressed: _showEditNameDialog,
                ),
              ],
            ),
            Text(
              'ayesha.cs@gmail.com',
              style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5)),
            ),
            const SizedBox(height: 32),

            // --- Main Options Box Container ---
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // Appearance Settings Switch
                  SwitchListTile.adaptive(
                    secondary: const Icon(Icons.dark_mode_outlined, color: Color(0xFF0D9488)),
                    title: const Text('Dark Appearance'),
                    value: themeNotifier.value == ThemeMode.dark,
                    activeColor: const Color(0xFF0D9488),
                    onChanged: (val) {
                      themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                      setState(() {});
                    },
                  ),
                  const Divider(height: 1),

                  // Phone Number Display Item
                  ListTile(
                    leading: const Icon(Icons.phone_android_rounded, color: Color(0xFF0D9488)),
                    title: const Text('Phone Number'),
                    trailing: Text(
                      '+92 300 1234567',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ),
                  const Divider(height: 1),

                  // Member Since Display Item
                  ListTile(
                    leading: const Icon(Icons.calendar_today_rounded, color: Color(0xFF0D9488)),
                    title: const Text('Member Since'),
                    trailing: Text(
                      'May 2026',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- Logout Button Architecture ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.1),
                  foregroundColor: Colors.red,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logging Out...')),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Log Out',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}