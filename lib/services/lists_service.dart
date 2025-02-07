import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> createList(String nomeLista, String descricao) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('lists')
          .add({'name': nomeLista, 'description': descricao});
    }
  }

  Future<void> addToList(Map<String, dynamic> movie, String nomeLista) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final listaQuery = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('lists')
          .where('name', isEqualTo: nomeLista)
          .get();

      if (listaQuery.docs.isNotEmpty) {
        final listaRef = listaQuery.docs.first.reference.collection('movies');

        await listaRef.add({
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
      }
    }
    }

    Future<void> deleteList(String documentId) async {
      final User? user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('lists')
            .doc(documentId)
            .delete();
      }
    }

    Future<void> deleteFromList(String movieId, String nomeLista) async {
      final User? user = _auth.currentUser;
      if (user != null) {
        final listaQuery = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('lists')
            .where('name', isEqualTo: nomeLista)
            .get();

        if (listaQuery.docs.isNotEmpty) {
          final listaRef = listaQuery.docs.first.reference.collection('movies');

          listaRef.doc(movieId).delete();
        }
      }
    }

    Future<List<Map<String, dynamic>>> getList(String nomeLista) async {
      final User? user = _auth.currentUser;
      if (user != null) {
        final listaQuery = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('lists')
            .where('name', isEqualTo: nomeLista)
            .get();

        final listaRef =
            await listaQuery.docs.first.reference.collection('movies').get();

        return listaRef.docs
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

    Future<void> updateList(
        String nomeAtual, String novoNome, String novaDescricao) async {
      final User? user = _auth.currentUser;
      if (user != null) {
        final listaQuery = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('lists')
            .where('name', isEqualTo: nomeAtual)
            .get();

        final listaRef = listaQuery.docs.first.reference;

        listaRef.update({
          'name': novoNome,
          'descricao': novaDescricao,
        });
      }
    }

    Future<List<Map<String, dynamic>>> getUserLists() async {
      final User? user = _auth.currentUser;
      if (user != null) {
        final snapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('lists')
            .get();


        return snapshot.docs.map((doc) {
          return {
            'documentId': doc.id, // ID único da lista
            'name': doc['name'], // Nome da lista
            'description': doc['description'], // Descrição da lista
          };
        }).toList();
      } else {
        return []; // Retorna uma lista vazia se o usuário não estiver autenticado
      }
    }
  }

