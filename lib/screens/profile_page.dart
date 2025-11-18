// lib/screens/profile_page.dart

import 'dart:io'; // <-- Impor untuk File
import 'package:flutter/material.dart';
import 'package:kanhas/helpers/image_helper.dart'; // <-- Impor Image Helper
import 'package:kanhas/models/user_model.dart';
import 'package:kanhas/screens/login_page.dart';
import 'package:kanhas/screens/edit_profile_page.dart';
import 'package:kanhas/screens/order_history_page.dart';
import 'package:kanhas/screens/settings_page.dart';

// --- UBAH MENJADI STATEFULWIDGET ---
class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // --- BUAT STATE UNTUK MENYIMPAN USER SAAT INI ---
  late User currentUser;

  @override
  void initState() {
    super.initState();
    // Salin data user dari widget ke state saat halaman dibuka
    currentUser = widget.user;
  }
  // ---------------------------------------------

  // --- FUNGSI UNTUK MEMILIH GAMBAR PROFIL ---
  Future<void> _pickProfileImage() async {
    final String? imagePath = await ImageHelper.pickAndSaveImage();
    if (imagePath == null) return; // Pengguna membatalkan

    // 1. Buat objek user baru dengan path gambar yang diperbarui
    final updatedUser = currentUser.copyWith(profileImagePath: imagePath);

    // 2. Perbarui 'database' global (userList)
    int userIndex =
    userList.indexWhere((u) => u.username == currentUser.username);
    if (userIndex != -1) {
      userList[userIndex] = updatedUser;
    }

    // 3. Perbarui state lokal agar UI langsung berubah
    setState(() {
      currentUser = updatedUser;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Foto profil berhasil diperbarui!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
  // ------------------------------------------

  @override
  Widget build(BuildContext context) {
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
          _buildProfileHeader(context),
          const SizedBox(height: 20),
          _buildProfileMenu(context),
          const SizedBox(height: 30),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  // --- WIDGET HELPER UNTUK AVATAR (BARU) ---
  Widget _buildAvatar() {
    ImageProvider? backgroundImage;

    // Gunakan 'currentUser' dari state, bukan 'widget.user'
    if (currentUser.profileImagePath != null) {
      // Jika ada path, gunakan FileImage
      backgroundImage = FileImage(File(currentUser.profileImagePath!));
    }

    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.red[100],
      // Tampilkan gambar jika ada
      backgroundImage: backgroundImage,
      // Tampilkan ikon jika tidak ada gambar
      child: backgroundImage == null
          ? Icon(
        Icons.person,
        size: 60,
        color: Colors.red[700],
      )
          : null,
    );
  }
  // ----------------------------------------

  // --- WIDGET HELPER UNTUK HEADER (DIPERBARUI) ---
  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        children: [
          // --- STACK UNTUK AVATAR & TOMBOL EDIT FOTO ---
          Stack(
            children: [
              _buildAvatar(), // Panggil helper avatar
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.red,
                  child: IconButton(
                    icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                    onPressed: _pickProfileImage, // Panggil fungsi ganti foto
                  ),
                ),
              ),
            ],
          ),
          // ------------------------------------------
          const SizedBox(height: 16),
          Text(
            currentUser.fullName, // <-- Ganti ke fullName
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            currentUser.email, // <-- Ganti ke email
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Role: ${currentUser.role.name}', // <-- Gunakan currentUser
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
  // -----------------------------------------------

  Widget _buildProfileMenu(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildMenuTile(
            icon: Icons.edit_outlined, // <-- GANTI IKON
            title: 'Edit Info Profil', // <-- GANTI JUDUL
            onTap: () {
              // TODO: Arahkan ke halaman Edit Info (Batch 3)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Fitur Edit Info belum tersedia')),
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
                  // Kirim 'currentUser' dari state
                  builder: (context) => EditProfilePage(user: currentUser),
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
    // ... (Tidak ada perubahan di sini) ...
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
                  Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
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
    // ... (Tidak ada perubahan di sini) ...
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
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
          );
        },
      ),
    );
  }
}