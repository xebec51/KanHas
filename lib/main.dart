import 'package:flutter/material.dart';
import 'package:kanhas/models/cart_model.dart';
// 1. Impor CanteenModel baru (yang akan kita buat)
import 'package:kanhas/models/canteen_model.dart';
import 'package:kanhas/screens/login_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    // 2. GANTI ChangeNotifierProvider MENJADI MultiProvider
    MultiProvider(
      providers: [
        // Provider #1: Keranjang (yang sudah ada)
        ChangeNotifierProvider(create: (context) => CartModel()),

        // Provider #2: Kantin (yang baru)
        ChangeNotifierProvider(create: (context) => CanteenModel()),
      ],
      // 'child'-nya tetap MyApp
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