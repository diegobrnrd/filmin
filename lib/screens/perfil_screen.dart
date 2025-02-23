import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:filmin/helpers/filme.dart';
import 'package:filmin/helpers/filmes_grid.dart';
import 'package:filmin/screens/criticas_screen.dart';
import 'package:filmin/services/watched_service.dart';
import 'package:filmin/services/favorite_movie_service.dart';
import 'package:filmin/services/watchlist_service.dart';
import 'package:filmin/services/auth_service.dart';
import 'package:filmin/services/user_service.dart';

class Perfil extends StatefulWidget {
  final String? anotherUserId;

  const Perfil({super.key, this.anotherUserId});

  @override
  PerfilState createState() => PerfilState();
}

class PerfilState extends State<Perfil> {
  AuthService autoService = AuthService();
  FavoriteMovieService favoriteService = FavoriteMovieService();
  WatchedService watchedService = WatchedService();
  WatchListService watchlistService = WatchListService();
  UserService userService = UserService();

  String? _nome;
  String? _sobrenome;
  String? _profilePictureUrl;
  late List<Map<String, dynamic>> _favoriteMovies;
  late List<Map<String, dynamic>> _watched;
  late List<Map<String, dynamic>> _watchlist;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchUserData() async {
    _nome = await autoService.getUserName();
    _sobrenome = await autoService.getUserSurname();
    _profilePictureUrl = await autoService.getProfilePictureUrl();
    _favoriteMovies = await favoriteService.getFavoriteMoviesOnce();
    _watched = await watchedService.getWatched();
    _watchlist = await watchlistService.getWatchlist();
  }

  Future<void> _fetchAnotherUserData(String id) async {
    DocumentSnapshot? userDoc = await userService.getUserDocById(id);

    if (userDoc != null) {
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

      setState(() {
        _nome = userData?['nome'];
        _sobrenome = userData?['sobrenome'];
        _profilePictureUrl = userData?['profile_picture'];
      });

      QuerySnapshot favoriteMoviesSnapshot =
          await userDoc.reference.collection('favorite_movies').get();
      QuerySnapshot watchedSnapshot =
          await userDoc.reference.collection('watched').get();
      QuerySnapshot watchlistSnapshot =
          await userDoc.reference.collection('watchlist').get();

      setState(() {
        _favoriteMovies = favoriteMoviesSnapshot.docs
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

        _watched = watchedSnapshot.docs
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

        _watchlist = watchlistSnapshot.docs
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: widget.anotherUserId != null 
      ? _fetchAnotherUserData(widget.anotherUserId!) 
      : _fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: const Color(0xFF161E27), // Fundo escuro
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color(0xFF161E27), // Fundo escuro
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                '$_nome $_sobrenome',
                style: TextStyle(
                    color: const Color(0xFFAEBBC9),
                    fontSize: screenHeight * 0.025),
              ),
              backgroundColor: const Color(0xFF161E27),
              iconTheme: const IconThemeData(
                color: Color(0xFFAEBBC9),
              ),
            ),
            body: Column(
              children: [
                Divider(
                  color: const Color(0xFF1E2936),
                  height: screenHeight * 0.001,
                  thickness: screenHeight * 0.002,
                ),
                SizedBox(height: screenHeight * 0.05),
                CircleAvatar(
                  radius: screenWidth * 0.13,
                  backgroundImage: _profilePictureUrl != null &&
                          _profilePictureUrl!.isNotEmpty
                      ? NetworkImage(_profilePictureUrl!)
                      : const AssetImage('assets/default_avatar.png'),
                ),
                SizedBox(height: screenHeight * 0.05),
                Divider(
                  color: const Color(0xFF1E2936),
                  height: screenHeight * 0.001,
                  thickness: screenHeight * 0.002,
                ),
                SizedBox(height: screenHeight * 0.02),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _criarBotao(context, 'Filmes', 'Filmes',
                            _watched.length, screenHeight),
                        SizedBox(height: screenHeight * 0.01),
                        _criarBotao(
                            context, 'Críticas', 'Crítica', 0, screenHeight),
                        SizedBox(height: screenHeight * 0.01),
                        _criarBotao(context, 'Quero Assistir', 'Quero Assistir',
                            _watchlist.length, screenHeight),
                        SizedBox(height: screenHeight * 0.01),
                        _criarBotao(context, 'Favoritos', 'Favoritos',
                            _favoriteMovies.length, screenHeight),
                        SizedBox(height: screenHeight * 0.01),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _criarBotao(BuildContext context, String tituloBotao,
      String tituloAppBar, int quantidade, double screenHeight) {
    return TextButton(
      onPressed: () async {
        if (tituloBotao == 'Críticas') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CriticasScreen(),
            ),
          );
        } else if (tituloBotao == 'Favoritos') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilmeGrid(
                tituloAppBar: tituloAppBar,
                filmes: _favoriteMovies
                    .map((movie) => FilmeWidget(
                          posterPath: movie['poster_path'] ?? '',
                          movieId: movie['id'],
                          runtime: movie['runtime'],
                          releaseDate: movie['release_date'],
                          dateAdded: movie['dateAdded'],
                        ))
                    .toList(),
              ),
            ),
          );
        } else if (tituloBotao == 'Quero Assistir') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilmeGrid(
                tituloAppBar: tituloAppBar,
                filmes: _watchlist
                    .map((movie) => FilmeWidget(
                          posterPath: movie['poster_path'] ?? '',
                          movieId: movie['id'],
                          runtime: movie['runtime'],
                          releaseDate: movie['release_date'],
                          dateAdded: movie['dateAdded'],
                        ))
                    .toList(),
              ),
            ),
          );
        } else if (tituloBotao == 'Filmes') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilmeGrid(
                tituloAppBar: tituloAppBar,
                filmes: _watched
                    .map((movie) => FilmeWidget(
                          posterPath: movie['poster_path'] ?? '',
                          movieId: movie['id'],
                          runtime: movie['runtime'],
                          releaseDate: movie['release_date'],
                          dateAdded: movie['dateAdded'],
                        ))
                    .toList(),
              ),
            ),
          );
        }
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.01, horizontal: screenHeight * 0.02),
        backgroundColor: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            tituloBotao,
            style: TextStyle(
                color: const Color(0xFFAEBBC9), fontSize: screenHeight * 0.02),
          ),
          Text(
            quantidade.toString(),
            style: TextStyle(
                color: const Color(0xFFAEBBC9), fontSize: screenHeight * 0.02),
          ),
        ],
      ),
    );
  }
}
