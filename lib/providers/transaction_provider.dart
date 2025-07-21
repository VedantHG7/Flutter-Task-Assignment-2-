import 'package:flutter/material.dart';
import 'package:transactions_app/models/transaction.dart';
import 'package:transactions_app/services/transaction_service.dart';

class TransactionProvider with ChangeNotifier {
final TransactionService _transactionService = TransactionService();
List<Transaction> _transactions = [];
bool _isLoading = false;
String? _errorMessage;

TransactionType? _filterType;
TransactionCategory? _filterCategory;
DateTime? _filterStartDate;
DateTime? _filterEndDate;

List<Transaction> get transactions => _transactions;
bool get isLoading => _isLoading;
String? get errorMessage => _errorMessage;

TransactionType? get filterType => _filterType;
TransactionCategory? get filterCategory => _filterCategory;
DateTime? get filterStartDate => _filterStartDate;
DateTime? get filterEndDate => _filterEndDate;

List<Transaction> get filteredTransactions {
  List<Transaction> filteredList = List.from(_transactions);

  if (_filterType != null) {
    filteredList =
        filteredList.where((t) => t.type == _filterType).toList();
  }
  if (_filterCategory != null) {
    filteredList =
        filteredList.where((t) => t.category == _filterCategory).toList();
  }
  if (_filterStartDate != null) {
    filteredList = filteredList
        .where((t) => t.date.isAfter(_filterStartDate!
            .subtract(const Duration(days: 1)))) // Include start date
        .toList();
  }
  if (_filterEndDate != null) {
    filteredList = filteredList
        .where((t) => t.date.isBefore(_filterEndDate!
            .add(const Duration(days: 1)))) // Include end date
        .toList();
  }

  // Sort by date, newest first
  filteredList.sort((a, b) => b.date.compareTo(a.date));

  return filteredList;
}

TransactionProvider() {
  fetchTransactions();
}

Future<void> fetchTransactions() async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    _transactions = await _transactionService.fetchTransactions();
  } catch (e) {
    _errorMessage = 'Failed to load transactions: $e';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

Future<void> addTransaction(Transaction transaction) async {
  _isLoading = true; // Indicate loading for the add operation
  _errorMessage = null;
  notifyListeners();

  try {
    final newTransaction =
        await _transactionService.addTransaction(transaction);
    _transactions.add(newTransaction); // Add to local list
  } catch (e) {
    _errorMessage = 'Failed to add transaction: $e';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

void setFilterType(TransactionType? type) {
  _filterType = type;
  notifyListeners();
}

void setFilterCategory(TransactionCategory? category) {
  _filterCategory = category;
  notifyListeners();
}

void setFilterDateRange(DateTime? startDate, DateTime? endDate) {
  _filterStartDate = startDate;
  _filterEndDate = endDate;
  notifyListeners();
}

void clearFilters() {
  _filterType = null;
  _filterCategory = null;
  _filterStartDate = null;
  _filterEndDate = null;
  notifyListeners();
}
}
