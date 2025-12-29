// lib/models/canteen_model.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:kanhas/models/canteen_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CanteenModel extends ChangeNotifier {
  List<Canteen> _canteens = [];
  bool _isLoaded = false;

  // Getter
  List<Canteen> get canteens => _canteens;
  bool get isLoaded => _isLoaded;

  // Key untuk SharedPreferences
  static const String _storageKey = 'canteens_data';

  CanteenModel() {
    _loadData();
  }

  // --- LOGIC PENYIMPANAN ---

  /// Memuat data dari SharedPrefs saat aplikasi mulai
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dataJson = prefs.getString(_storageKey);

    if (dataJson != null) {
      // Jika ada data tersimpan, pakai itu
      final List<dynamic> decodedList = json.decode(dataJson);
      _canteens = decodedList.map((item) => Canteen.fromMap(item)).toList();
    } else {
      // Jika kosong (pertama kali install), pakai data default
      _canteens = List.from(initialCanteens);
      _saveData(); // Simpan data default ini ke memori
    }

    _isLoaded = true;
    notifyListeners();
  }

  /// Menyimpan kondisi saat ini ke SharedPrefs
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      _canteens.map((c) => c.toMap()).toList(),
    );
    await prefs.setString(_storageKey, encodedData);
  }

  // --- LOGIC CRUD (Dimodifikasi dengan _saveData) ---

  void addCanteen(Canteen canteen) {
    _canteens.add(canteen);
    _saveData(); // <--- Simpan
    notifyListeners();
  }

  void addMenuToCanteen(Canteen canteen, Menu menu) {
    final canteenIndex = _canteens.indexWhere((c) => c.name == canteen.name);
    if (canteenIndex != -1) {
      _canteens[canteenIndex].menus.add(menu);
      _saveData(); // <--- Simpan
      notifyListeners();
    }
  }

  void deleteMenuFromCanteen(Canteen canteen, Menu menu) {
    final canteenIndex = _canteens.indexWhere((c) => c.name == canteen.name);
    if (canteenIndex != -1) {
      _canteens[canteenIndex].menus.removeWhere((m) => m.name == menu.name);
      _saveData(); // <--- Simpan
      notifyListeners();
    }
  }

  void updateMenuInCanteen(Canteen canteen, Menu oldMenu, Menu newMenu) {
    final canteenIndex = _canteens.indexWhere((c) => c.name == canteen.name);
    if (canteenIndex == -1) return;
    final menuIndex = _canteens[canteenIndex].menus.indexWhere(
          (m) => m.name == oldMenu.name && m.price == oldMenu.price,
    );
    if (menuIndex == -1) return;
    _canteens[canteenIndex].menus[menuIndex] = newMenu;
    _saveData(); // <--- Simpan
    notifyListeners();
  }

  void updateCanteen(Canteen oldCanteen, Canteen newCanteen) {
    final index = _canteens.indexWhere(
            (c) => c.name == oldCanteen.name && c.location == oldCanteen.location);
    if (index != -1) {
      _canteens[index] = newCanteen;
      _saveData(); // <--- Simpan
      notifyListeners();
    }
  }

  void deleteCanteen(Canteen canteen) {
    _canteens.removeWhere(
            (c) => c.name == canteen.name && c.location == canteen.location);
    _saveData(); // <--- Simpan
    notifyListeners();
  }
}