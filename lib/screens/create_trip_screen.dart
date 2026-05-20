import 'package:flutter/material.dart';
import 'map_picker_screen.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  String? _selectedLocationName;
  double? _latitude;
  double? _longitude;
  String? _weatherTemp;
  String? _weatherCondition;

  void _pickLocationFromMap() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const MapPickerScreen()));
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _selectedLocationName = result['name'];
        _latitude = result['lat'];
        _longitude = result['lon'];
        _weatherTemp = result['temp'];
        _weatherCondition = result['condition'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Create New Trip', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: theme.scaffoldBackgroundColor, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Trip Title', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
              const SizedBox(height: 8),
              TextFormField(controller: _titleController, decoration: _inputDecoration('e.g., Summer Vacation', theme), validator: (val) => val!.isEmpty ? 'Empty' : null),
              const SizedBox(height: 20),
              Text('Description', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
              const SizedBox(height: 8),
              TextFormField(controller: _descController, maxLines: 3, decoration: _inputDecoration('Tell us about your plans...', theme), validator: (val) => val!.isEmpty ? 'Empty' : null),
              const SizedBox(height: 24),
              InkWell(
                onTap: _pickLocationFromMap,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF0D9488))),
                  child: Row(
                    children: [
                      const Icon(Icons.map_rounded, color: Color(0xFF0D9488)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_selectedLocationName ?? 'Select Location from Map', style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(_weatherTemp != null ? 'Weather: $_weatherTemp ($_weatherCondition)' : 'Tap to open maps preview', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.5))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _selectedLocationName != null) {
                      Navigator.pop(context, {
                        'title': _titleController.text,
                        'description': _descController.text,
                        'locationName': _selectedLocationName,
                        'dateRange': '20 May - 24 May 2026',
                        'weatherTemp': _weatherTemp,
                        'weatherCondition': _weatherCondition,
                        'weatherHumidity': '55%',
                        'weatherWind': '12 km/h',
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D9488), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  child: const Text('Create Trip', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, ThemeData theme) {
    return InputDecoration(
      hintText: hint, fillColor: theme.cardColor, filled: true,
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.08))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF0D9488))),
    );
  }
}