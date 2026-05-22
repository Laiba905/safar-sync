import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _cities = [];
  bool _isLoading = false;
  bool _isWeatherLoading = false;
  
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(31.5204, 74.3587); // Default: Lahore
  Set<Marker> _markers = {};
  Map<String, dynamic>? _selectedCity;
  Map<String, dynamic>? _weatherData;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  // 📍 Get User's Current Location
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    
    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
    
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: _currentPosition, zoom: 14),
    ));
  }

  // 🌦️ Fetch Weather for selected location
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

  Future<void> _searchCities(String query) async {
    if (query.isEmpty) {
      setState(() => _cities = []);
      return;
    }
    setState(() => _isLoading = true);
    try {
      final url = Uri.parse(
          'https://geodb-free-service.wirefreethought.com/v1/geo/cities?namePrefix=$query&limit=5&offset=0&types=CITY');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() => _cities = data['data'] ?? []);
      }
    } catch (e) {
      debugPrint("GeoDB Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onLocationPicked(LatLng position, String title) {
    setState(() {
      _currentPosition = position;
      _markers = {
        Marker(
          markerId: const MarkerId('selected-location'),
          position: position,
          infoWindow: InfoWindow(title: title),
        ),
      };
      _selectedCity = {
        'city': title,
        'country': '',
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
    });
    _fetchWeather(position.latitude, position.longitude);
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: position, zoom: 12),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Pick Destination', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          if (_selectedCity != null)
            TextButton(
              onPressed: () => Navigator.pop(context, {
                'name': _selectedCity!['city'],
                'lat': _selectedCity!['latitude'],
                'lon': _selectedCity!['longitude'],
              }),
              child: const Text('CONFIRM', style: TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _currentPosition, zoom: 10),
            onMapCreated: (controller) {
              _mapController = controller;
              // Re-center once map is ready
              _mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition));
            },
            markers: _markers,
            onTap: (pos) => _onLocationPicked(pos, "Selected Location"),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),

          // 🔍 Search Bar Overlay
          Positioned(
            top: 15, left: 15, right: 15,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _searchCities,
                  decoration: InputDecoration(
                    hintText: 'Search city...',
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF0D9488)),
                    filled: true,
                    fillColor: theme.cardColor,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                if (_cities.isNotEmpty)
                  Card(
                    margin: const EdgeInsets.only(top: 5),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _cities.length,
                      itemBuilder: (context, index) {
                        final city = _cities[index];
                        return ListTile(
                          title: Text("${city['city']}, ${city['country']}"),
                          onTap: () {
                            _onLocationPicked(LatLng(city['latitude'], city['longitude']), city['city']);
                            _searchController.text = city['city'];
                            setState(() => _cities = []);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          // 🌦️ Weather Preview Card
          if (_selectedCity != null)
            Positioned(
              bottom: 20, left: 20, right: 20,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 10,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(colors: [const Color(0xFF0D9488), const Color(0xFF14B8A6)]),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_selectedCity!['city'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                          if (_weatherData != null)
                            Text("${_weatherData!['main']['temp'].round()}°C | ${_weatherData!['weather'][0]['description']}",
                                style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                      if (_isWeatherLoading)
                        const CircularProgressIndicator(color: Colors.white)
                      else if (_weatherData != null)
                        Image.network("https://openweathermap.org/img/wn/${_weatherData!['weather'][0]['icon']}@2x.png", width: 50),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
