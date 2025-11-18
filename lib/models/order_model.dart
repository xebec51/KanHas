import 'package:kanhas/models/cart_model.dart'; // Kita perlu CartItem

// Model ini merepresentasikan satu kali transaksi/checkout
class Order {
  final String id;
  final List<CartItem> items; // Daftar item yang dibeli
  final double totalPrice;
  final DateTime orderDate;

  Order({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.orderDate,
  });
}