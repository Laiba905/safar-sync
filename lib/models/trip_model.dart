import 'package:cloud_firestore/cloud_firestore.dart';

class TripModel {
  final String id;
  final String title;
  final String description;
  final String createdBy;
  final String destination;
  final double latitude;
  final double longitude;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> members;
  final DateTime createdAt;
  final String? imageUrl;

  TripModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.destination,
    required this.latitude,
    required this.longitude,
    required this.startDate,
    required this.endDate,
    required this.members,
    required this.createdAt,
    this.imageUrl,
  });

  factory TripModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    // Safely parse timestamps with a fallback
    DateTime parseTime(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
      return DateTime.now(); // Fallback for null or unexpected types
    }

    return TripModel(
      id: doc.id,
      title: data['title'] ?? data['destination'] ?? 'Untitled Trip',
      description: data['description'] ?? '',
      createdBy: data['createdBy'] ?? '',
      destination: data['destination'] ?? 'Unknown',
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
      startDate: parseTime(data['startDate']),
      endDate: parseTime(data['endDate']),
      members: (data['members'] as List?)?.map((e) => e.toString()).toList() ?? [],
      createdAt: parseTime(data['createdAt']),
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdBy': createdBy,
      'destination': destination,
      'latitude': latitude,
      'longitude': longitude,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'members': members,
      'createdAt': FieldValue.serverTimestamp(),
      'imageUrl': imageUrl,
    };
  }
}
