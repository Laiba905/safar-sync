import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  final String name;
  final String email;
  final String phoneNumber;
  final List<String> friends;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber = '',
    this.friends = const [],
    this.avatarUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      friends: List<String>.from(data['friends'] ?? []),
      avatarUrl: data['avatarUrl'],
    );
  }
}
