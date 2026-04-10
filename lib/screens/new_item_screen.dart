import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_app_3/models/item.dart';
import 'package:test_app_3/repository/firebase_api.dart';
import 'package:test_app_3/utils/firebase_errors.dart';
import 'package:test_app_3/utils/messenger_utils.dart';

class NewItemScreen extends StatefulWidget {
  const NewItemScreen({super.key});

  @override
  State<NewItemScreen> createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _descriptionController = TextEditingController();

  final _firbaseApi = FirebaseApi();

  File? _imageFile;
  final ImagePicker _imagePicker = ImagePicker();

  String _selectedUnit = 'unidades';
  String _selectedPriority = 'Media';

  final List<String> _units = [
    'unidades',
    'pares',
    'botellas',
    'paquetes',
    'cajas',
    'otros',
  ];

  final List<String> _priorities = ['Baja', 'Media', 'Alta'];

  Future<void> _takePhoto(ImageSource camera) async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85, //0-100
      );

      if (photo == null) return;

      setState(() {
        _imageFile = File(photo.path);
      });
    } on PlatformException catch (e) {
      MessengerUtils.showMsg(context, 'Error al tomar la foto: $e');
    } catch (e) {
      MessengerUtils.showMsg(context, 'Error al tomar la foto: $e');
    }
  }

  Future<void> _saveItem() async {
    String name = _nameController.text.trim();
    String quantity = _quantityController.text.trim();
    String description = _descriptionController.text.trim();

    try {
      await _firbaseApi.createItem(
        Item(
          '',
          name,
          quantity,
          _selectedUnit,
          _selectedPriority,
          description,
          '',
          false,
        ),
        _imageFile,
      );
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      MessengerUtils.showMsg(context, FirebaseErrors.mapMessage(e.toString()));
    }
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A1C29),
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedUnit,
          isExpanded: true,
          items: _units.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedUnit = newValue!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildChip(String label, {required bool isUnit}) {
    bool isSelected = isUnit
        ? _selectedUnit == label
        : _selectedPriority == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isUnit) {
            _selectedUnit = label;
          } else {
            _selectedPriority = label;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF5F0) : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFF27121) : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? const Color(0xFFF27121) : Colors.blueGrey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildImagePickerCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5F0),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFFF27121), size: 30),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
          'Nuevo Ítem',
          style: TextStyle(
            color: Color(0xFF1A1C29),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Nombre del ítem'),
            _buildTextField(
              controller: _nameController,
              hint: 'Ej. Protector solar',
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Cantidad'),
                      _buildTextField(
                        controller: _quantityController,
                        hint: '1',
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_buildLabel('Unidad'), _buildDropdownField()],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Unit Quick Select Chips
            Wrap(
              spacing: 8,
              children: _units
                  .take(3)
                  .map((unit) => _buildChip(unit, isUnit: true))
                  .toList(),
            ),
            const SizedBox(height: 24),

            _buildLabel('Prioridad'),
            Row(
              children: _priorities
                  .map(
                    (priority) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: _buildChip(priority, isUnit: false),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),

            _buildLabel('Descripción'),
            _buildTextField(
              controller: _descriptionController,
              hint: 'Agregar detalles adicionales...',
              maxLines: 4,
            ),
            const SizedBox(height: 24),

            _buildLabel('Foto del ítem'),
            Row(
              children: [
                Expanded(
                  child: _buildImagePickerCard(
                    icon: Icons.camera_alt_outlined,
                    label: 'Tomar Foto',
                    onTap: () {
                      _takePhoto(ImageSource.camera);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildImagePickerCard(
                    icon: Icons.image_outlined,
                    label: 'Galería',
                    onTap: () {
                      _takePhoto(ImageSource.gallery);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Placeholder for selected image
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(20),
                image: _imageFile != null
                    ? DecorationImage(
                        image: FileImage(_imageFile!),
                        fit: BoxFit.cover,
                      )
                    : const DecorationImage(
                        image: NetworkImage(
                          'https://via.placeholder.com/400x150?text=Sin+imagen+seleccionada',
                        ),
                        fit: BoxFit.cover,
                        opacity: 0.5,
                      ),
              ),
              child: _imageFile == null
                  ? const Center(
                      child: Text(
                        'Sin imagen seleccionada',
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Lógica para guardar
                  _saveItem();
                },
                icon: const Icon(Icons.save_rounded),
                label: const Text(
                  'Guardar Ítem',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF27121),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
