import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signInWithEmailAndPassword(
      {required String email, required String senha}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: senha);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return 'e-mail inválido';
        case 'missing-password':
          return 'senha não informada';
        case 'invalid-credential':
          return 'credencial inválida';
      }
      return e.code;
    }
    return null;
  }

  Future<String?> signUpWithEmailAndPassword({
    required String email,
    required String senha,
    required String nome,
    required String sobrenome,
    required String username,
  }) async {
    try {
      bool usernameExists = await _checkUsernameExists(username);
      if (usernameExists) {
        return 'Nome de usuário já em uso';
      }

      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      String uid = userCredential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'nome': nome,
        'sobrenome': sobrenome,
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'E-mail já cadastrado';
        case 'invalid-email':
          return 'E-mail inválido';
        case 'missing-password':
          return 'Senha não informada';
        case 'weak-password':
          return 'Senha fraca';
      }
      return e.code;
    } catch (e) {
      return 'Erro inesperado: $e';
    }
  }

  Future<bool> _checkUsernameExists(String username) async {
    QuerySnapshot query = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    return query.docs.isNotEmpty;
  }

  Future<String?> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
    return null;
  }

  Future<String?> deleteAccount({required String senha}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: _firebaseAuth.currentUser!.email!, password: senha);
      await _firebaseAuth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
    return null;
  }
}
