import 'package:flutter/material.dart';
import 'package:test_app_3/repository/firebase_api.dart';
import 'package:test_app_3/utils/firebase_errors.dart';
import 'package:test_app_3/utils/messenger_utils.dart';

class RecoveryPasswordScreen extends StatefulWidget {
  const RecoveryPasswordScreen({super.key});

  @override
  State<RecoveryPasswordScreen> createState() => _RecoveryPasswordScreenState();
}

class _RecoveryPasswordScreenState extends State<RecoveryPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _firebaseApi = FirebaseApi();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 60),
              // App Logo & Text
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF27121),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFF27121,
                            ).withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.apps,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Pack & Go',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1C29),
                      ),
                    ),
                    const Text(
                      'Tu equipaje, nuestra prioridad.',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Main Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.arrow_back,
                              color: Color(0xFFF27121),
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Volver al inicio de sesión',
                              style: TextStyle(
                                color: Color(0xFFF27121),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Recuperar Contraseña',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1C29),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Ingresa tu correo electrónico para recibir instrucciones sobre cómo restablecer tu acceso.',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Correo electrónico',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1C29),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'nombre@ejemplo.com',
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Colors.blueGrey,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _recoveryPassword();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF27121),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 5,
                            shadowColor: const Color(
                              0xFFF27121,
                            ).withValues(alpha: 0.4),
                          ),
                          child: const Text(
                            'Recuperar contraseña',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¿Necesitas ayuda adicional? ',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 13),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Contactar soporte',
                      style: TextStyle(
                        color: Color(0xFFF27121),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _recoveryPassword() async {
    String email = _emailController.text.trim();
    try {
      await _firebaseApi.recoveryPassword(email);
      if (mounted) {
        MessengerUtils.showMsg(
          context,
          'Se ha enviado un enlace de recuperación a tu correo',
        );
        Navigator.pop(context);
      }
    } catch (e) {
      MessengerUtils.showMsg(context, FirebaseErrors.mapMessage(e.toString()));
    }
  }
}
