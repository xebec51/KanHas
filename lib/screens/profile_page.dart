import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kanhas/helpers/image_helper.dart';
import 'package:kanhas/models/user_model.dart';
import 'package:kanhas/providers/auth_provider.dart';
import 'package:kanhas/screens/edit_profile_page.dart';
import 'package:kanhas/screens/order_history_page.dart';
import 'package:kanhas/screens/settings_page.dart';
import 'package:kanhas/screens/edit_info_page.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Kita tidak perlu state 'currentUser' lokal lagi karena data diambil langsung dari Provider

  Future<void> _pickProfileImage(BuildContext context) async {
    final String? imagePath = await ImageHelper.pickAndSaveImage();
    if (imagePath == null) return;

    if (!context.mounted) return;

    final authProvider = context.read<AuthProvider>();
    // Pastikan currentUser tidak null sebelum diupdate
    if (authProvider.currentUser != null) {
      final updatedUser =
          authProvider.currentUser!.copyWith(profileImagePath: imagePath);

      await authProvider.updateUser(updatedUser);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Foto profil berhasil diperbarui!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Bungkus dengan Consumer agar UI update otomatis saat data berubah di halaman Edit
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        final currentUser = auth.currentUser!; // Ambil data terbaru dari provider

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profil Saya'),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.grey[50],
          ),
          backgroundColor: Colors.grey[50],
          body: ListView(
            children: [
              _buildProfileHeader(
                  context, currentUser), // Pass currentUser ke method
              const SizedBox(height: 20),
              _buildProfileMenu(context, currentUser),
              const SizedBox(height: 30),
              _buildLogoutButton(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatar(User user) {
    ImageProvider? backgroundImage;

    if (user.profileImagePath != null) {
      backgroundImage = FileImage(File(user.profileImagePath!));
    }

    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.red[100],
      backgroundImage: backgroundImage,
      child: backgroundImage == null
          ? Icon(
              Icons.person,
              size: 60,
              color: Colors.red[700],
            )
          : null,
    );
  }

  Widget _buildProfileHeader(BuildContext context, User user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              _buildAvatar(user),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.red,
                  child: IconButton(
                    icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                    onPressed: () => _pickProfileImage(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            user.fullName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Role: ${user.role.name}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenu(BuildContext context, User user) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildMenuTile(
            icon: Icons.edit_outlined,
            title: 'Edit Info Profil',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditInfoPage(user: user),
                ),
              );
            },
          ),
          _buildMenuTile(
            icon: Icons.lock_outline,
            title: 'Ubah Password',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(user: user),
                ),
              );
            },
          ),
          _buildMenuTile(
            icon: Icons.history,
            title: 'Riwayat Pesanan',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderHistoryPage(),
                ),
              );
            },
          ),
          _buildMenuTile(
            icon: Icons.settings_outlined,
            title: 'Pengaturan',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
            hideDivider: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool hideDivider = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  Icon(icon, color: Colors.grey[700], size: 24),
                  const SizedBox(width: 16),
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios,
                      color: Colors.grey[400], size: 16),
                ],
              ),
            ),
            if (!hideDivider)
              Divider(height: 1, indent: 40, color: Colors.grey[200]),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextButton.icon(
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text(
          'Logout',
          style: TextStyle(
              fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          backgroundColor: Colors.red[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          // Panggil logout dari provider
          context.read<AuthProvider>().logout();

          // Tidak perlu navigator push karena main.dart akan otomatis switch ke Login Page
        },
      ),
    );
  }
}