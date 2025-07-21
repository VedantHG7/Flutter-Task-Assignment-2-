import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transactions_app/models/transaction.dart';

class TransactionListItem extends StatelessWidget {
final Transaction transaction;

const TransactionListItem({super.key, required this.transaction});

@override
Widget build(BuildContext context) {
  final isCredit = transaction.type == TransactionType.credit;
  final amountColor = isCredit ? Colors.green[700] : Colors.red[700];
  final amountPrefix = isCredit ? '+' : '-';

  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Icon based on transaction type
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isCredit ? Colors.green[100] : Colors.red[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isCredit ? Icons.arrow_upward : Icons.arrow_downward,
              color: amountColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Category: ${transaction.category.toString().split('.').last.capitalize()}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM dd, yyyy - hh:mm a').format(transaction.date),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$amountPrefix${NumberFormat.currency(locale: 'en_US', symbol: '\$').format(transaction.amount)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: amountColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                transaction.type.toString().split('.').last.capitalize(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
}

// Extension to capitalize the first letter of a string
extension StringExtension on String {
String capitalize() {
  if (isEmpty) return this;
  return "${this[0].toUpperCase()}${substring(1)}";
}
}
