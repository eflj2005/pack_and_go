import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_app_3/firebase_options.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const PackAndGoApp());
}

class PackAndGoApp extends StatelessWidget {
  const PackAndGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pack & Go',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF27121),
          primary: const Color(0xFFF27121),
        ),
        fontFamily: 'Roboto', // O la fuente que prefieras
      ),
      home: const SplashScreen(),
    );
  }
}
