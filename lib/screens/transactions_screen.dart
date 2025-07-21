import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Removed unused import: import 'package:transactions_app/models/transaction.dart';
import 'package:transactions_app/providers/transaction_provider.dart';
import 'package:transactions_app/widgets/add_transaction_form.dart';
import 'package:transactions_app/widgets/filter_options.dart';
import 'package:transactions_app/widgets/transaction_list_item.dart';

class TransactionsScreen extends StatefulWidget {
const TransactionsScreen({super.key});

@override
State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
@override
void initState() {
  super.initState();
  // Fetch transactions when the screen initializes
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<TransactionProvider>(context, listen: false)
        .fetchTransactions();
  });
}

void _showAddTransactionModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allows the modal to take full height
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(ctx).viewInsets.bottom,
      ),
      child: const AddTransactionForm(),
    ),
  );
}

void _showFilterModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(ctx).viewInsets.bottom,
      ),
      child: const FilterOptions(),
    ),
  );
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Transactions'),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () => _showFilterModal(context),
          tooltip: 'Filter Transactions',
        ),
      ],
    ),
    body: Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        if (transactionProvider.isLoading &&
            transactionProvider.transactions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (transactionProvider.errorMessage != null) {
          return Center(
            child: Text(
              'Error: ${transactionProvider.errorMessage}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (transactionProvider.filteredTransactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info_outline, size: 60, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  transactionProvider.transactions.isEmpty
                      ? 'No transactions yet. Add one!'
                      : 'No transactions match your filters.',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                if (transactionProvider.transactions.isNotEmpty &&
                    (transactionProvider.filterType != null ||
                        transactionProvider.filterCategory != null ||
                        transactionProvider.filterStartDate != null ||
                        transactionProvider.filterEndDate != null))
                  TextButton(
                    onPressed: () => transactionProvider.clearFilters(),
                    child: const Text('Clear Filters'),
                  ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: transactionProvider.fetchTransactions,
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: transactionProvider.filteredTransactions.length,
            itemBuilder: (context, index) {
              final transaction =
                  transactionProvider.filteredTransactions[index];
              return TransactionListItem(transaction: transaction);
            },
          ),
        );
      },
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => _showAddTransactionModal(context),
      child: const Icon(Icons.add),
      tooltip: 'Add New Transaction',
    ),
  );
}
}
