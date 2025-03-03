import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importe FirebaseAuth

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Adicione FirebaseAuth

  Future<Map<String, dynamic>?> getUserDataByUsername(String username) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username.toLowerCase())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        return userDoc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
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
        'documentId': doc.id,
        'name': doc['name'],
        'description': doc['description'],
      };
    }).toList();
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

    final targetUserSnapshot = await targetUserRef.get();
    final targetUserData = targetUserSnapshot.data() as Map<String, dynamic>?;

    if (targetUserData != null) {
      await userRef.collection('following').doc(targetUserId).set({
        'username': targetUserData['username'],
        'profilePictureUrl': targetUserData['profilePictureUrl'] ?? '',
      });

      final currentUserSnapshot = await userRef.get();
      final currentUserData = currentUserSnapshot.data() as Map<String, dynamic>?;

      if (currentUserData != null) {
        await targetUserRef.collection('followers').doc(currentUserId).set({
          'username': currentUserData['username'],
          'profilePictureUrl': currentUserData['profilePictureUrl'] ?? '',
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

  Future<bool> checkIfFollowing(String? currentUserId, String userUid) async {
    return await isFollowing(currentUserId, userUid);
  }

  Future<int> getAnotherUserReviewsCount(String userId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('reviews')
        .where('userUid', isEqualTo: userId)
        .get();

    return snapshot.docs.length;
  }

  Future<void> adicionarMelhorFilme(String filmeId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        List<String> melhores4Filmes =
            (userDoc.data()?['4_melhores'] as List<dynamic>?)
                    ?.map((item) => item.toString())
                    .toList() ??
                [];

        if (melhores4Filmes.length >= 4) {
          throw Exception('Você já selecionou 4 filmes favoritos.');
        }

        melhores4Filmes.add(filmeId);

        await _firestore.collection('users').doc(user.uid).update({
          '4_melhores': melhores4Filmes,
        });
        print('Filme favorito adicionado com sucesso!');
      } catch (e) {
        print('Erro ao adicionar filme favorito: $e');
        throw Exception('Erro ao adicionar filme favorito: $e');
      }
    } else {
      throw Exception('Usuário não autenticado.');
    }
  }

  Future<bool> verificarLimiteMelhores4Filmes() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        List<String> melhores4Filmes =
            (userDoc.data()?['4_melhores'] as List<dynamic>?)
                    ?.map((item) => item.toString())
                    .toList() ??
                [];

        return melhores4Filmes.length >= 4;
      } catch (e) {
        print('Erro ao verificar limite de filmes favoritos: $e');
        return false; // Retorna falso em caso de erro para evitar bloqueio
      }
    } else {
      return false; // Retorna falso se o usuário não estiver autenticado
    }
  }
  Future<void> removerMelhorFilme(String filmeId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        List<String> melhores4Filmes =
            (userDoc.data()?['4_melhores'] as List<dynamic>?)
                    ?.map((item) => item.toString())
                    .toList() ??
                [];

        if (melhores4Filmes.contains(filmeId)) {
          melhores4Filmes.remove(filmeId);

          await _firestore.collection('users').doc(user.uid).update({
            '4_melhores': melhores4Filmes,
          });
          print('Filme favorito removido com sucesso!');
        } else {
          throw Exception('Filme não encontrado na lista de favoritos.');
        }
      } catch (e) {
        print('Erro ao remover filme favorito: $e');
        throw Exception('Erro ao remover filme favorito: $e');
      }
    } else {
      throw Exception('Usuário não autenticado.');
    }
  }
  Future<List<String>> getMelhores4FilmesIds() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        List<String> melhores4Filmes =
            (userDoc.data()?['4_melhores'] as List<dynamic>?)
                    ?.map((item) => item.toString())
                    .toList() ??
                [];

        return melhores4Filmes;
      } catch (e) {
        print('Erro ao obter IDs dos melhores 4 filmes: $e');
        return []; // Retorna uma lista vazia em caso de erro
      }
    } else {
      return []; // Retorna uma lista vazia se o usuário não estiver autenticado
    }
  }
}