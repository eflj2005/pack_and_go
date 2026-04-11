import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_app_3/models/item.dart';
import 'package:test_app_3/models/usuario.dart';

class FirebaseApi {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<Object?> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      return userCredential.user?.uid;
    } on FirebaseAuthException catch (e) {
      print('FirebaseException: ${e.code}');
      throw e.code;
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.code}');
      throw e.code;
    }
  }

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

      String? token = await FirebaseMessaging.instance.getToken();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credenciales.user?.uid)
          .set({
            'fcmToken': token,
            'updateAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
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

  Future<bool> validateSession() async {
    return FirebaseAuth.instance.currentUser == null;
  }

  Future<void> createItem(Item item, File? imageFile) async {
    try {
      final storage = FirebaseStorage.instance;
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final document = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('items')
          .doc();
      item.id = document.id;

      Reference referencia = storage
          .ref()
          .child('users')
          .child(uid!)
          .child('item_pictures')
          .child('${item.id}.jpg');

      SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
      UploadTask uploadTask = referencia.putFile(imageFile!, metadata);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      item.image = downloadUrl;

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

      await FirebaseStorage.instance
          .ref()
          .child('users')
          .child(uid!)
          .child('item_pictures')
          .child('$itemId.jpg')
          .delete();
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.code}');
      throw e.code;
    }
  }

  Future<void> updateItem(
    String itemId,
    Map<String, dynamic> data,
    File? imageFile,
  ) async {
    try {
      final storage = FirebaseStorage.instance;
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (imageFile != null) {
        Reference referencia = storage
            .ref()
            .child('users')
            .child(uid!)
            .child('item_pictures')
            .child('$itemId.jpg');

        SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
        UploadTask uploadTask = referencia.putFile(imageFile, metadata);

        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        data['image'] = downloadUrl;
      } else {
        await FirebaseStorage.instance
            .ref()
            .child('users')
            .child(uid!)
            .child('item_pictures')
            .child('$itemId.jpg')
            .delete();
        data['image'] = '';
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('items')
          .doc(itemId)
          .update(data);
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.code}');
      throw e.code;
    }
  }

  Future<void> updateItemCompletion(String itemId, bool isCompleted) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('items')
          .doc(itemId)
          .update({'isCompleted': isCompleted});
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.code}');
      throw e.code;
    }
  }

  Future<void> createUser(Usuario? user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .set(user.toJson());
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.code}');
      throw e.code;
    }
  }
}
