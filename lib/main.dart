import  'package:flutter/material.dart';
import 'cashier_page.dart';

void main (){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cashier App',
      home: const CashierPage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}