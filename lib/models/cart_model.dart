import 'package:flutter/foundation.dart';
import 'package:kanhas/models/canteen_data.dart';

class CartItem {
  final Menu menu;
  int quantity;

  CartItem({required this.menu, this.quantity = 1});

  Map<String, dynamic> toMap() {
    return {
      // Kita asumsikan Menu sudah punya toMap dari langkah sebelumnya
      'menu': menu.toMap(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      menu: Menu.fromMap(map['menu']),
      quantity: map['quantity'],
    );
  }
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice {
    return _items.fold(
        0, (sum, item) => sum + (item.menu.price * item.quantity));
  }

  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  void add(CartItem item) {
    try {
      CartItem existingItem =
          _items.firstWhere((i) => i.menu.name == item.menu.name);
      existingItem.quantity += item.quantity;
    } catch (e) {
      _items.add(item);
    }
    notifyListeners();
  }

  void remove(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void increment(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decrement(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
