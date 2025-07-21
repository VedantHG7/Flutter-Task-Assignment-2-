import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:transactions_app/models/transaction.dart';
import 'package:transactions_app/providers/transaction_provider.dart';
import 'package:transactions_app/widgets/transaction_list_item.dart'; // For capitalize extension

class FilterOptions extends StatefulWidget {
const FilterOptions({super.key});

@override
State<FilterOptions> createState() => _FilterOptionsState();
}

class _FilterOptionsState extends State<FilterOptions> {
TransactionType? _selectedTypeFilter;
TransactionCategory? _selectedCategoryFilter;
DateTime? _selectedStartDate;
DateTime? _selectedEndDate;

@override
void initState() {
  super.initState();
  final provider = Provider.of<TransactionProvider>(context, listen: false);
  _selectedTypeFilter = provider.filterType;
  _selectedCategoryFilter = provider.filterCategory;
  _selectedStartDate = provider.filterStartDate;
  _selectedEndDate = provider.filterEndDate;
}

Future<void> _selectDateRange(BuildContext context) async {
  final DateTimeRange? picked = await showDateRangePicker(
    context: context,
    firstDate: DateTime(2000),
    lastDate: DateTime.now().add(const Duration(days: 365)),
    initialDateRange: _selectedStartDate != null && _selectedEndDate != null
        ? DateTimeRange(start: _selectedStartDate!, end: _selectedEndDate!)
        : null,
  );
  if (picked != null) {
    setState(() {
      _selectedStartDate = picked.start;
      _selectedEndDate = picked.end;
    });
  }
}

void _applyFilters() {
  Provider.of<TransactionProvider>(context, listen: false).setFilterType(
    _selectedTypeFilter,
  );
  Provider.of<TransactionProvider>(context, listen: false).setFilterCategory(
    _selectedCategoryFilter,
  );
  Provider.of<TransactionProvider>(context, listen: false).setFilterDateRange(
    _selectedStartDate,
    _selectedEndDate,
  );
  // Guard against using BuildContext after an async gap
  if (!mounted) return;
  Navigator.of(context).pop(); // Close the modal
}

void _clearAllFilters() {
  setState(() {
    _selectedTypeFilter = null;
    _selectedCategoryFilter = null;
    _selectedStartDate = null;
    _selectedEndDate = null;
  });
  Provider.of<TransactionProvider>(context, listen: false).clearFilters();
  // Guard against using BuildContext after an async gap
  if (!mounted) return;
  Navigator.of(context).pop(); // Close the modal
}

@override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Filter Transactions',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField<TransactionType>(
          value: _selectedTypeFilter,
          decoration: const InputDecoration(
            labelText: 'Filter by Type',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.swap_horiz),
          ),
          items: [
            const DropdownMenuItem(value: null, child: Text('All Types')),
            ...TransactionType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.toString().split('.').last.capitalize()),
              );
            }).toList(),
          ],
          onChanged: (value) {
            setState(() {
              _selectedTypeFilter = value;
            });
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<TransactionCategory>(
          value: _selectedCategoryFilter,
          decoration: const InputDecoration(
            labelText: 'Filter by Category',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.category),
          ),
          items: [
            const DropdownMenuItem(value: null, child: Text('All Categories')),
            ...TransactionCategory.values.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category.toString().split('.').last.capitalize()),
              );
            }).toList(),
          ],
          onChanged: (value) {
            setState(() {
              _selectedCategoryFilter = value;
            });
          },
        ),
        const SizedBox(height: 16),
        ListTile(
          title: Text(
            _selectedStartDate == null && _selectedEndDate == null
                ? 'Select Date Range'
                : 'Dates: ${DateFormat('MMM dd, yyyy').format(_selectedStartDate!)} - ${DateFormat('MMM dd, yyyy').format(_selectedEndDate!)}',
          ),
          trailing: const Icon(Icons.calendar_today),
          onTap: () => _selectDateRange(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey[400]!),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: _applyFilters,
          icon: const Icon(Icons.check),
          label: const Text('Apply Filters'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: _clearAllFilters,
          child: const Text('Clear All Filters'),
        ),
      ],
    ),
  );
}
}
