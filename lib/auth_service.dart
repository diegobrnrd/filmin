import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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

  Future<String?> signUpWithEmailAndPassword(
      {required String email, required String senha}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: senha);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'e-mail já cadastrado';
        case 'invalid-email':
          return 'e-mail inválido';
        case 'missing-password':
          return 'senha não informada';
        case 'weak-password':
          return 'senha fraca';
      }
      return e.code;
    }
    return null;
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
