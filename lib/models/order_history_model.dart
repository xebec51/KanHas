// lib/models/order_history_model.dart

import 'package:flutter/material.dart';
import 'package:kanhas/models/cart_model.dart';
import 'package:kanhas/models/order_model.dart';

class OrderHistoryModel extends ChangeNotifier {
  // Daftar privat untuk menyimpan semua pesanan
  final List<Order> _orders = [];

  // Getter publik agar UI bisa membaca daftar pesanan
  List<Order> get orders => _orders;

  // Fungsi untuk menambah pesanan baru (dipanggil saat checkout)
  void addOrder(List<CartItem> cartItems, double totalPrice) {
    // Buat objek Order baru
    final newOrder = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // ID unik sederhana
      items: List.from(cartItems), // Salin list item
      totalPrice: totalPrice,
      orderDate: DateTime.now(),
    );

    // Masukkan di awal list (agar pesanan terbaru selalu di atas)
    _orders.insert(0, newOrder);

    // Beri tahu semua widget yang mendengarkan bahwa ada data baru
    notifyListeners();
  }
}