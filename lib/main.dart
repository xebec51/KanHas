import 'package:flutter/material.dart';
import 'package:kanhas/models/cart_model.dart'; // 1. Impor model keranjang
import 'package:kanhas/screens/login_page.dart';
import 'package:provider/provider.dart'; // 2. Impor package provider

void main() {
  // 3. "SUNTIKKAN" PROVIDER DI SINI
  runApp(
    ChangeNotifierProvider(
      // 'create' memberi tahu provider model apa yang harus dibuat
      create: (context) => CartModel(),
      // 'child'-nya adalah aplikasi kita
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