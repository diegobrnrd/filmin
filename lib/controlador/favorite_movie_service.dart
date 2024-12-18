import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteMovieService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> addFavoriteMovie(Map<String, dynamic> movie) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final docRef = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorite_movies')
          .add({
        'id': movie['id'],
        'release_date': movie['release_date'],
        'poster_path': movie['poster_path'],
        'genres': movie['genres'].map((genre) => {
          'id': genre['id'],
          'name': genre['name'],
        }).toList(),
        'runtime': movie['runtime'],
        'dateAdded': Timestamp.now(),
      });

      // Atualiza o documento para incluir o próprio document ID
      await docRef.update({'documentId': docRef.id});
    }
  }

  Future<void> updateFavoriteMovie(String movieId, Map<String, dynamic> updatedData) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorite_movies')
          .doc(movieId)
          .update({
        'release_date': updatedData['release_date'],
        'poster_path': updatedData['poster_path'],
        'genres': updatedData['genres'].map((genre) => {
          'id': genre['id'],
          'name': genre['name'],
        }).toList(),
        'runtime': updatedData['runtime'],
        'dateAdded': updatedData['dateAdded'],
      });
    }
  }

  Future<void> deleteFavoriteMovie(String documentId) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorite_movies')
          .doc(documentId)
          .delete();
    }
  }

  Stream<List<Map<String, dynamic>>> getFavoriteMovies() {
    final User? user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorite_movies')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => {
                    'documentId': doc.id, // Adiciona o document ID
                    'id': doc['id'],
                    'release_date': doc['release_date'],
                    'poster_path': doc['poster_path'],
                    'genres': doc['genres'],
                    'runtime': doc['runtime'],
                    'dateAdded': doc['dateAdded'],
                  })
              .toList());
    } else {
      return const Stream.empty();
    }
  }

  Future<List<Map<String, dynamic>>> getFavoriteMoviesOnce() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorite_movies')
          .get();
      return snapshot.docs
          .map((doc) => {
                'documentId': doc.id, // Adiciona o document ID
                'id': doc['id'],
                'release_date': doc['release_date'],
                'poster_path': doc['poster_path'],
                'genres': doc['genres'],
                'runtime': doc['runtime'],
                'dateAdded': doc['dateAdded'],
              })
          .toList();
    } else {
      return [];
    }
  }
}
