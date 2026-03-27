import 'package:flutter/material.dart';
import 'package:test_app_3/repository/firebase_api.dart';
import 'package:test_app_3/screens/sign_in_screen.dart';
import 'package:test_app_3/screens/checklist_screen.dart';
import 'package:test_app_3/screens/colaborate_screen.dart';
import 'package:test_app_3/screens/profile_screen.dart';
import 'package:test_app_3/screens/new_item_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseApi _firebaseApi = FirebaseApi();
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ChecklistScreen(),
    const ColaborateScreen(),
    const ProfileScreen(),
  ];

  final List<String> _titles = [
    'Mi Equipaje',
    'Colaboradores',
    'Mi Perfil',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        centerTitle: false,
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(
            color: Color(0xFF1A1C29),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFFF27121)),
            onPressed: () {
              _firebaseApi.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignInScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _screens[_selectedIndex],
      floatingActionButton: _selectedIndex == 0 
        ? FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewItemScreen()),
              );
            },
            backgroundColor: const Color(0xFFF27121),
            child: const Icon(Icons.add, color: Colors.white, size: 30),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          )
        : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFFF27121),
          unselectedItemColor: Colors.blueGrey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.checklist_rtl_rounded),
              label: 'CHECKLIST',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_rounded),
              label: 'COLABORAR',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'MI PERFIL',
            ),
          ],
        ),
      ),
    );
  }
}
