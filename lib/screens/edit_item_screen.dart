import 'package:flutter/material.dart';
import 'package:test_app_3/utils/messenger_utils.dart';

class EditItemScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const EditItemScreen({super.key, required this.item});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _descriptionController;
  late String _selectedUnit;
  late String _selectedPriority;

  final List<String> _units = [
    'unidades',
    'pares',
    'botellas',
    'paquetes',
    'cajas',
    'otros',
  ];
  final List<String> _priorities = ['Baja', 'Media', 'Alta'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item['name']);
    // Extraemos el número de la cantidad (ej: "1 UD" -> "1")
    String quantityText = widget.item['quantity'].toString().split(' ')[0];
    _quantityController = TextEditingController(text: quantityText);
    _descriptionController = TextEditingController(
      text: widget.item['description'],
    );

    _selectedUnit =
        'unidades'; // Valor por defecto o extraer del item si es posible
    _selectedPriority =
        widget.item['priority'][0].toUpperCase() +
        widget.item['priority'].substring(1).toLowerCase();

    // Validamos que la prioridad esté en nuestra lista
    if (!_priorities.contains(_selectedPriority)) {
      _selectedPriority = 'Media';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
          'Editar Ítem',
          style: TextStyle(
            color: Color(0xFF1A1C29),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Foto del ítem',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1C29),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    image: DecorationImage(
                      image: NetworkImage(widget.item['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        // Lógica para eliminar foto
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildLabel('Nombre del ítem'),
            _buildTextField(controller: _nameController, hint: 'Nombre'),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Unidad'),
                      _buildDropdownField(_units, _selectedUnit, (val) {
                        setState(() => _selectedUnit = val!);
                      }),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildLabel('Prioridad'),
            _buildDropdownField(_priorities, _selectedPriority, (val) {
              setState(() => _selectedPriority = val!);
            }),
            const SizedBox(height: 24),

            _buildLabel('Descripción'),
            _buildTextField(
              controller: _descriptionController,
              hint: 'Detalles...',
              maxLines: 4,
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  updateItem();
                  // Lógica para guardar cambios
                  // Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF27121),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                  shadowColor: const Color(0xFFF27121).withOpacity(0.3),
                ),
                child: const Text(
                  'Guardar Cambios',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildDropdownField(
    List<String> items,
    String value,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: items.map((String val) {
            return DropdownMenuItem<String>(value: val, child: Text(val));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  void updateItem() {
    String name = _nameController.text.trim();
    String quantity = _quantityController.text.trim();
    String description = _descriptionController.text.trim();
    String priority = _selectedPriority.toUpperCase();
    String unit = _selectedUnit;

    try {
      map<String, dynamic> data = {
        'name': name,
        'quantity': '$quantity ${unit == 'unidades' ? 'UD' : unit.substring(0,2)},
        'description': description,
        'priority': priority,
        'image': widget.item['image'],
        'isCompleted': widget.item['isCompleted'],
      };

      
    } catch (e) {
      if (mounted) {
        MessengerUtils.showMsg(
          context,
          FirebaseErrors.mapMessage(e.toString()),
        );
      }
    }
  }
}
