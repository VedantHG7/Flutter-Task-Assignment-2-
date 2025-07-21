import 'package:transactions_app/models/transaction.dart';
// Removed unused import: import 'dart:math';

class TransactionService {
// Simulate a database/API with an in-memory list
final List<Transaction> _transactions = [
  Transaction(
    amount: 50.00,
    title: 'Groceries',
    type: TransactionType.debit,
    date: DateTime.now().subtract(const Duration(days: 2)),
    category: TransactionCategory.food,
  ),
  Transaction(
    amount: 1200.00,
    title: 'Monthly Salary',
    type: TransactionType.credit,
    date: DateTime.now().subtract(const Duration(days: 5)),
    category: TransactionCategory.salary,
  ),
  Transaction(
    amount: 15.50,
    title: 'Bus Fare',
    type: TransactionType.debit,
    date: DateTime.now().subtract(const Duration(days: 1)),
    category: TransactionCategory.transport,
  ),
  Transaction(
    amount: 30.00,
    title: 'Movie Tickets',
    type: TransactionType.debit,
    date: DateTime.now().subtract(const Duration(days: 3)),
    category: TransactionCategory.entertainment,
  ),
  Transaction(
    amount: 75.00,
    title: 'Dinner with Friends',
    type: TransactionType.debit,
    date: DateTime.now().subtract(const Duration(days: 0)),
    category: TransactionCategory.food,
  ),
  Transaction(
    amount: 200.00,
    title: 'Freelance Payment',
    type: TransactionType.credit,
    date: DateTime.now().subtract(const Duration(days: 10)),
    category: TransactionCategory.other,
  ),
  Transaction(
    amount: 80.00,
    title: 'Electricity Bill',
    type: TransactionType.debit,
    date: DateTime.now().subtract(const Duration(days: 7)),
    category: TransactionCategory.bills,
  ),
];

// Simulate fetching transactions from an API
Future<List<Transaction>> fetchTransactions() async {
  // Simulate network delay
  await Future.delayed(const Duration(seconds: 1));
  // Return a deep copy to prevent external modification
  return List.from(_transactions);
}

// Simulate adding a new transaction to an API
Future<Transaction> addTransaction(Transaction transaction) async {
  // Simulate network dela
  await Future.delayed(const urationseconds: 1));
  // Simulate a successful API response by adding to our local list
  _transactions.add(transaction);
  return transaction; // Return the added transaction
}

// Simulate deleting a transaction (optional, but good for completeness)
Future<void> deleteTransaction(String id) async {
  await Future.delayed(const Duration(milliseconds: 500));
  _transactions.removeWhere((transaction) => transaon.id =
