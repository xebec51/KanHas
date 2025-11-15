import 'package:flutter/foundation.dart';
import 'package:kanhas/models/canteen_data.dart';

class CanteenModel extends ChangeNotifier {
  final List<Canteen> _canteens = List.from(canteenList);

  List<Canteen> get canteens => _canteens;

  // --- FUNGSI CRUD UNTUK ADMIN ---

  // C: Create Canteen (HANYA ADA SATU)
  void addCanteen(Canteen canteen) {
    _canteens.add(canteen);
    notifyListeners();
  }

  // C: Create Menu
  void addMenuToCanteen(Canteen canteen, Menu menu) {
    final canteenIndex = _canteens.indexWhere((c) => c.name == canteen.name);

    if (canteenIndex != -1) {
      _canteens[canteenIndex].menus.add(menu);
      notifyListeners();
    }
  }

  // D: Delete Menu (TAMBAHKAN FUNGSI INI)
  void deleteMenuFromCanteen(Canteen canteen, Menu menu) {
    // 1. Cari kantin yang benar
    final canteenIndex = _canteens.indexWhere((c) => c.name == canteen.name);

    // 2. Jika kantin ketemu, hapus menu dari daftar menu-nya
    if (canteenIndex != -1) {
      _canteens[canteenIndex].menus.removeWhere((m) => m.name == menu.name);
      notifyListeners(); // Beri tahu UI bahwa menu telah dihapus!
    }
  }
}