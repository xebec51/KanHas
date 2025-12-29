// lib/models/order_history_model.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kanhas/models/cart_model.dart';
import 'package:kanhas/models/order_model.dart';

class OrderHistoryModel extends ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoaded = false;

  List<Order> get orders => _orders;

  // Key untuk penyimpanan
  static const String _storageKey = 'order_history_data';

  OrderHistoryModel() {
    _loadData();
  }

  // --- LOGIC LOAD DATA ---
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dataJson = prefs.getString(_storageKey);

    if (dataJson != null) {
      final List<dynamic> decodedList = json.decode(dataJson);
      _orders = decodedList.map((item) => Order.fromMap(item)).toList();
    }

    _isLoaded = true;
    notifyListeners();
  }

  // --- LOGIC SAVE DATA ---
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      _orders.map((o) => o.toMap()).toList(),
    );
    await prefs.setString(_storageKey, encodedData);
  }

  void addOrder(List<CartItem> cartItems, double totalPrice) {
    final newOrder = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: List.from(cartItems), // Copy list agar tidak terikat referensi Cart lama
      totalPrice: totalPrice,
      orderDate: DateTime.now(),
    );

    // Masukkan ke paling atas (terbaru)
    _orders.insert(0, newOrder);

    // Simpan permanen
    _saveData();

    notifyListeners();
  }

  // Opsional: Fitur hapus riwayat
  void clearHistory() async {
    _orders.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    notifyListeners();
  }
}