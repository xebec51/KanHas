// --- MODEL MENU ---
class Menu {
  final String name;
  final int price;
  final String description;
  final String imageUrl; // <-- TAMBAHKAN INI

  Menu({
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl, // <-- TAMBAHKAN INI
  });
}

// --- MODEL KANTIN ---
class Canteen {
  final String name;
  final String location;
  final String imageUrl; // <-- TAMBAHKAN INI
  final List<Menu> menus;

  Canteen({
    required this.name,
    required this.location,
    required this.imageUrl, // <-- TAMBAHKAN INI
    required this.menus,
  });
}

// --- DATABASE DUMMY (DENGAN URL GAMBAR) ---
final List<Canteen> canteenList = [
  // Kantin 1
  Canteen(
    name: 'Kantin Teknik',
    location: 'Gedung FT, Lantai 1',
    imageUrl: 'https://images.unsplash.com/photo-1519996529601-b2a951cde72b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwyNjA3fDB8MXxzZWFyY2h8N3x8Y2FudGVlbnx8MHx8fHwxNjU4MzM1Nzg4&ixlib=rb-1.2.1&q=80&w=400',
    menus: [
      Menu(
        name: 'Nasi Goreng Gila',
        price: 15000,
        description: 'Nasi goreng spesial dengan sosis, bakso, dan telur orak-arik.',
        imageUrl: 'https://images.unsplash.com/photo-1512058564366-1851090c3ac0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwyNjA3fDB8MXxzZWFyY2h8MXx8bmFzaSUyMGdvcmVuZ3x8MHx8fHwxNjU4MzM1ODYw&ixlib=rb-1.2.1&q=80&w=400',
      ),
      Menu(
        name: 'Ayam Geprek',
        price: 12000,
        description: 'Ayam krispi digeprek dengan sambal bawang khas.',
        imageUrl: 'https://images.unsplash.com/photo-1603510345058-c26b0d359f5b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwyNjA3fDB8MXxzZWFyY2h8MXx8YXlhbSUyMGdlcHJla3x8MHx8fHwxNjU4MzM2MTQx&ixlib=rb-1.2.1&q=80&w=400',
      ),
      Menu(
        name: 'Es Teh Manis',
        price: 3000,
        description: 'Minuman teh manis dingin menyegarkan.',
        imageUrl: 'https://images.unsplash.com/photo-1597488341639-382a1b9f7112?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwyNjA3fDB8MXxzZWFyY2h8Mnx8aWNlJTIwdGVhfGVufDB8fHx8MTY1ODMzNTkyNQ&ixlib=rb-1.2.1&q=80&w=400',
      ),
    ],
  ),

  // Kantin 2
  Canteen(
    name: 'Kantin Sastra',
    location: 'Area Fakultas FIB',
    imageUrl: 'https://images.unsplash.com/photo-1555992336-fb0d29498b13?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwyNjA3fDB8MXxzZWFyY2h8MTJ8fGNhZmV0ZXJpYXxlbnwwfHx8fDE2NTgzMzYwMDI&ixlib=rb-1.2.1&q=80&w=400',
    menus: [
      Menu(
        name: 'Bubur Ayam Komplit',
        price: 10000,
        description: 'Bubur ayam hangat dengan suwiran ayam, cakwe, dan kerupuk.',
        imageUrl: 'https://images.unsplash.com/photo-1587714828113-a4e10740b15b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwyNjA3fDB8MXxzZWFyY2h8MXx8YnVidXIlMjBheWFtfGVufDB8fHx8MTY1ODMzNjE4Mw&ixlib=rb-1.2.1&q=80&w=400',
      ),
      Menu(
        name: 'Kopi Hitam',
        price: 5000,
        description: 'Kopi hitam robusta panas.',
        imageUrl: 'https://images.unsplash.com/photo-1511920184454-UART061d1e43?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwyNjA3fDB8MXxzZWFyY2h8Nnx8YmxhY2slMjBjb2ZmZWV8ZW58MHx8fHwxNjU4MzM2MjE1&ixlib=rb-1.2.1&q=80&w=400',
      ),
    ],
  ),
];