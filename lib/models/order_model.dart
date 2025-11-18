import 'package:kanhas/models/cart_model.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double totalPrice;
  final DateTime orderDate;

  Order({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.orderDate,
  });
}