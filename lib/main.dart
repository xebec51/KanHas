import 'package:flutter/material.dart';
import 'package:kanhas/screens/login_page.dart'; // Import halaman login kita

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kanhas',
      theme: ThemeData(
        // Kita gunakan tema warna merah agar sesuai dengan
        // julukan "Kampus Merah" Unhas. Ini detail yang bagus.
        primarySwatch: Colors.red,
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      
      // Ini adalah bagian terpenting:
      // Mengatur LoginPage sebagai halaman pertama yang dibuka.
      home: const LoginPage(),

      // Menghilangkan banner "DEBUG" di pojok kanan atas
      debugShowCheckedModeBanner: false,
    );
  }
}