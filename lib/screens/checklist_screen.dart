import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_app_3/repository/firebase_api.dart';
import 'package:test_app_3/screens/edit_item_screen.dart';
import 'package:test_app_3/utils/firebase_errors.dart';
import 'package:test_app_3/utils/messenger_utils.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  // Simulación de datos para el StreamBuilder que implementarás

  final _firebaseApi = FirebaseApi();

  // final List<Map<String, dynamic>> _mockItems = [
  //   {
  //     'id': '1',
  //     'name': 'Cámara DSLR',
  //     'quantity': '1 UD',
  //     'priority': 'ALTA',
  //     'description': 'No olvidar el cargador y la tarjeta SD de repuesto.',
  //     'image':
  //         'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=200&auto=format&fit=crop',
  //     'isCompleted': false,
  //   },
  //   {
  //     'id': '2',
  //     'name': 'Pasaporte',
  //     'quantity': '1 UD',
  //     'priority': 'ALTA',
  //     'description': 'Verificar fecha de vencimiento.',
  //     'image':
  //         'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?q=80&w=200&auto=format&fit=crop',
  //     'isCompleted': true,
  //   },
  //   {
  //     'id': '3',
  //     'name': 'Botiquín',
  //     'quantity': '2 UNIDADES',
  //     'priority': 'MEDIA',
  //     'description': 'Incluir paracetamol y vendas elásticas.',
  //     'image':
  //         'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?q=80&w=200&auto=format&fit=crop',
  //     'isCompleted': false,
  //   },
  //   {
  //     'id': '4',
  //     'name': 'Auriculares',
  //     'quantity': '1 UD',
  //     'priority': 'BAJA',
  //     'description': 'Para el vuelo largo, cargar antes de salir.',
  //     'image':
  //         'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=200&auto=format&fit=crop',
  //     'isCompleted': false,
  //   },
  // ];

  void _updateItemCompletion(String id, bool isCompleted) async {
    try {
      await _firebaseApi.updateItemCompletion(id, isCompleted);
    } catch (e) {
      MessengerUtils.showMsg(context, FirebaseErrors.mapMessage(e.toString()));
    }
  }

  Widget _buildDialogButton({
    required String label,
    IconData? icon,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 10),
            ],
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority, bool isCompleted) {
    if (isCompleted) return Colors.grey;
    switch (priority) {
      case 'ALTA':
        return Colors.redAccent;
      case 'MEDIA':
        return Colors.orange;
      case 'BAJA':
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }

  Future<void> _deleteItem(String itemId) async {
    try {
      await _firebaseApi.deleteItem(itemId);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        MessengerUtils.showMsg(
          context,
          FirebaseErrors.mapMessage(e.toString()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('items')
          .snapshots(), // Aquí conectarás tu Stream de Firebase o Base de Datos
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No hay items en lista');
        }

        // final items = _mockItems;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data?.docs.length,
          itemBuilder: (context, index) {
            final item = snapshot.data?.docs[index];
            return _buildItemCard(item);
          },
        );
      },
    );
  }

  Widget _buildItemCard(QueryDocumentSnapshot<Object?>? item) {
    bool isCompleted = item!['isCompleted'];

    return GestureDetector(
      onLongPress: () => _showItemOptionsDialog(item),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isCompleted ? 0.6 : 1.0,
        child: Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: isCompleted
                  ? Colors.transparent
                  : Colors.grey.withOpacity(0.1),
            ),
          ),
          elevation: isCompleted ? 0 : 2,
          color: isCompleted ? Colors.grey[100] : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen del ítem
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Ink.image(
                    image: (item['image'].isEmpty || item['image'] == null)
                        ? const AssetImage('assets/images/logo.png')
                        : NetworkImage(item['image']),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    colorFilter: isCompleted
                        ? const ColorFilter.mode(
                            Colors.grey,
                            BlendMode.saturation,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                // Detalles del ítem
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isCompleted
                              ? Colors.grey
                              : const Color(0xFF1A1C29),
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            item['quantity'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isCompleted
                                  ? Colors.grey
                                  : const Color(0xFFF27121),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.circle, size: 6, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            item['priority'],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: _getPriorityColor(
                                item['priority'],
                                isCompleted,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['description'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: isCompleted ? Colors.grey : Colors.blueGrey,
                          fontStyle: isCompleted
                              ? FontStyle.italic
                              : FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                // Checkbox personalizado (estilo circular según imagen)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _updateItemCompletion(item.id, !isCompleted);
                    });
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? const Color(0xFFF27121)
                          : Colors.transparent,
                      border: Border.all(
                        color: isCompleted
                            ? const Color(0xFFF27121)
                            : const Color(0xFFF27121).withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: isCompleted
                        ? const Icon(Icons.check, size: 18, color: Colors.white)
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showItemOptionsDialog(QueryDocumentSnapshot<Object?> item) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 10,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Opciones del Ítem',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1C29),
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey,
                    ),
                    children: [
                      const TextSpan(text: 'Selecciona una acción para '),
                      TextSpan(
                        text: '"${item['name']}"',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1C29),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Botón Editar
                _buildDialogButton(
                  label: 'Editar',
                  icon: Icons.edit,
                  backgroundColor: const Color(0xFFF27121),
                  textColor: Colors.white,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditItemScreen(item: item),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Botón Confirmar Eliminar
                _buildDialogButton(
                  label: 'Eliminar',
                  icon: Icons.delete_outline,
                  backgroundColor: const Color(0xFFFFF0F0),
                  textColor: Colors.red,
                  onTap: () {
                    _deleteItem(item.id);
                    //Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 12),

                // Botón Cancelar
                _buildDialogButton(
                  label: 'Cancelar',
                  backgroundColor: const Color(0xFFF8F9FA),
                  textColor: const Color(0xFF1A1C29),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // void _showDeleteConfirmationDialog(QueryDocumentSnapshot<Object?> item) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(24),
  //         ),
  //         elevation: 10,
  //         backgroundColor: Colors.white,
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               // Icono superior
  //               Container(
  //                 padding: const EdgeInsets.all(16),
  //                 decoration: BoxDecoration(
  //                   color: const Color(0xFFFFF0F0),
  //                   shape: BoxShape.circle,
  //                 ),
  //                 child: const Icon(
  //                   Icons.delete_rounded,
  //                   color: Colors.red,
  //                   size: 32,
  //                 ),
  //               ),
  //               const SizedBox(height: 24),
  //               const Text(
  //                 '¿Eliminar ítem?',
  //                 style: TextStyle(
  //                   fontSize: 22,
  //                   fontWeight: FontWeight.bold,
  //                   color: Color(0xFF1A1C29),
  //                 ),
  //               ),
  //               const SizedBox(height: 12),
  //               RichText(
  //                 textAlign: TextAlign.center,
  //                 text: TextSpan(
  //                   style: const TextStyle(
  //                     fontSize: 15,
  //                     color: Colors.blueGrey,
  //                     height: 1.5,
  //                   ),
  //                   children: [
  //                     const TextSpan(
  //                       text: '¿Estás seguro de que deseas eliminar ',
  //                     ),
  //                     TextSpan(
  //                       text: '"${item['name']}"',
  //                       style: const TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                         color: Color(0xFF1A1C29),
  //                       ),
  //                     ),
  //                     const TextSpan(
  //                       text: ' de tu lista? Esta acción no se puede deshacer.',
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(height: 32),

  //               // Botón Confirmar Eliminar
  //               _buildDialogButton(
  //                 label: 'Eliminar',
  //                 backgroundColor: const Color(0xFFF27121),
  //                 textColor: Colors.white,
  //                 onTap: () {
  //                   // Lógica para eliminar el item
  //                   deleteItem(item.id);
  //                   // Navigator.pop(context);
  //                 },
  //               ),
  //               const SizedBox(height: 12),

  //               // Botón Cancelar
  //               _buildDialogButton(
  //                 label: 'Cancelar',
  //                 backgroundColor: const Color(0xFFF8F9FA),
  //                 textColor: const Color(0xFF1A1C29),
  //                 onTap: () => Navigator.pop(context),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
