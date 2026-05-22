import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'map_picker_screen.dart';
import '../providers/trip_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/network_provider.dart';
import '../models/user_model.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

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
  Map<String, dynamic>? _weatherData;
  bool _isWeatherLoading = false;
  
  DateTime _startDate = DateTime.now().add(const Duration(days: 7));
  DateTime _endDate = DateTime.now().add(const Duration(days: 10));

  final List<UserModel> _selectedFriends = [];

  // 🌦️ Fetch Weather for the selected location
  Future<void> _fetchWeather(double lat, double lon) async {
    setState(() => _isWeatherLoading = true);
    const apiKey = '8db9f34f7196cf047249a56c3866c891'; 
    try {
      final url = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() => _weatherData = json.decode(response.body));
      }
    } catch (e) {
      debugPrint("Weather Error: $e");
    } finally {
      setState(() => _isWeatherLoading = false);
    }
  }

  void _showFriendSelector() {
    final networkProvider = Provider.of<NetworkProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Add Friends to Trip', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Expanded(
                    child: networkProvider.friends.isEmpty 
                      ? const Center(child: Text("No friends to add"))
                      : ListView.builder(
                          itemCount: networkProvider.friends.length,
                          itemBuilder: (context, index) {
                            final friend = networkProvider.friends[index];
                            final isSelected = _selectedFriends.any((f) => f.id == friend.id);
                            return ListTile(
                              leading: CircleAvatar(child: Text(friend.name[0])),
                              title: Text(friend.name),
                              trailing: Icon(
                                isSelected ? Icons.check_circle : Icons.add_circle_outline,
                                color: isSelected ? const Color(0xFF0D9488) : null,
                              ),
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedFriends.removeWhere((f) => f.id == friend.id);
                                  } else {
                                    _selectedFriends.add(friend);
                                  }
                                });
                                setModalState(() {}); // Refresh modal UI
                              },
                            );
                          },
                        ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D9488)),
                      child: const Text('Done', style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            );
          }
        );
      },
    );
  }

  void _pickLocationFromMap() async {
    final result = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const MapPickerScreen())
    );
    
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _selectedLocationName = result['name'];
        _latitude = result['lat'];
        _longitude = result['lon'];
      });
      _fetchWeather(result['lat'], result['lon']);
    }
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF0D9488)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _handleCreateTrip() async {
    if (!_formKey.currentState!.validate() || _selectedLocationName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all details and select a location'))
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final tripProvider = Provider.of<TripProvider>(context, listen: false);

    if (authProvider.user == null) return;

    bool success = await tripProvider.createNewTrip(
      creatorId: authProvider.user!.uid,
      title: _titleController.text,
      description: _descController.text,
      destination: _selectedLocationName!,
      latitude: _latitude!,
      longitude: _longitude!,
      startDate: _startDate,
      endDate: _endDate,
      memberIds: [authProvider.user!.uid, ..._selectedFriends.map((f) => f.id)],
    );

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trip Created Successfully!'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = Provider.of<TripProvider>(context).isLoading;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Plan New Trip', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Trip Title', theme),
              TextFormField(
                controller: _titleController,
                decoration: _inputDecoration('e.g., Summer in Hunza', theme),
                validator: (val) => val!.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 20),

              _buildLabel('Description', theme),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: _inputDecoration('Tell us about your plans...', theme),
                validator: (val) => val!.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 24),

              _buildLabel('Destination', theme),
              InkWell(
                onTap: _pickLocationFromMap,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _selectedLocationName != null ? const Color(0xFF0D9488) : theme.dividerColor),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.map_rounded, color: Color(0xFF0D9488)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          _selectedLocationName ?? 'Select Location from Map',
                          style: TextStyle(
                            fontWeight: _selectedLocationName != null ? FontWeight.bold : FontWeight.normal,
                            color: _selectedLocationName != null ? theme.colorScheme.onSurface : theme.hintColor
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right, size: 20),
                    ],
                  ),
                ),
              ),

              if (_weatherData != null)
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D9488).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Image.network("https://openweathermap.org/img/wn/${_weatherData!['weather'][0]['icon']}.png", width: 40),
                      const SizedBox(width: 10),
                      Text(
                        "${_weatherData!['main']['temp'].round()}°C - ${_weatherData!['weather'][0]['description']}",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                      ),
                    ],
                  ),
                ),
              if (_isWeatherLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: LinearProgressIndicator(color: Color(0xFF0D9488)),
                ),

              const SizedBox(height: 20),

              _buildLabel('Travel Dates', theme),
              InkWell(
                onTap: _selectDateRange,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, color: Color(0xFF0D9488)),
                      const SizedBox(width: 16),
                      Text(
                        "${DateFormat('dd MMM').format(_startDate)} - ${DateFormat('dd MMM yyyy').format(_endDate)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _buildLabel('Trip Buddies', theme),
              InkWell(
                onTap: _showFriendSelector,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _selectedFriends.isNotEmpty ? const Color(0xFF0D9488) : theme.dividerColor),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.group_add_rounded, color: Color(0xFF0D9488)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          _selectedFriends.isEmpty 
                              ? 'Add Friends to Trip' 
                              : '${_selectedFriends.length} Friends Selected',
                          style: TextStyle(
                            fontWeight: _selectedFriends.isNotEmpty ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      const Icon(Icons.add_circle_outline, size: 20),
                    ],
                  ),
                ),
              ),
              if (_selectedFriends.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Wrap(
                    spacing: 8,
                    children: _selectedFriends.map((f) => Chip(
                      label: Text(f.name, style: const TextStyle(fontSize: 12)),
                      onDeleted: () => setState(() => _selectedFriends.remove(f)),
                      deleteIconColor: Colors.redAccent,
                    )).toList(),
                  ),
                ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleCreateTrip,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Create Trip', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
    );
  }

  InputDecoration _inputDecoration(String hint, ThemeData theme) {
    return InputDecoration(
      hintText: hint,
      fillColor: theme.cardColor,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.1))
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF0D9488))
      ),
    );
  }
}
