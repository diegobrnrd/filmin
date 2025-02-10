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
      String normalizedUsername = username.toLowerCase();

      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      String uid = userCredential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'nome': nome,
        'sobrenome': sobrenome,
        'username': normalizedUsername,
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
        default:
          return 'Erro ao criar conta: ${e.message}';
      }
    } catch (e) {
      return 'Erro inesperado: $e';
    }
  }

  Future<bool> checkUsernameExists(String username) async {
    QuerySnapshot query = await _firestore
        .collection('users')
        .where('username', isEqualTo: username.toLowerCase())
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

  Future<String?> getUserName() async {
    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .get();
      return userDoc['nome'];
    } catch (e) {
      return 'Erro ao obter o nome do usuário: $e';
    }
  }

  Future<String?> getUserSurname() async {
    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .get();
      return userDoc['sobrenome'];
    } catch (e) {
      return 'Erro ao obter o sobrenome do usuário: $e';
    }
  }

  Future<String?> getUserUsername() async {
    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .get();
      return userDoc['username'];
    } catch (e) {
      return 'Erro ao obter o nome de usuário: $e';
    }
  }

  Future<String?> updateUserNameAndSurname(
      {String? nome, String? sobrenome}) async {
    try {
      Map<String, dynamic> updateData = {};
      if (nome != '') {
        updateData['nome'] = nome;
      }
      if (sobrenome != '') {
        updateData['sobrenome'] = sobrenome;
      }

      await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .update(updateData);

      return null;
    } catch (e) {
      return 'Erro ao atualizar nome e/ou sobrenome: $e';
    }
  }
}
