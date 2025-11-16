import 'package:flutter/material.dart';
import 'package:kanhas/models/user_model.dart';
import 'package:kanhas/screens/login_page.dart';
import 'package:kanhas/screens/edit_profile_page.dart';
// --- TAMBAHKAN IMPOR INI ---
import 'package:kanhas/screens/order_history_page.dart';

class ProfilePage extends StatelessWidget {
  // ... (kode User tidak berubah) ...
  final User user;
  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // ... (kode build tidak berubah) ...
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

  // ... (kode _buildProfileHeader tidak berubah) ...
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
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.red[100],
            child: Icon(
              Icons.person,
              size: 60,
              color: Colors.red[700],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.username,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Role: ${user.role.name}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildProfileMenu(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
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
              // --- UBAH LOGIKA INI ---
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderHistoryPage(),
                ),
              );
              // -----------------------
            },
          ),
          _buildMenuTile(
            icon: Icons.settings_outlined,
            title: 'Pengaturan',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur belum tersedia')),
              );
            },
          ),
          _buildMenuTile(
            icon: Icons.info_outline,
            title: 'Tentang Aplikasi',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Aplikasi Kanhas v1.0.0')),
              );
            },
            hideDivider: true,
          ),
        ],
      ),
    );
  }

  // ... (kode _buildMenuTile tidak berubah) ...
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
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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

  // ... (kode _buildLogoutButton tidak berubah) ...
  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextButton.icon(
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text(
          'Logout',
          style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
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