import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  final String id;
  final String description;
  final double amount;
  final String payerId;
  final String payerName;
  final List<String> splitAmong;
  final double sharePerPerson;
  final DateTime timestamp;

  ExpenseModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.payerId,
    required this.payerName,
    required this.splitAmong,
    required this.sharePerPerson,
    required this.timestamp,
  });

  factory ExpenseModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ExpenseModel(
      id: doc.id,
      description: data['description'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      payerId: data['payerId'] ?? data['paidBy'] ?? '', // Fallback for old data
      payerName: data['payerName'] ?? data['paidBy'] ?? 'Unknown',
      splitAmong: List<String>.from(data['splitAmong'] ?? []),
      sharePerPerson: (data['sharePerPerson'] ?? 0.0).toDouble(),
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
