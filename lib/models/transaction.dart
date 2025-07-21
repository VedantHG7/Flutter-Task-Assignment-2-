import 'package:uuid/uuid.dart';

enum TransactionType { credit, debit }
enum TransactionCategory { food, transport, entertainment, salary, bills, other }

class Transaction {
final String id;
final double amount;
final String title;
final TransactionType type;
final DateTime date;
final TransactionCategory category;

Transaction({
  String? id,
  required this.amount,
  required this.title,
  required this.type,
  required this.date,
  required this.category,
}) : id = id ?? const Uuid().v4();

// Factory constructor to create a Transaction from a Map (e.g., from JSON)
factory Transaction.fromJson(Map<String, dynamic> json) {
  return Transaction(
    id: json['id'] as String,
    amount: (json['amount'] as num).toDouble(),
    title: json['title'] as String,
    type: TransactionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type']),
    date: DateTime.parse(json['date'] as String),
    category: TransactionCategory.values.firstWhere(
        (e) => e.toString().split('.').last == json['category']),
  );
}

// Convert a Transaction to a Map (e.g., for JSON serialization)
Map<String, dynamic> toJson() {
  return {
    'id': id,
    'amount': amount,
    'title': title,
    'type': type.toString().split('.').last,
    'date': date.toIso8601String(),
    'category': category.toString().split('.').last,
  };
}

// For easy copying and updating
Transaction copyWith({
  String? id,
  double? amount,
  String? title,
  TransactionType? type,
  DateTime? date,
  TransactionCategory? category,
}) {
  return Transaction(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    title: title ?? this.title,
    type: type ?? this.type,
    date: date ?? this.date,
    category: category ?? this.category,
  );
}
}
