// lib/models/user_model.dart

enum UserRole { mahasiswa, admin }

class User {
  final String username;
  final String password;
  final UserRole role;

  // --- TAMBAHKAN FIELD BARU ---
  final String fullName;
  final String email;
  final String? profileImagePath; // Bisa null (jika belum diatur)

  User({
    required this.username,
    required this.password,
    required this.role,
    // --- TAMBAHKAN DI KONSTRUKTOR ---
    required this.fullName,
    required this.email,
    this.profileImagePath, // Opsional
  });

  // --- TAMBAHKAN METHOD 'copyWith' ---
  // Ini adalah helper yang SANGAT berguna untuk
  // memperbarui data user tanpa mengubah objek aslinya
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
}

// Perbarui list user global
List<User> userList = [
  User(
    username: 'admin',
    password: 'admin123',
    role: UserRole.admin,
    fullName: 'Admin Kanhas', // Data default
    email: 'admin@kanhas.com', // Data default
  ),
  User(
    username: 'mahasiswa',
    password: 'siswa123',
    role: UserRole.mahasiswa,
    fullName: 'Mahasiswa Biasa', // Data default
    email: 'mahasiswa@kampus.com', // Data default
  ),
];