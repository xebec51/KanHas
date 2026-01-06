import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kanhas/models/user_model.dart';
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  List<User> _registeredUsers = [];

  User? get currentUser => _currentUser;
  List<User> get registeredUsers => _registeredUsers;

  static const String _userKey = 'user_session';
  static const String _userListKey = 'registered_users_list';

  AuthProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final String? usersJson = prefs.getString(_userListKey);
    if (usersJson != null) {
      final List<dynamic> decodedList = json.decode(usersJson);
      _registeredUsers = decodedList.map((item) => User.fromMap(item)).toList();
    } else {
      _registeredUsers = [
        User(
          username: 'admin',
          password: 'admin123',
          role: UserRole.admin,
          fullName: 'Admin Kanhas',
          email: 'admin@kanhas.com',
        ),
        User(
          username: 'mahasiswa',
          password: 'siswa123',
          role: UserRole.mahasiswa,
          fullName: 'Mahasiswa Biasa',
          email: 'mahasiswa@kampus.com',
        ),
      ];
      _saveUserList();
    }

    final String? userJson = prefs.getString(_userKey);
    if (userJson != null) {
      _currentUser = User.fromJson(userJson);
    }

    notifyListeners();
  }

  Future<void> _saveUserList() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      _registeredUsers.map((user) => user.toMap()).toList(),
    );
    await prefs.setString(_userListKey, encodedData);
  }

  Future<bool> login(String username, String password) async {
    try {
      final user = _registeredUsers.firstWhere(
            (u) => u.username == username && u.password == password,
      );
      _currentUser = user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, user.toJson());

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    notifyListeners();
  }

  Future<bool> register(User newUser) async {
    if (_registeredUsers.any((u) => u.username == newUser.username)) {
      return false; // Username sudah ada
    }
    _registeredUsers.add(newUser);
    await _saveUserList();
    notifyListeners();
    return true;
  }

  // --- TAMBAHAN: Update User ---
  Future<void> updateUser(User updatedUser) async {
    // 1. Update di dalam list besar
    final index = _registeredUsers.indexWhere((u) => u.username == updatedUser.username);
    if (index != -1) {
      _registeredUsers[index] = updatedUser;
      await _saveUserList();
    }

    // 2. Jika user yang diedit adalah user yang sedang login, update sesi juga
    if (_currentUser?.username == updatedUser.username) {
      _currentUser = updatedUser;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, updatedUser.toJson());
    }

    notifyListeners();
  }
}
