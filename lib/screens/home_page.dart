import 'package:flutter/material.dart';

// Ini adalah StatelessWidget. Halaman ini tidak perlu
// mengubah state-nya sendiri, dia hanya menerima data (role)
// dan menampilkannya.
class HomePage extends StatelessWidget {
  
  // 1. DEKLARASIKAN VARIABEL UNTUK MENANGKAP DATA ROLE
  // 'final' berarti data ini tidak akan berubah setelah
  // halaman ini dibuat.
  final String role;

  // 2. BUAT CONSTRUCTOR UNTUK MENERIMA DATA ROLE
  // 'required this.role' mewajibkan siapa pun yang memanggil
  // HomePage untuk mengirimkan data 'role'.
  // Inilah yang kita panggil dari LoginPage: HomePage(role: 'Admin')
  const HomePage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // 3. TAMPILKAN ROLE DI APPBAR
      // Ini membuktikan bahwa data 'role' berhasil diterima.
      appBar: AppBar(
        title: Text('Kanhas - ($role)'), // Contoh: "Kanhas - (Admin)"
        centerTitle: true,
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // 4. UCAPAN SELAMAT DATANG SPESIFIK
            Text(
              'Selamat datang, $role!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              'Silakan pilih kantin:',
              style: TextStyle(fontSize: 18),
            ),
            
            const SizedBox(height: 10),

            // 5. AREA UNTUK DAFTAR KANTIN
            // Kita akan gunakan 'Expanded' agar ListView mengambil
            // sisa ruang yang tersedia di layar.
            Expanded(
              child: ListView(
                // Ini adalah daftar placeholder.
                // Nanti kita akan ganti dengan data kantin asli.
                children: [
                  
                  // Ini adalah placeholder untuk 1 kantin
                  ListTile(
                    leading: const Icon(Icons.store), // Ikon kantin
                    title: const Text('Kantin Teknik'),
                    subtitle: const Text('Gedung FT, Lantai 1'),
                    trailing: const Icon(Icons.chevron_right), // Panah ke kanan
                    onTap: () {
                      // Aksi navigasi ke MenuPage akan ditambahkan di sini
                      print('Kantin Teknik di-klik');
                    },
                  ),
                  
                  ListTile(
                    leading: const Icon(Icons.store),
                    title: const Text('Kantin Sastra'),
                    subtitle: const Text('Area FIB'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      print('Kantin Sastra di-klik');
                    },
                  ),
                  
                  ListTile(
                    leading: const Icon(Icons.store),
                    title: const Text('Kantin MIPA'),
                    subtitle: const Text('Pelataran FMIPA'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      print('Kantin MIPA di-klik');
                    },
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}