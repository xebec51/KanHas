// Ini adalah "cetakan" untuk satu item menu
class Menu {
  final String name;
  final int price;
  final String description;

  // Constructor
  Menu({
    required this.name,
    required this.price,
    required this.description,
  });
}

// Ini adalah "cetakan" untuk satu kantin
class Canteen {
  final String name;
  final String location;
  final List<Menu> menus; // Sebuah kantin punya DAFTAR menu

  // Constructor
  Canteen({
    required this.name,
    required this.location,
    required this.menus,
  });
}

// --- INI ADALAH DATABASE DUMMY KITA ---
// Kita membuat daftar semua kantin di sini,
// lengkap dengan semua menu di dalamnya.

final List<Canteen> canteenList = [
  // Kantin 1
  Canteen(
    name: 'Kantin Teknik',
    location: 'Gedung FT, Lantai 1',
    menus: [
      Menu(
        name: 'Nasi Goreng Gila',
        price: 15000,
        description: 'Nasi goreng spesial dengan sosis, bakso, dan telur orak-arik.',
      ),
      Menu(
        name: 'Ayam Geprek Sambal Bawang',
        price: 12000,
        description: 'Ayam krispi digeprek dengan sambal bawang khas.',
      ),
      Menu(
        name: 'Es Teh Manis',
        price: 3000,
        description: 'Minuman teh manis dingin menyegarkan.',
      ),
    ],
  ),
  
  // Kantin 2
  Canteen(
    name: 'Kantin Sastra',
    location: 'Area Fakultas FIB',
    menus: [
      Menu(
        name: 'Bubur Ayam Komplit',
        price: 10000,
        description: 'Bubur ayam hangat dengan suwiran ayam, cakwe, dan kerupuk.',
      ),
      Menu(
        name: 'Kopi Hitam',
        price: 5000,
        description: 'Kopi hitam robusta panas.',
      ),
    ],
  ),
  
  // Kantin 3
  Canteen(
    name: 'Kantin MIPA',
    location: 'Pelataran FMIPA',
    menus: [
      Menu(
        name: 'Batagor Spesial',
        price: 10000,
        description: 'Batagor ikan tenggiri dengan bumbu kacang dan perasan jeruk.',
      ),
      Menu(
        name: 'Siomay Bandung',
        price: 12000,
        description: 'Siomay ikan lengkap dengan kentang, kol, dan tahu.',
      ),
      Menu(
        name: 'Jus Alpukat',
        price: 8000,
        description: 'Jus alpukat segar dengan susu kental manis coklat.',
      ),
    ],
  ),
];