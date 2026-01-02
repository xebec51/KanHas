import 'dart:convert';

enum UserRole { mahasiswa, admin }

class User {
  final String username;
  final String password;
  final UserRole role;
  final String fullName;
  final String email;
  final String? profileImagePath;

  User({
    required this.username,
    required this.password,
    required this.role,
    required this.fullName,
    required this.email,
    this.profileImagePath,
  });

  User copyWith({
    String? username,
    String? password,
    UserRole? role,
    String? fullName,
    String? email,
    String? profileImagePath,
  }) {
    return User(
      username: username ?? this.username,
      password: password ?? this.password,
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }

  // Mengubah JSON (Map) menjadi Object User
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'],
      password: map['password'],
      role: UserRole.values.firstWhere(
            (e) => e.toString() == map['role'],
        orElse: () => UserRole.mahasiswa,
      ),
      fullName: map['fullName'],
      email: map['email'],
      profileImagePath: map['profileImagePath'],
    );
  }

  // Mengubah Object User menjadi JSON (Map) untuk disimpan
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'role': role.toString(), // Simpan enum sebagai string
      'fullName': fullName,
      'email': email,
      'profileImagePath': profileImagePath,
    };
  }

  // Method untuk mengubah ke String JSON
  String toJson() => json.encode(toMap());

  // Method untuk mengubah dari String JSON
  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
