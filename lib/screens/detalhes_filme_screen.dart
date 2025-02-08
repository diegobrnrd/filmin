import 'package:filmin/screens/escolher_lista.dart';
import 'package:filmin/services/lists_service.dart';
import 'package:flutter/material.dart';
import 'package:filmin/services/favorite_movie_service.dart';
import 'package:filmin/services/watchlist_service.dart';
import 'package:filmin/controlador/controlador.dart';
import 'package:filmin/screens/escrever_critica_screen.dart'; // Ajuste o caminho

class DetalhesFilmeScreen extends StatefulWidget {
  final int movieId;

  const DetalhesFilmeScreen({super.key, required this.movieId});

  @override
  DetalhesFilmeScreenState createState() => DetalhesFilmeScreenState();
}

class Filme {
  final String titulo;
  final List<String> diretores;
  final String duracao;
  final String ano;
  final String sinopse;
  final String posterPath;

  Filme({
    required this.titulo,
    required this.diretores,
    required this.duracao,
    required this.ano,
    required this.sinopse,
    required this.posterPath,
  });

  static Future<Filme> buscarDetalhesFilme(int movieId) async {
    final movieDetails = await Controlador().buscarDetalhesFilme(movieId);
    final crew = movieDetails['credits']['crew'] as List<dynamic>;
    final diretores = crew
        .where((member) => member['job'] == 'Director')
        .map((member) => member['name'] as String)
        .toList();
    return Filme(
      titulo: movieDetails['title'] ?? 'Título não disponível',
      diretores: diretores.isNotEmpty ? diretores : ['Diretor não informado'],
      duracao: movieDetails['runtime'] != null
          ? '${movieDetails['runtime']} min'
          : 'N/A',
      ano: movieDetails['release_date'] != null
          ? movieDetails['release_date'].split('-')[0]
          : 'N/A',
      sinopse: movieDetails['overview'] ?? 'Sinopse não disponível',
      posterPath: movieDetails['poster_path'] ?? '',
    );
  }
}

class DetalhesFilmeScreenState extends State<DetalhesFilmeScreen> {
  late Future<Filme> _filmeFuture;
  bool isWatched = false;
  bool isFavorite = false;
  bool isWatchLater = false;
  final FavoriteMovieService _favoriteMovieService = FavoriteMovieService();
  final WatchListService _watchListService = WatchListService();
  final ListsService _listsService = ListsService();

  @override
  void initState() {
    super.initState();
    _filmeFuture = Filme.buscarDetalhesFilme(widget.movieId);
    _checkIfFavorite();
    _checkIfInWatchlist();
  }

  void _checkIfFavorite() async {
    final user = _favoriteMovieService.getCurrentUser();
    if (user != null) {
      final favoriteMovies =
          await _favoriteMovieService.getFavoriteMoviesOnce();
      setState(() {
        isFavorite =
            favoriteMovies.any((movie) => movie['id'] == widget.movieId);
      });
    }
  }

  void _checkIfInWatchlist() async {
    final user = _watchListService.getCurrentUser();
    if (user != null) {
      final watchlist = await _watchListService.getWatchlist();
      setState(() {
        isWatchLater = watchlist.any((movie) => movie['id'] == widget.movieId);
      });
    }
  }

  void _toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
    });

    final user = _favoriteMovieService.getCurrentUser();
    if (user != null) {
      if (isFavorite) {
        final movieDetails =
            await Controlador().buscarDetalhesFilme(widget.movieId);
        await _favoriteMovieService.addFavoriteMovie(movieDetails);
      } else {
        final favoriteMovies =
            await _favoriteMovieService.getFavoriteMoviesOnce();
        final movieToDelete = favoriteMovies.firstWhere(
          (movie) => movie['id'] == widget.movieId,
          orElse: () => {},
        );

        if (movieToDelete.isNotEmpty) {
          await _favoriteMovieService
              .deleteFavoriteMovie(movieToDelete['documentId']);
        }
      }
    }
  }

  void _toggleWatchLater() async {
    setState(() {
      isWatchLater = !isWatchLater;
    });

    final user = _watchListService.getCurrentUser();
    if (user != null) {
      if (isWatchLater) {
        final movieDetails =
            await Controlador().buscarDetalhesFilme(widget.movieId);
        await _watchListService.addToWatchList(movieDetails);
      } else {
        final watchlist = await _watchListService.getWatchlist();
        final movieToDelete = watchlist.firstWhere(
          (movie) => movie['id'] == widget.movieId,
          orElse: () => {},
        );

        if (movieToDelete.isNotEmpty) {
          await _watchListService
              .deleteFromWatchlist(movieToDelete['documentId']);
        }
      }
    }
  }

  void _toggleWatched() {
    setState(() {
      isWatched = !isWatched;
    });
  }

  void navegarParaTelaCritica(Filme filme) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaEscreverCritica(
          movieTitle: filme.titulo,
          posterUrl: 'https://image.tmdb.org/t/p/w154${filme.posterPath}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF161E27),
        iconTheme: const IconThemeData(
          color: Color(0xFFAEBBC9),
        ),
      ),
      body: FutureBuilder<Filme>(
        future: _filmeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Erro ao carregar detalhes do filme.',
                style: TextStyle(color: Color(0xFFAEBBC9)),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'Nenhum detalhe disponível para este filme.',
                style: TextStyle(color: Color(0xFFAEBBC9)),
              ),
            );
          }

          final filme = snapshot.data!;
          return SingleChildScrollView(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (filme.posterPath.isNotEmpty)
                      Image.network(
                        'https://image.tmdb.org/t/p/w154${filme.posterPath}',
                        fit: BoxFit.cover,
                        width: screenWidth * 0.25,
                        height: screenHeight * 0.2,
                      )
                    else
                      Container(
                        width: screenWidth * 0.25,
                        height: screenHeight * 0.2,
                        color: const Color(0xFF1E2936),
                        child: const Icon(Icons.image_not_supported),
                      ),
                    SizedBox(width: screenWidth * 0.04),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            filme.titulo,
                            style: TextStyle(
                                color: const Color(0xFFAEBBC9),
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            'Dirigido por',
                            style: TextStyle(
                                color: const Color(0xFFAEBBC9),
                                fontSize: screenWidth * 0.035),
                          ),
                          Text(
                            filme.diretores.join(', '),
                            style: TextStyle(
                              color: const Color(0xFFAEBBC9),
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Row(
                            children: [
                              Text(
                                'Ano: ${filme.ano}',
                                style: TextStyle(
                                  color: const Color(0xFFAEBBC9),
                                  fontSize: screenWidth * 0.04,
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.08),
                              Text(
                                'Duração: ${filme.duracao}',
                                style: TextStyle(
                                  color: const Color(0xFFAEBBC9),
                                  fontSize: screenWidth * 0.04,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.01),
                  child: Text(
                    filme.sinopse,
                    style: TextStyle(
                      color: const Color(0xFFAEBBC9),
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Divider(
                  color: const Color(0xFF1E2936),
                  height: screenHeight * 0.001,
                  thickness: screenHeight * 0.002,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_red_eye,
                          color: isWatched
                              ? Colors.green
                              : const Color(0xFFAEBBC9)),
                      iconSize: screenWidth * 0.08,
                      onPressed: _toggleWatched,
                    ),
                    IconButton(
                      icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? Colors.red
                              : const Color(0xFFAEBBC9)),
                      iconSize: screenWidth * 0.08,
                      onPressed: _toggleFavorite,
                    ),
                    IconButton(
                      icon: Icon(Icons.watch_later,
                          color: isWatchLater
                              ? Colors.blue
                              : const Color(0xFFAEBBC9)),
                      iconSize: screenWidth * 0.08,
                      onPressed: _toggleWatchLater,
                    ),
                    IconButton(
                      icon: const Icon(Icons.rate_review,
                          color: Color(0xFFAEBBC9)),
                      iconSize: screenWidth * 0.08,
                      onPressed: () => navegarParaTelaCritica(filme),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share, color: Color(0xFFAEBBC9)),
                      iconSize: screenWidth * 0.08,
                      onPressed: () {
                        // Adicionar lógica para "compartilhar"
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.library_add,
                          color: Color(0xFFAEBBC9)),
                      iconSize: screenWidth * 0.08,
                      onPressed: () async{
                        final movieDetails = await Controlador().buscarDetalhesFilme(widget.movieId);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EscolherListaScreen(
                                   movie: movieDetails,
                                  )),
                        );
                      },
                    )
                  ],
                ),
                Divider(
                  color: const Color(0xFF1E2936),
                  height: screenHeight * 0.001,
                  thickness: screenHeight * 0.002,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
