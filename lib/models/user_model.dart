// lib/models/user_model.dart

enum UserRole { admin, mahasiswa }

class User {
  final String username;
  final String password;
  final UserRole role;
  // TODO: Tambahkan field lain seperti nama lengkap, email, dll jika perlu
  // final String fullName;
  // final String email;

  User({
    required this.username,
    required this.password,
    required this.role,
  });
}

// Data dummy pengguna
// Global agar bisa diakses oleh EditProfilePage
List<User> userList = [
  User(username: 'admin', password: 'admin123', role: UserRole.admin), // Password diubah
  User(username: 'mahasiswa', password: 'siswa123', role: UserRole.mahasiswa), // Password diubah
];