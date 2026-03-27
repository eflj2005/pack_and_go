import 'package:flutter/material.dart';
import 'package:test_app_3/repository/firebase_api.dart';
import 'package:test_app_3/screens/edit_profile_screen.dart';
import 'package:test_app_3/screens/change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseApi _firebaseApi = FirebaseApi();
  bool _travelAlerts = true;
  bool _reminders = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Header
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
                          child: const Icon(Icons.edit, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'John Doe',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1C29)),
                  ),
                  Text(
                    _firebaseApi.currentUserEmail,
                    style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Personal Information Section
            _buildSectionHeader('INFORMACIÓN PERSONAL', showEdit: true),
            _buildInfoCard([
              _buildInfoTile(Icons.person_outline, 'Nombre', 'John Doe'),
              _buildDivider(),
              _buildInfoTile(Icons.phone_outlined, 'Teléfono', '+34 600 000 000'),
              _buildDivider(),
              _buildInfoTile(Icons.cake_outlined, 'Fecha de Nacimiento', '05/15/1990'),
            ]),

            const SizedBox(height: 24),

            // Notifications Section
            _buildSectionHeader('NOTIFICACIONES'),
            _buildInfoCard([
              _buildSwitchTile(Icons.notifications_none, 'Alertas de Viaje', _travelAlerts, (val) {
                setState(() => _travelAlerts = val);
              }),
              _buildDivider(),
              _buildSwitchTile(Icons.timer_outlined, 'Recordatorios', _reminders, (val) {
                setState(() => _reminders = val);
              }),
            ]),

            const SizedBox(height: 24),

            // Security Section
            _buildSectionHeader('SEGURIDAD'),
            _buildInfoCard([
              _buildInfoTile(Icons.lock_outline, 'Cambiar Contraseña', '', isChevronOnly: true, onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                );
              }),
            ]),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool showEdit = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey, letterSpacing: 1),
          ),
          if (showEdit)
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                );
              },
              icon: const Icon(Icons.edit, size: 14, color: Color(0xFFF27121)),
              label: const Text('EDITAR', style: TextStyle(color: Color(0xFFF27121), fontSize: 12, fontWeight: FontWeight.bold)),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFFFF5F0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value, {bool isChevronOnly = false, VoidCallback? onTap}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5F0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFFF27121), size: 20),
      ),
      title: isChevronOnly ? Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A1C29))) : Text(title, style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
      subtitle: isChevronOnly ? null : Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1C29))),
      trailing: const Icon(Icons.chevron_right, color: Colors.blueGrey, size: 20),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, bool value, Function(bool) onChanged) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5F0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFFF27121), size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1C29))),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFFF27121),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 70, color: Colors.grey.withOpacity(0.1));
  }
}
