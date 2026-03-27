import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_app_3/models/item.dart';

class FirebaseApi {

  Future<String?> signUp(String email, String password) async {
    try {
      final credenciales = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return credenciales.user?.uid;
    } on FirebaseAuthException catch (e) {
      print('FirebaseException: ${e.code}');
      throw e.code;
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.code}');
      throw e.code;
    }
  }

  Future<Object?> signIn(String email, String password) async {
    try {
      final credenciales = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return credenciales.user?.uid;
    } on FirebaseAuthException catch (e) {
      print('FirebaseException: ${e.code}');
      throw e.code;
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.code}');
      throw e.code;
    }
  }

  Future<void> recoveryPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print('FirebaseException: ${e.code}');
      throw e.code;
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.code}');
      throw e.code;
    }
  }

  String get currentUserEmail {
    return FirebaseAuth.instance.currentUser?.email ?? 'Sin correo registrado';
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> createItem(Item item) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final document = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('items')
          .doc();
      item.id = document.id;
      await document.set(item.toJson());
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.code}');
      throw e.code;
    }
  }

  Future<void> deleteItem(String itemId) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('items')
          .doc(itemId)
          .delete();
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.code}');
      throw e.code;
    }
  }

  Future<void> updateItem(String itemId, Map<String, dynamic> data) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('items')
          .doc(itemId)
          .update(data);
    });
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.code}');
      throw e.code;
    }
  }
}
