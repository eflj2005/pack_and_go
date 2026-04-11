import 'package:flutter/material.dart';
import 'package:test_app_3/models/usuario.dart';
import 'package:test_app_3/repository/firebase_api.dart';
import 'package:test_app_3/utils/firebase_errors.dart';
import 'package:test_app_3/utils/messenger_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  bool _obscureRepeatPassword = true;
  String _selectedGender = 'Masculino';
  final TextEditingController _dobController = TextEditingController();
  final _nameTextEditingController = TextEditingController();
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _confirmPasswordTextEditingController = TextEditingController();
  final _phoneTextEditingController = TextEditingController();

  final _firebaseApi = FirebaseApi();

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A1C29),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    IconData icon = Icons.lock_outline,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: Colors.blueGrey,
            size: 20,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _genderChip(String label) {
    bool isSelected = _selectedGender == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedGender = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF27121) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFF27121)
                  : const Color(0xFFE0E0E0),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.blueGrey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _singUp() async {
    String name = _nameTextEditingController.text.trim();
    String email = _emailTextEditingController.text.trim();
    String password = _passwordTextEditingController.text.trim();
    String confirmPassword = _confirmPasswordTextEditingController.text.trim();
    String gender = _selectedGender;
    String birthday = _dobController.text.trim();
    String phone = _phoneTextEditingController.text.trim();

    if (password != confirmPassword) {
      MessengerUtils.showMsg(context, "Las contraseñas no coinciden");
      return;
    }
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        gender.isEmpty ||
        birthday.isEmpty) {
      MessengerUtils.showMsg(context, "Todos los campos son obligatorios");
      return;
    }
    try {
      final respuesta = await _firebaseApi.signUp(email, password);
      if (respuesta != null) {
        await _createUserInDB(
          Usuario(respuesta, name, email, phone, gender, birthday, ''),
        );
        Navigator.pop(context); //vuelve a singin
      }
    } catch (e) {
      MessengerUtils.showMsg(context, FirebaseErrors.mapMessage(e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Logo and Title
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF5F0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.travel_explore,
                            color: Color(0xFFF27121),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Pack & Go',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF27121),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Crea tu cuenta',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1C29),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Únete a nuestra comunidad de viajeros y empieza tu aventura.',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 14),
                    ),
                    const SizedBox(height: 32),

                    // Name Field
                    _buildLabel('Nombre completo'),
                    _buildTextField(
                      hint: 'Ej. Juan Pérez',
                      icon: Icons.person_outline,
                      controller: _nameTextEditingController,
                    ),
                    const SizedBox(height: 20),

                    // Email Field
                    _buildLabel('Correo electrónico'),
                    _buildTextField(
                      hint: 'tu@email.com',
                      icon: Icons.email_outlined,
                      controller: _emailTextEditingController,
                    ),
                    const SizedBox(height: 20),

                    // Password Field
                    _buildLabel('Contraseña'),
                    _buildPasswordField(
                      controller: _passwordTextEditingController,
                      hint: '••••••••',
                      obscure: _obscurePassword,
                      onToggle: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    const SizedBox(height: 20),

                    // Repeat Password Field
                    _buildLabel('Repetir contraseña'),
                    _buildPasswordField(
                      controller: _confirmPasswordTextEditingController,
                      hint: '••••••••',
                      obscure: _obscureRepeatPassword,
                      onToggle: () => setState(
                        () => _obscureRepeatPassword = !_obscureRepeatPassword,
                      ),
                      icon: Icons.history,
                    ),
                    const SizedBox(height: 20),

                    // Gender Selection
                    _buildLabel('Género'),
                    Row(
                      children: [
                        _genderChip('Masculino'),
                        const SizedBox(width: 10),
                        _genderChip('Femenino'),
                        const SizedBox(width: 10),
                        _genderChip('Otro'),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Date of Birth
                    _buildLabel('Fecha de nacimiento'),
                    TextField(
                      controller: _dobController,
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _dobController.text =
                                "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";
                          });
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'mm/dd/yyyy',
                        prefixIcon: const Icon(
                          Icons.calendar_today_outlined,
                          size: 20,
                        ),
                        suffixIcon: const Icon(Icons.calendar_month),
                        filled: true,
                        fillColor: const Color(0xFFF8F9FA),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Register Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _singUp();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF27121),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 8,
                          shadowColor: const Color(0xFFF27121).withOpacity(0.3),
                        ),
                        child: const Text(
                          'Registrar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Sign In Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('¿Ya tienes una cuenta? '),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            'Inicia sesión',
                            style: TextStyle(
                              color: Color(0xFFF27121),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'PACK & GO TRAVEL APP',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 10,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createUserInDB(Usuario? user) async {
    try {
      await _firebaseApi.createUser(user);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      MessengerUtils.showMsg(context, FirebaseErrors.mapMessage(e.toString()));
    }
  }
}
