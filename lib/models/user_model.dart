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
}

List<User> userList = [
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