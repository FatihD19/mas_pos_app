import 'package:flutter/material.dart';
import 'package:mas_pos_app/feature/product/presentation/widgets/header_app_bar.dart';
import 'package:mas_pos_app/feature/product/presentation/widgets/add_product_helper.dart';
import 'home_page.dart'; // Tambahkan import ini

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    // Index 1 tidak digunakan karena akan menampilkan modal
    Center(child: Text('Profile')), // Index 2 untuk Profile
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
      // Jika tombol Add (index 1) diklik, tampilkan modal
      showAddProductSheet(context);
    } else {
      // Untuk home (0) dan profile (2), update selected index
      // Profile menggunakan index 2 di pages tapi index 1 di navigation
      int pageIndex = index > 1 ? index - 1 : index;
      setState(() {
        _selectedIndex = pageIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderAppBar(),
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex > 0 ? _selectedIndex + 1 : _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.add, color: Colors.white),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}
