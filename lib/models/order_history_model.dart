import 'package:flutter/material.dart';
import 'package:kanhas/models/cart_model.dart';
import 'package:kanhas/models/order_model.dart';

class OrderHistoryModel extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(List<CartItem> cartItems, double totalPrice) {
    final newOrder = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: List.from(cartItems),
      totalPrice: totalPrice,
      orderDate: DateTime.now(),
    );

    _orders.insert(0, newOrder);
    notifyListeners();
  }
}
