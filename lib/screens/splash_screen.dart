import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test_app_3/repository/firebase_api.dart';
import 'package:test_app_3/screens/home_screen.dart';
import 'sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseApi _firebaseApi = FirebaseApi();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      var result = await _firebaseApi.validateSession();
      if (result) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF5F0), Colors.white],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            // Logo Container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFFF27121), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_circle,
                size: 80,
                color: Color(0xFFF27121),
              ),
            ),
            const SizedBox(height: 40),
            // App Name
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1C29),
                ),
                children: [
                  TextSpan(text: 'Pack '),
                  TextSpan(
                    text: '&',
                    style: TextStyle(color: Color(0xFFF27121)),
                  ),
                  TextSpan(text: ' Go'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Tu equipaje bajo control',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blueGrey,
                letterSpacing: 0.5,
              ),
            ),
            const Spacer(flex: 2),
            // Loading Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Iniciando aventura...',
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                      Text(
                        '75%',
                        style: TextStyle(
                          color: Color(0xFFF27121),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const LinearProgressIndicator(
                      value: 0.75,
                      backgroundColor: Color(0xFFE0E0E0),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFF27121),
                      ),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.airplanemode_active,
                  size: 16,
                  color: Colors.blueGrey,
                ),
                SizedBox(width: 8),
                Text(
                  'SMART CHECKLIST V2.0',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
