enum UserRole { admin, mahasiswa }

class User {
  final String username;
  final String password;
  final UserRole role;

  User({
    required this.username,
    required this.password,
    required this.role,
  });
}

// Global agar bisa diakses oleh EditProfilePage.
List<User> userList = [
  User(username: 'admin', password: 'admin123', role: UserRole.admin),
  User(username: 'mahasiswa', password: 'siswa123', role: UserRole.mahasiswa),
];
