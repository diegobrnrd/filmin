import 'package:flutter/material.dart';
import 'package:filmin/helpers/filme.dart';
import 'package:filmin/helpers/ordenador.dart';
import 'package:filmin/services/favorite_movie_service.dart';
import 'package:filmin/services/auth_service.dart';
import 'package:filmin/services/user_service.dart'; // Importe o UserService

class QuatroFilmeFav extends StatefulWidget {
  const QuatroFilmeFav({super.key});

  @override
  QuatroFilmeFavState createState() => QuatroFilmeFavState();
}

class QuatroFilmeFavState extends State<QuatroFilmeFav> {
  AuthService autoService = AuthService();
  FavoriteMovieService favoriteService = FavoriteMovieService();
  UserService userService = UserService(); // Instancie o UserService

  late List<FilmeWidget> _filmesOrdenados = [];
  String _tituloAppBar = 'Melhores 4';
  int _selectedIndex = 0;
  List<String> _melhores4FilmesIds = []; // Lista para armazenar os IDs dos melhores 4 filmes

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
  final String? user = await autoService.getCurrentUserId();
  if (user == null) {
    print('Erro: Usuário não autenticado.');
    return;
  }

  final favoriteMovies = await favoriteService.getFavoriteMoviesOnce();
  _melhores4FilmesIds = await userService.getMelhores4FilmesIds(user); // Passa o userId como argumento

  setState(() {
    if (_selectedIndex == 0) {
      _filmesOrdenados = favoriteMovies
          .where((movie) => _melhores4FilmesIds.contains(movie['id'].toString())) // Filtra os filmes pelos IDs dos melhores 4
          .map((movie) => FilmeWidget(
                posterPath: movie['poster_path'] ?? '',
                movieId: movie['id'],
                runtime: movie['runtime'],
                releaseDate: movie['release_date'],
                dateAdded: movie['dateAdded'],
                onTapAction: false, // Remove da lista de melhores 4
              ))
          .toList();
      _tituloAppBar = 'Clique para remover do Top 4';
    } else {
      _filmesOrdenados = favoriteMovies
          .map((movie) => FilmeWidget(
                posterPath: movie['poster_path'] ?? '',
                movieId: movie['id'],
                runtime: movie['runtime'],
                releaseDate: movie['release_date'],
                dateAdded: movie['dateAdded'],
                onTapAction: true, // Adiciona à lista de melhores 4
              ))
          .toList();
      _tituloAppBar = 'Clique para adicionar ao Top 4 (${favoriteMovies.length})';
    }
    _ordenarFilmes('dataLancamentoRecente');
  });
}


  void _ordenarFilmes(String criterio) {
    setState(() {
      final ordenador = Ordenador();
      final filmesMap = _filmesOrdenados
          .map((filme) => {
                'poster_path': filme.posterPath,
                'id': filme.movieId,
                'runtime': filme.runtime,
                'release_date': filme.releaseDate,
                'dateAdded': filme.dateAdded,
              })
          .toList();

      final filmesOrdenadosMap = ordenador.ordenar(filmesMap, criterio);
      _filmesOrdenados = filmesOrdenadosMap
          .map((filme) => FilmeWidget(
                posterPath: filme['poster_path'],
                movieId: filme['id'],
                runtime: filme['runtime'],
                releaseDate: filme['release_date'],
                dateAdded: filme['dateAdded'],
                onTapAction: _selectedIndex == 0 ? false : true,
              ))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tituloAppBar,
          style: TextStyle(
              color: const Color(0xFFAEBBC9), fontSize: screenHeight * 0.025),
        ),
        backgroundColor: const Color(0xFF161E27),
        iconTheme: const IconThemeData(
          color: Color(0xFFAEBBC9),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.sort, color: const Color(0xFFAEBBC9)),
            onSelected: _ordenarFilmes,
            color: const Color(0xFF1E2936),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'dataAdicaoAntiga',
                  child: Text('Data de Adição - Antigos',
                      style: TextStyle(color: Color(0xFF788EA5))),
                ),
                const PopupMenuItem<String>(
                  value: 'dataAdicaoRecente',
                  child: Text('Data de Adição - Recentes',
                      style: TextStyle(color: Color(0xFF788EA5))),
                ),
                const PopupMenuItem<String>(
                  value: 'dataLancamentoAntiga',
                  child: Text('Data de Lançamento - Antigos',
                      style: TextStyle(color: Color(0xFF788EA5))),
                ),
                const PopupMenuItem<String>(
                  value: 'dataLancamentoRecente',
                  child: Text('Data de Lançamento - Recentes',
                      style: TextStyle(color: Color(0xFF788EA5))),
                ),
                const PopupMenuItem<String>(
                  value: 'duracaoMenor',
                  child: Text('Duração - Curtos',
                      style: TextStyle(color: Color(0xFF788EA5))),
                ),
                const PopupMenuItem<String>(
                  value: 'duracaoMaior',
                  child: Text('Duração - Longos',
                      style: TextStyle(color: Color(0xFF788EA5))),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                    _fetchMovies();
                  });
                },
                child: Text('Top 4',
                    style: TextStyle(
                        color: _selectedIndex == 0
                            ? const Color(0xFF208BFE)
                            : const Color(0xFFAEBBC9))),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1;
                    _fetchMovies();
                  });
                },
                child: Text('Favoritos',
                    style: TextStyle(
                        color: _selectedIndex == 1
                            ? const Color(0xFF208BFE)
                            : const Color(0xFFAEBBC9))),
              )
            ],
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.7,
                crossAxisSpacing: screenWidth * 0.01,
                mainAxisSpacing: screenHeight * 0.01,
              ),
              itemCount: _filmesOrdenados.length,
              itemBuilder: (context, index) {
                return _filmesOrdenados[index];
              },
            ),
          ),
        ],
      ),
    );
  }
}