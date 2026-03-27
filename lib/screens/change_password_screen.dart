import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1C29)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Cambiar Contraseña',
          style: TextStyle(color: Color(0xFF1A1C29), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Header Icon
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5F0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.history_rounded,
                  color: Color(0xFFF27121),
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Tu nueva contraseña debe tener al menos 8 caracteres e incluir una combinación de letras y números.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueGrey, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 40),

            // Form Fields
            _buildLabel('Contraseña Actual'),
            _buildPasswordField(
              controller: _currentPasswordController,
              hint: 'Introduce tu contraseña actual',
              obscure: _obscureCurrent,
              onToggle: () => setState(() => _obscureCurrent = !_obscureCurrent),
              showSuffix: false,
            ),
            const SizedBox(height: 24),

            _buildLabel('Nueva Contraseña'),
            _buildPasswordField(
              controller: _newPasswordController,
              hint: 'Crea una contraseña segura',
              obscure: _obscureNew,
              onToggle: () => setState(() => _obscureNew = !_obscureNew),
            ),
            const SizedBox(height: 24),

            _buildLabel('Confirmar Nueva Contraseña'),
            _buildPasswordField(
              controller: _confirmPasswordController,
              hint: 'Repite tu nueva contraseña',
              obscure: _obscureConfirm,
              onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
            ),
            const SizedBox(height: 32),

            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5F0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.security_rounded, color: Color(0xFFF27121), size: 20),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Al cambiar tu contraseña, se cerrarán todas las sesiones activas en otros dispositivos para mantener la seguridad de tu cuenta de Pack & Go.',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Update Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Lógica para actualizar contraseña
                  Navigator.pop(context);
                },
                icon: const Text('Actualizar Contraseña', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                label: const Icon(Icons.key_rounded, size: 20),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF27121),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  elevation: 8,
                  shadowColor: const Color(0xFFF27121).withOpacity(0.3),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A1C29), fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    bool showSuffix = true,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: showSuffix 
          ? IconButton(
              icon: Icon(
                obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: Colors.blueGrey,
                size: 20,
              ),
              onPressed: onToggle,
            )
          : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
      ),
    );
  }
}
