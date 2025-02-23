import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Criar uma crítica
  Future<void> addReview(String movieId, String content) async {
    String userId = _auth.currentUser!.uid;
    await _db.collection('reviews').add({
      'userId': userId,
      'movieId': movieId,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Editar uma crítica
  Future<void> updateReview(String reviewId, String newContent, double newRating) async {
    String userId = _auth.currentUser!.uid;
    DocumentSnapshot doc = await _db.collection('reviews').doc(reviewId).get();
    if (doc.exists && doc['userId'] == userId) {
      await _db.collection('reviews').doc(reviewId).update({
        'content': newContent,
        'rating': newRating,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  // Apagar uma crítica
  Future<void> deleteReview(String reviewId) async {
    String userId = _auth.currentUser!.uid;
    DocumentSnapshot doc = await _db.collection('reviews').doc(reviewId).get();
    if (doc.exists && doc['userId'] == userId) {
      await _db.collection('reviews').doc(reviewId).delete();
    }
  }

  // Obter críticas do usuário autenticado
  Stream<QuerySnapshot> getUserReviews() {
    String userId = _auth.currentUser!.uid;
    return _db.collection('reviews').where('userId', isEqualTo: userId).snapshots();
  }

  // Obter críticas de um filme específico
  Stream<QuerySnapshot> getMovieReviews(String movieId) {
    return _db.collection('reviews').where('movieId', isEqualTo: movieId).snapshots();
  }

}
