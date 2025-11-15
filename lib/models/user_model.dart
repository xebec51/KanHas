// 1. Definisikan Role
// Menggunakan 'enum' jauh lebih aman & bersih daripada string
enum UserRole { mahasiswa, admin }

// 2. Buat "Cetakan" User
class User {
  final String username;
  final String password;
  final UserRole role;

  User({required this.username, required this.password, required this.role});
}

// 3. BUAT DATABASE USER (Global List)
// Ini adalah "tabel" user kita.
// Kita akan tambahkan satu admin default
List<User> userList = [
  User(
    username: 'admin',
    password: '123',
    role: UserRole.admin,
  )
];