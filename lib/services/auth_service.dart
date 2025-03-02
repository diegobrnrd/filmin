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
          return 'email inválido';
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
        'profilePictureUrl': '',
      });

      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'email já cadastrado';
        case 'invalid-email':
          return 'email inválido';
        case 'missing-password':
          return 'senha não informada';
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
      User? user = _firebaseAuth.currentUser;
      if (user == null) return 'usuário não autenticado';
      if (senha == '') {
        return 'senha não informada';
      }

      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: senha,
      );
      await user.reauthenticateWithCredential(credential);

      List<String> subCollections = [
        'watchlist',
        'watched',
        'favorite_movies',
        'lists'
      ];

      for (String collection in subCollections) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection(collection)
            .get();

        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          // Se a coleção for "lists", excluir a subcoleção "movies"
          if (collection == 'lists') {
            CollectionReference moviesRef = doc.reference.collection('movies');
            QuerySnapshot moviesSnapshot = await moviesRef.get();
            for (QueryDocumentSnapshot movieDoc in moviesSnapshot.docs) {
              await movieDoc.reference.delete();
            }
          }
          await doc.reference.delete();
        }
      }

      await _firestore.collection('users').doc(user.uid).delete();

      await user.delete();

      await _firebaseAuth.signOut();

      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
          return 'senha inválida';
        default:
          return 'erro ao excluir conta: ${e.message}';
      }
    } catch (e) {
      return 'erro inesperado: $e';
    }
  }

  Future<String?> getUserName() async {
    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .get();
      return userDoc['nome'];
    } catch (e) {
      return 'erro ao obter o nome do usuário: $e';
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
      return 'erro ao obter o sobrenome do usuário: $e';
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
      return 'erro ao obter o nome de usuário: $e';
    }
  }

  Future<String?> updateUserNameAndSurname(
      {String? nome, String? sobrenome}) async {
    if (nome == '' && sobrenome == '') {
      return 'nome e sobrenome vazios';
    }
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
      return 'erro ao atualizar nome e/ou sobrenome: $e';
    }
  }

  Future<String?> updateEmail(
      {required String newEmail, required String senha}) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user == null) return 'usuário não autenticado';
      if (newEmail == '' && senha == '') {
        return 'email e senha vazios';
      }

      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: senha,
      );
      await user.reauthenticateWithCredential(credential);
      await user.verifyBeforeUpdateEmail(newEmail);

      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({'email': newEmail});
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
          return 'credencial inválida';
        case 'missing-password':
          return 'senha não informada';
        default:
          return 'erro ao atualizar o email: ${e.message}';
      }
    } catch (e) {
      return 'erro inesperado: $e';
    }
  }

  Future<String?> updatePassword(
      {required String currentPassword, required String newPassword}) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user == null) return 'usuário não autenticado';

      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
          return 'senha inválida';
        case 'missing-password':
          return 'senha não informada';
        default:
          return 'erro ao atualizar o email: ${e.message}';
      }
    } catch (e) {
      return 'erro inesperado: $e';
    }
  }

  Future<String?> updateProfilePictureUrl(String imageUrl) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user == null) return 'usuário não autenticado';

      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({'profilePictureUrl': imageUrl});
      return null;
    } catch (e) {
      return 'erro ao atualizar a URL da foto de perfil: $e';
    }
  }

  Future<String?> getProfilePictureUrl() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user == null) return 'usuário não autenticado';

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      return userDoc['profilePictureUrl'];
    } catch (e) {
      return 'erro ao obter a URL da foto de perfil: $e';
    }
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return 'email inválido';
        case 'missing-email':
          return 'email não informado';
        default:
          return 'Erro ao enviar email de recuperação: ${e.message}';
      }
    } catch (e) {
      return 'Erro inesperado: $e';
    }
  }

  Future<Map<String, String>> getUserProfile(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      return {
        'username': userDoc['username'],
        'profilePictureUrl': userDoc['profilePictureUrl'],
      };
    } catch (e) {
      return {
        'username': 'Unknown',
        'profilePictureUrl': '',
      };
    }
  }
  Future<String?> getCurrentUsername() async {
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return null;

  try {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    // Faz o cast para Map<String, dynamic> antes de acessar os dados
    final data = userDoc.data() as Map<String, dynamic>?;

    return data?['username'] as String?;
  } catch (e) {
    return null; // Em caso de erro, retorna null
  }
}

  Future<String?> getCurrentUserId() async {
  return FirebaseAuth.instance.currentUser?.uid;
}

}
