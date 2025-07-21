import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transactions_app/models/transaction.dart';
import 'package:transactions_app/providers/transaction_provider.dart';
import 'package:intl/intl.dart';
import 'package:transactions_app/widgets/transaction_list_item.dart'; // Import for capitalize extension

class AddTransactionForm extends StatefulWidget {
const AddTransactionForm({super.key});

@override
State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
final _formKey = GlobalKey<FormState>();
final TextEditingController _titleController = TextEditingController();
final TextEditingController _amountController = TextEditingController();
TransactionType _selectedType = TransactionType.debit;
TransactionCategory _selectedCategory = TransactionCategory.other;
DateTime _selectedDate = DateTime.now();

@override
void dispose() {
  _titleController.dispose();
  _amountController.dispose();
  super.dispose();
}

Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: _selectedDate,
    firstDate: DateTime(2000),
    lastDate: DateTime.now(),
  );
  if (picked != null && picked != _selectedDate) {
    setState(() {
      _selectedDate = picked;
    });
  }
}

void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    final newTransaction = Transaction(
      title: _titleController.text,
      amount: double.parse(_amountController.text),
      type: _selectedType,
      category: _selectedCategory,
      date: _selectedDate,
    );

    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);

    await transactionProvider.addTransaction(newTransaction);

    // Guard against using BuildContext after an async gap
    if (!mounted) return;

    if (transactionProvider.errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction added successfully!')),
      );
      // Guard against using BuildContext after an async gap
      if (!mounted) return;
      Navigator.of(context).pop(); // Close the modal
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error: ${transactionProvider.errorMessage!}')),
      );
    }
  }
}

@override
Widget build(BuildContext context) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(20.0),
    child: Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add New Transaction',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _amountController,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount.';
              }
              if (double.tryParse(value) == null ||
                  double.parse(value) <= 0) {
                return 'Please enter a valid positive number.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<TransactionType>(
            value: _selectedType,
            decoration: const InputDecoration(
              labelText: 'Type',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.swap_horiz),
            ),
            items: TransactionType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.toString().split('.').last.capitalize()),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedType = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<TransactionCategory>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.category),
            ),
            items: TransactionCategory.values.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category.toString().split('.').last.capitalize()),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            title: Text(
              'Date: ${DateFormat('MMM dd, yyyy').format(_selectedDate)}',
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () => _selectDate(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey[400]!),
            ),
          ),
          const SizedBox(height: 24),
          Consumer<TransactionProvider>(
            builder: (context, transactionProvider, child) {
              return ElevatedButton.icon(
                onPressed: transactionProvider.isLoading ? null : _submitForm,
                icon: transactionProvider.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.add),
                label: Text(transactionProvider.isLoading
                    ? 'Adding...'
                    : 'Add Transaction'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    ),
  );
}
}
