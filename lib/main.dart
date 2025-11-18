// lib/main.dart

import 'package:flutter/material.dart';
import 'package:kanhas/models/cart_model.dart';
import 'package:kanhas/models/canteen_model.dart';
// --- TAMBAHKAN IMPOR INI ---
import 'package:kanhas/models/order_history_model.dart';
// -------------------------
import 'package:kanhas/screens/login_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Provider #1: Keranjang
        ChangeNotifierProvider(create: (context) => CartModel()),

        // Provider #2: Kantin
        ChangeNotifierProvider(create: (context) => CanteenModel()),

        // --- TAMBAHKAN PROVIDER #3 ---
        // Provider #3: Riwayat Pesanan (BARU)
        ChangeNotifierProvider(create: (context) => OrderHistoryModel()),
        // -----------------------------
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kanhas',
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}