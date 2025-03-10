import 'package:filmin/services/review_service.dart';
import 'package:flutter/material.dart';
import 'package:filmin/helpers/filme.dart';
import 'package:filmin/helpers/filmes_grid.dart';
import 'package:filmin/helpers/filmes_row.dart'; // Importe FilmeRow
import 'package:filmin/screens/criticas_usuario_screen.dart';
import 'package:filmin/services/watched_service.dart';
import 'package:filmin/services/favorite_movie_service.dart';
import 'package:filmin/services/watchlist_service.dart';
import 'package:filmin/services/auth_service.dart';
import 'package:filmin/services/user_service.dart';
import 'package:filmin/services/lists_service.dart';
import 'package:filmin/screens/listas_screen.dart';

class PerfilScreen extends StatefulWidget {
  final String? anotherUserName;

  const PerfilScreen({super.key, this.anotherUserName});

  @override
  PerfilState createState() => PerfilState();
}

class PerfilState extends State<PerfilScreen> {
  AuthService autoService = AuthService();
  FavoriteMovieService favoriteService = FavoriteMovieService();
  WatchedService watchedService = WatchedService();
  WatchListService watchlistService = WatchListService();
  UserService userService = UserService();
  ListsService listsService = ListsService();
  ReviewService reviewService = ReviewService();

  String? _nome;
  String? _sobrenome;
  String? _profilePictureUrl;
  String? _anotherUserId;
  late List<Map<String, dynamic>> _favoriteMovies;
  late List<Map<String, dynamic>> _watched;
  late List<Map<String, dynamic>> _watchlist;
  late List<Map<String, dynamic>> _userLists;
  late int _userReviewsLength;
  late List<String> _melhores4FilmesIds;
  late List<FilmeWidget> _melhores4FilmeWidgets;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchUserData() async {
  String? currentUserId = await autoService.getCurrentUserId();

  _nome = await autoService.getUserName();
  _sobrenome = await autoService.getUserSurname();
  _profilePictureUrl = await autoService.getProfilePictureUrl();
  _favoriteMovies = await favoriteService.getFavoriteMoviesOnce();
  print("=================================================");
  print('Filmes favoritos do usuário atual(visão usuário): $_favoriteMovies');
  _watched = await watchedService.getWatched();
  _watchlist = await watchlistService.getWatchlist();
  _userLists = await listsService.getUserLists();
  _userReviewsLength = await reviewService.getUserReviewsCount();

  // Agora passa o ID correto para buscar os melhores 4 filmes
  await _fetchMelhores4Filmes(currentUserId);
}

Future<void> _fetchAnotherUserData(String username) async {
  Map<String, dynamic>? anotherUserData =
      await userService.getUserDataByUsername(username);

  if (anotherUserData == null) {
    print('Erro: Usuário $username não encontrado.');
    return;
  }

  _anotherUserId = anotherUserData['uid'];
  _nome = anotherUserData['nome'];
  _sobrenome = anotherUserData['sobrenome'];
  _profilePictureUrl = anotherUserData['profilePictureUrl'];

  _favoriteMovies = await userService.getAnotherUserFavoriteMovies(username);
  print("======================================================");
  print('Filmes favoritos do usuário acessado: $_favoriteMovies');
  _watched = await userService.getAnotherUserWatched(username);
  _watchlist = await userService.getAnotherUserWatchlist(username);
  _userLists = await userService.getAnotherUserLists(username);

  // Passa o ID do usuário do perfil acessado
  await _fetchMelhores4Filmes(_anotherUserId!);
}

Future<void> _fetchMelhores4Filmes(String? userId) async {
  print('Buscando melhores 4 filmes para o usuário: $userId');

  // Agora passamos o ID correto para pegar os melhores filmes do usuário acessado
  _melhores4FilmesIds = await userService.getMelhores4FilmesIds(userId);

  print('IDs dos melhores 4 filmes: $_melhores4FilmesIds');
  print('Filmes favoritos do usuário acessado: $_favoriteMovies');

  if (_melhores4FilmesIds.isEmpty) {
    print('Nenhum ID de melhores 4 filmes encontrado.');
    _melhores4FilmeWidgets = [];
    return;
  }

  _melhores4FilmeWidgets = _favoriteMovies
      .where((movie) => _melhores4FilmesIds.contains(movie['id'].toString()))
      .map((movie) => FilmeWidget(
            posterPath: movie['poster_path'] ?? '',
            movieId: movie['id'],
            runtime: movie['runtime'],
            releaseDate: movie['release_date'],
            dateAdded: movie['dateAdded'],
          ))
      .toList();

  print('Melhores 4 FilmeWidgets carregados: ${_melhores4FilmeWidgets.isNotEmpty}'); // Atualiza a UI
}


  Future<void> _getReviewsLength(String uId) async {
    _userReviewsLength = await userService.getAnotherUserReviewsCount(uId);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: widget.anotherUserName != null
          ? _fetchAnotherUserData(widget.anotherUserName!).then((_) => _getReviewsLength(_anotherUserId!))
          : _fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: const Color(0xFF161E27),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color(0xFF161E27),
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
                SizedBox(height: screenHeight * 0.03),
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
                if (_melhores4FilmeWidgets.isNotEmpty)
                  SizedBox(
                    height: screenHeight * 0.30,
                    child: FilmeRow( // Use FilmeRow aqui
                      filmes: _melhores4FilmeWidgets,
                    ),
                  ),
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
                        _criarBotao(
                            context,
                            'Filmes',
                            'Filmes',
                            _watched.length,
                            screenHeight,
                            widget.anotherUserName),
                        SizedBox(height: screenHeight * 0.01),
                        _criarBotao(
                            context,
                            'Críticas',
                            'Crítica',
                            _userReviewsLength,
                            screenHeight,
                            widget.anotherUserName),
                        SizedBox(height: screenHeight * 0.01),
                        _criarBotao(
                            context,
                            'Quero Assistir',
                            'Quero Assistir',
                            _watchlist.length,
                            screenHeight,
                            widget.anotherUserName),
                        SizedBox(height: screenHeight * 0.01),
                        _criarBotao(
                            context,
                            'Favoritos',
                            'Favoritos',
                            _favoriteMovies.length,
                            screenHeight,
                            widget.anotherUserName),
                        SizedBox(height: screenHeight * 0.01),
                        _criarBotao(
                            context,
                            'Listas',
                            'Listas',
                            _userLists.length,
                            screenHeight,
                            widget.anotherUserName),
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

  Widget _criarBotao(
      BuildContext context,
      String tituloBotao,
      String tituloAppBar,
      int quantidade,
      double screenHeight,
      String? userName) {
    return TextButton(
      onPressed: () async {
        if (tituloBotao == 'Críticas') {
          if (userName == null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CriticasUsuarioScreen(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CriticasUsuarioScreen(anotherUserId: _anotherUserId),
              ),
            );
          }
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
        } else if (tituloBotao == 'Listas') {
          if (userName == null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ListasScreen(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListasScreen(anotherUserName: userName),
              ),
            );
          }
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