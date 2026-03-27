import 'package:flutter/material.dart';
import 'package:test_app_3/repository/firebase_api.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseApi _firebaseApi = FirebaseApi();
  final _nameController = TextEditingController(text: 'John Doe');
  final _phoneController = TextEditingController(text: '+34 600 000 000');
  final _dobController = TextEditingController(text: '05/15/1990');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1C29)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Editar Perfil',
          style: TextStyle(color: Color(0xFF1A1C29), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          children: [
            // Profile Image Section
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          image: const DecorationImage(
                            image: NetworkImage('https://img.freepik.com/vector-premium/avatar-perfil-hombre-estilo-dibujos-animados-vector-premium_202271-4628.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF27121),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'John Doe',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1C29)),
                  ),
                  const Text(
                    'Viajero Pack & Go',
                    style: TextStyle(fontSize: 14, color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFF5F0),
                      foregroundColor: const Color(0xFFF27121),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    ),
                    child: const Text('Cambiar foto', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Form Fields
            _buildLabel('Nombre Completo'),
            _buildTextField(
              controller: _nameController,
              hint: 'Tu nombre',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 20),

            _buildLabel('Correo Electrónico'),
            _buildTextField(
              controller: TextEditingController(text: _firebaseApi.currentUserEmail),
              hint: 'tu@email.com',
              icon: Icons.email_outlined,
              enabled: false,
              suffixIcon: const Icon(Icons.lock_outline, color: Colors.blueGrey, size: 18),
            ),
            const SizedBox(height: 20),

            _buildLabel('Teléfono'),
            _buildTextField(
              controller: _phoneController,
              hint: '+34 600 000 000',
              icon: Icons.phone_outlined,
            ),
            const SizedBox(height: 20),

            _buildLabel('Fecha de Nacimiento'),
            _buildTextField(
              controller: _dobController,
              hint: 'MM/DD/YYYY',
              icon: Icons.calendar_today_outlined,
              suffixIcon: const Icon(Icons.calendar_month, color: Color(0xFF1A1C29)),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(1990),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    _dobController.text = "${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.year}";
                  });
                }
              },
            ),
            const SizedBox(height: 40),

            // Update Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF27121),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 8,
                  shadowColor: const Color(0xFFF27121).withOpacity(0.3),
                ),
                child: const Text('Actualizar Perfil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tus datos personales están protegidos por Pack & Go.',
              style: TextStyle(color: Colors.blueGrey, fontSize: 12),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool enabled = true,
    Widget? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.blueGrey, size: 22),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: enabled ? Colors.white : const Color(0xFFF1F3F5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blueGrey.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blueGrey.withOpacity(0.1)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blueGrey.withOpacity(0.05)),
        ),
      ),
    );
  }
}
