import 'package:flutter/material.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Map Location Picker'), backgroundColor: theme.scaffoldBackgroundColor, elevation: 0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map_outlined, size: 80, color: Color(0xFF0D9488)),
            const SizedBox(height: 16),
            Text('Google Maps View Simulation Container', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6))),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'name': 'Murree, Pakistan',
                  'lat': 33.9070, 'lon': 73.3943,
                  'temp': '18°C', 'condition': 'Sunny'
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D9488)),
              child: const Text('Mock Select: Murree (18°C)', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}