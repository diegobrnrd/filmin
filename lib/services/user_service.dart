import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserDataByUsername(String username) async {
    try {
      // Realiza a consulta no Firestore para buscar o usuário com o nome de usuário fornecido
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username.toLowerCase())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Caso o usuário seja encontrado, retornamos os dados do primeiro documento encontrado
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        return userDoc.data() as Map<String, dynamic>;
      } else {
        // Caso o nome de usuário não seja encontrado
        return null;
      }
    } catch (e) {
      // Caso ocorra algum erro
      return {'error': 'Erro ao buscar dados do usuário: $e'};
    }
  }

  Future<DocumentSnapshot?> getUserDocById(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        return userDoc; 
      } else {
        return null; 
      }
    } catch (e) {
      return null; 
    }
  }

}

