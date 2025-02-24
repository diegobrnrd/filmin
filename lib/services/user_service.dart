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

  Future<List<Map<String, dynamic>>> getAnotherUserWatched(
      String username) async {
    final snapshot = await _firestore
        .collection('users')
        .where('username', isEqualTo: username.toLowerCase()).get();

        if (snapshot.docs.isEmpty) {
      return []; 
    }

    final userDoc = snapshot.docs.first;

    final watchedSnapshot = await userDoc.reference.collection('watched').get();

    return watchedSnapshot.docs.map((doc) => {
          'documentId': doc.id,
          'id': doc['id'],
          'release_date': doc['release_date'],
          'poster_path': doc['poster_path'],
          'genres': doc['genres'],
          'runtime': doc['runtime'],
          'dateAdded': doc['dateAdded'],
        }).toList();
    }

  Future<List<Map<String, dynamic>>> getAnotherUserWatchlist(
      String username) async {
    final snapshot = await _firestore
        .collection('users')
        .where('username', isEqualTo: username.toLowerCase()).get();

        if (snapshot.docs.isEmpty) {
      return []; 
    }

    final userDoc = snapshot.docs.first;

    final watchedSnapshot = await userDoc.reference.collection('watchlist').get();

    return watchedSnapshot.docs.map((doc) => {
          'documentId': doc.id,
          'id': doc['id'],
          'release_date': doc['release_date'],
          'poster_path': doc['poster_path'],
          'genres': doc['genres'],
          'runtime': doc['runtime'],
          'dateAdded': doc['dateAdded'],
        }).toList();
    }

    Future<List<Map<String, dynamic>>> getAnotherUserFavoriteMovies(
      String username) async {
    final snapshot = await _firestore
        .collection('users')
        .where('username', isEqualTo: username.toLowerCase()).get();

        if (snapshot.docs.isEmpty) {
      return []; 
    }

    final userDoc = snapshot.docs.first;

    final watchedSnapshot = await userDoc.reference.collection('favorite_movies').get();

    return watchedSnapshot.docs.map((doc) => {
          'documentId': doc.id,
          'id': doc['id'],
          'release_date': doc['release_date'],
          'poster_path': doc['poster_path'],
          'genres': doc['genres'],
          'runtime': doc['runtime'],
          'dateAdded': doc['dateAdded'],
        }).toList();
    }
}
