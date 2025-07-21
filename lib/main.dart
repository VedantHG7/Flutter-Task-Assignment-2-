import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transactions_app/providers/transaction_provider.dart';
import 'package:transactions_app/screens/transactions_screen.dart';

void main() {
runApp(const MyApp());
}

class MyApp extends StatelessWidget {
const MyApp({super.key});

@override
Widget build(BuildContext context) {
  return ChangeNotifierProvider(
    create: (context) => TransactionProvider(),
    child: MaterialApp(
      title: 'Transactions App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
      home: const TransactionsScreen(),
    ),
  );
}
}
