import 'dart:convert';
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items.map((x) => x.toMap()).toList(),
      'totalPrice': totalPrice,
      'orderDate': orderDate.toIso8601String(), // Simpan tanggal sebagai String ISO
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      items: List<CartItem>.from(
        (map['items'] as List<dynamic>).map<CartItem>(
              (x) => CartItem.fromMap(x),
        ),
      ),
      totalPrice: map['totalPrice'].toDouble(), // Pastikan jadi double
      orderDate: DateTime.parse(map['orderDate']), // Ubah string kembali ke DateTime
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));
}
