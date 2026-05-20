import 'package:flutter/material.dart';

class TripDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> trip;
  const TripDetailsScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Trip Details', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: theme.scaffoldBackgroundColor, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(trip['title'] ?? '', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(trip['locationName'] ?? '', style: const TextStyle(fontSize: 16, color: Color(0xFF0D9488), fontWeight: FontWeight.w500)),
            const Divider(height: 32),
            Text('Weather Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface.withOpacity(0.8))),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildWeatherBlock('Temperature', trip['weatherTemp'] ?? 'N/A', Icons.thermostat, theme),
                      _buildWeatherBlock('Condition', trip['weatherCondition'] ?? 'N/A', Icons.wb_cloudy_rounded, theme),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildWeatherBlock('Wind Speed', trip['weatherWind'] ?? 'N/A', Icons.air, theme),
                      _buildWeatherBlock('Humidity', trip['weatherHumidity'] ?? 'N/A', Icons.water_drop, theme),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Description', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(trip['description'] ?? '', style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withOpacity(0.7), height: 1.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherBlock(String label, String val, IconData icon, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF0D9488)),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withOpacity(0.5))), Text(val, style: const TextStyle(fontWeight: FontWeight.bold))]),
      ],
    );
  }
}