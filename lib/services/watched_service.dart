import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WatchedService {
	final FirebaseFirestore _firestore = FirebaseFirestore.instance;
	final FirebaseAuth _auth = FirebaseAuth.instance;

	User? getCurrentUser() {
		return _auth.currentUser;
	}
	
	Future<void> addToWatched(Map<String, dynamic> movie) async {
		final User? user = _auth.currentUser;
		if (user != null) {
			final docRef = await _firestore.collection('users')
      .doc(user.uid)
      .collection('watched')
      .add({
      'id': movie['id'],
      'release_date': movie['release_date'],
      'poster_path': movie['poster_path'],
      'genres': movie['genres']
        .map((genre) => {
              'id': genre['id'],
              'name': genre['name'],
            })
          .toList(),
      'runtime': movie['runtime'],
      'dateAdded': Timestamp.now(),
      });

      await docRef.update({'documentId': docRef.id});
      }}

	Future<void> deleteFromWatched(String documentId) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('watched')
          .doc(documentId)
          .delete();
        }
      }

Future<List<Map<String, dynamic>>> getWatched() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('watched')
          .get();
      return snapshot.docs
          .map((doc) => {
                'documentId': doc.id,
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


