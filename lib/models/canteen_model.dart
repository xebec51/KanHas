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

  // U: Update Canteen (TAMBAHKAN FUNGSI INI)
  void updateCanteen(Canteen oldCanteen, Canteen newCanteen) {
    // 1. Cari index kantin yang lama
    final index = _canteens.indexWhere(
            (c) => c.name == oldCanteen.name && c.location == oldCanteen.location);

    // 2. Jika ketemu, ganti dengan yang baru
    if (index != -1) {
      _canteens[index] = newCanteen;
      notifyListeners(); // Beri tahu UI (HomePage)
    }
  }

  // U: Update Menu (TAMBAHKAN FUNGSI INI)
  void updateMenuInCanteen(Canteen canteen, Menu oldMenu, Menu newMenu) {
    // 1. Cari kantin
    final canteenIndex = _canteens.indexWhere((c) => c.name == canteen.name);
    if (canteenIndex == -1) return; // Kantin tidak ketemu

    // 2. Cari menu yang lama di dalam kantin itu
    final menuIndex = _canteens[canteenIndex].menus.indexWhere(
            (m) => m.name == oldMenu.name && m.price == oldMenu.price
    );
    if (menuIndex == -1) return; // Menu lama tidak ketemu

    // 3. Ganti menu lama dengan menu baru di index tersebut
    _canteens[canteenIndex].menus[menuIndex] = newMenu;
    notifyListeners(); // Beri tahu UI bahwa data telah berubah!
  }
}