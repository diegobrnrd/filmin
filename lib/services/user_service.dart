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
        .where('username', isEqualTo: username.toLowerCase())
        .get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    final userDoc = snapshot.docs.first;

    final watchedSnapshot = await userDoc.reference.collection('watched').get();

    return watchedSnapshot.docs
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
  }

  Future<List<Map<String, dynamic>>> getAnotherUserWatchlist(
      String username) async {
    final snapshot = await _firestore
        .collection('users')
        .where('username', isEqualTo: username.toLowerCase())
        .get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    final userDoc = snapshot.docs.first;

    final watchedSnapshot =
        await userDoc.reference.collection('watchlist').get();

    return watchedSnapshot.docs
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
  }

  Future<List<Map<String, dynamic>>> getAnotherUserFavoriteMovies(
      String username) async {
    final snapshot = await _firestore
        .collection('users')
        .where('username', isEqualTo: username.toLowerCase())
        .get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    final userDoc = snapshot.docs.first;

    final watchedSnapshot =
        await userDoc.reference.collection('favorite_movies').get();

    return watchedSnapshot.docs
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
  }

  Future<List<Map<String, dynamic>>> getAnotherUserLists(
      String username) async {
    final snapshot = await _firestore
        .collection('users')
        .where('username', isEqualTo: username.toLowerCase())
        .get();
    if (snapshot.docs.isEmpty) {
      return [];
    }
    final userDoc = snapshot.docs.first;
    final listsSnapshot = await userDoc.reference.collection('lists').get();
    return listsSnapshot.docs.map((doc) {
      return {
        'documentId': doc.id, // ID único da lista
        'name': doc['name'], // Nome da lista
        'description': doc['description'], // Descrição da lista
      };
    }).toList(); // Retorna uma lista vazia se o usuário não estiver autenticado
  }

  Stream<QuerySnapshot> getAnotherUserReviews(String userId) {
    return _firestore
        .collection('reviews')
        .where('userUid', isEqualTo: userId)
        .snapshots();
  }

  Future<List<Map<String, dynamic>>> getListFromAnotherUser(
      String username, String nomeLista) async {
    final snapshot = await _firestore
        .collection('users')
        .where('username', isEqualTo: username.toLowerCase())
        .get();
    if (snapshot.docs.isEmpty) {
      return [];
    }

    final userDoc = snapshot.docs.first;
    final listsSnapshot = await userDoc.reference
        .collection('lists')
        .where('name', isEqualTo: nomeLista)
        .get();

    final listaRef =
        await listsSnapshot.docs.first.reference.collection('movies').get();

    return listaRef.docs
        .map((doc) => {
              'documentId': doc.id,
              'id': doc['id'],
              'release_date': doc['release_date'],
              'poster_path': doc['poster_path'],
              'genres': doc['genres'],
              'runtime': doc['runtime'],
              'dateAdded': doc['dateAdded'],
              'title': doc['title'],
            })
        .toList();
  }
  Future<void> followUser(String? currentUserId, String targetUserId) async {
    final userRef = _firestore.collection('users').doc(currentUserId);
    final targetUserRef = _firestore.collection('users').doc(targetUserId);

    // Obtém os dados do usuário alvo
    final targetUserSnapshot = await targetUserRef.get();
    final targetUserData = targetUserSnapshot.data() as Map<String, dynamic>?;

    if (targetUserData != null) {
      // Adiciona os dados do usuário alvo à subcoleção 'following' do usuário atual
      await userRef.collection('following').doc(targetUserId).set({
        'username': targetUserData['username'],
        'profilePictureUrl': targetUserData['profilePictureUrl'] ?? '', // Usar string vazia se nulo
      });

      // Obtém os dados do usuário atual
      final currentUserSnapshot = await userRef.get();
      final currentUserData = currentUserSnapshot.data() as Map<String, dynamic>?;

      if (currentUserData != null) {
        // Adiciona os dados do usuário atual à subcoleção 'followers' do usuário alvo
        await targetUserRef.collection('followers').doc(currentUserId).set({
          'username': currentUserData['username'],
          'profilePictureUrl': currentUserData['profilePictureUrl'] ?? '', // Usar string vazia se nulo
        });
      }
    }

    await userRef.update({'followingCount': FieldValue.increment(1)});
    await targetUserRef.update({'followersCount': FieldValue.increment(1)});
  }

  Future<void> unfollowUser(String? currentUserId, String targetUserId) async {
    final userRef = _firestore.collection('users').doc(currentUserId);
    final targetUserRef = _firestore.collection('users').doc(targetUserId);

    await userRef.collection('following').doc(targetUserId).delete();
    await targetUserRef.collection('followers').doc(currentUserId).delete();

    await userRef.update({'followingCount': FieldValue.increment(-1)});
    await targetUserRef.update({'followersCount': FieldValue.increment(-1)});
  }

  Future<int> getFollowersCount(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    return userDoc.data()?['followersCount'] ?? 0;
  }

  Future<int> getFollowingCount(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    return userDoc.data()?['followingCount'] ?? 0;
  }

  Future<bool> isFollowing(String? currentUserId, String targetUserId) async {
    final doc = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('following')
        .doc(targetUserId)
        .get();
    return doc.exists;
  }

  // Função assíncrona para verificar se o usuário está seguindo
  Future<bool> checkIfFollowing(String? currentUserId, String userUid) async {
    return await UserService().isFollowing(currentUserId, userUid);
  }

  

  Future<int> getAnotherUserReviewsCount(String userId) async {
  QuerySnapshot snapshot = await _firestore
      .collection('reviews')
      .where('userUid', isEqualTo: userId)
      .get(); 

  return snapshot.docs.length; 
}

}
