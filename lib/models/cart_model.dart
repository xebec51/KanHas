import 'package:flutter/foundation.dart';
import 'package:kanhas/models/canteen_data.dart';

class CartItem {
  final Menu menu;
  int quantity;

  CartItem({required this.menu, this.quantity = 1});
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice {
    return _items.fold(
        0, (sum, item) => sum + (item.menu.price * item.quantity));
  }

  int get itemCount {
    // 'itemCount' adalah total item, bukan jumlah jenis item.
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