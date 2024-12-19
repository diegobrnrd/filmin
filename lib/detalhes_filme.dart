import 'package:flutter/material.dart';
import 'package:filmin/controlador/favorite_movie_service.dart';

class DetalhesFilmeScreen extends StatefulWidget {
  final Map<String, dynamic> movieDetails;

  const DetalhesFilmeScreen({super.key, required this.movieDetails});

  @override
  DetalhesFilmeScreenState createState() => DetalhesFilmeScreenState();
}

class DetalhesFilmeScreenState extends State<DetalhesFilmeScreen> {
  bool isFavorite = false;
  bool isWatched = false;
  bool isWatchLater = false;
  final FavoriteMovieService _favoriteMovieService = FavoriteMovieService();

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  void _checkIfFavorite() async {
    final user = _favoriteMovieService.getCurrentUser();
    if (user != null) {
      final favoriteMovies =
          await _favoriteMovieService.getFavoriteMoviesOnce();
      setState(() {
        isFavorite = favoriteMovies
            .any((movie) => movie['id'] == widget.movieDetails['id']);
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
        await _favoriteMovieService.addFavoriteMovie(widget.movieDetails);
      } else {
        final favoriteMovies =
            await _favoriteMovieService.getFavoriteMoviesOnce();
        final movieToDelete = favoriteMovies.firstWhere(
          (movie) => movie['id'] == widget.movieDetails['id'],
          orElse: () => {},
        );

        if (movieToDelete.isNotEmpty) {
          await _favoriteMovieService
              .deleteFavoriteMovie(movieToDelete['documentId']);
        }
      }
    }
  }

  void _toggleWatched() {
    setState(() {
      isWatched = !isWatched;
    });
  }

  void _toggleWatchLater() {
    setState(() {
      isWatchLater = !isWatchLater;
    });
  }

  @override
  Widget build(BuildContext context) {
    final posterPath = widget.movieDetails['poster_path'];
    final crew = widget.movieDetails['credits']['crew'] as List<dynamic>;
    final director = crew.firstWhere((member) => member['job'] == 'Director',
        orElse: () => {'name': 'N/A'})['name'];
    final releaseDate = widget.movieDetails['release_date'] != null
        ? widget.movieDetails['release_date'].split('-')[0]
        : 'N/A';
    final duration = widget.movieDetails['runtime'] != null
        ? '${widget.movieDetails['runtime']} min'
        : 'N/A';
    final synopsis =
        widget.movieDetails['overview'] ?? 'Sinopse não disponível';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF161E27),
        iconTheme: const IconThemeData(
          color: Color(0xFFAEBBC9),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (posterPath != null && posterPath.isNotEmpty)
                  Image.network(
                    'https://image.tmdb.org/t/p/w154$posterPath',
                    fit: BoxFit.cover,
                    width: 100,
                    height: 150,
                  )
                else
                  const Icon(Icons.movie, color: Color(0xFFAEBBC9), size: 100),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.movieDetails['title'],
                        style: const TextStyle(
                            color: Color(0xFFAEBBC9),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      const Text(
                        'Dirigido por',
                        style:
                            TextStyle(color: Color(0xFFAEBBC9), fontSize: 16),
                      ),
                      Text(
                        director,
                        style: const TextStyle(
                            color: Color(0xFFAEBBC9), fontSize: 16),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Text(
                            'Ano: $releaseDate',
                            style: const TextStyle(
                                color: Color(0xFFAEBBC9), fontSize: 16),
                          ),
                          const SizedBox(width: 16.0),
                          Text(
                            'Duração: $duration',
                            style: const TextStyle(
                                color: Color(0xFFAEBBC9), fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                synopsis,
                style: const TextStyle(color: Color(0xFFAEBBC9), fontSize: 16),
              ),
            ),
            const Divider(color: Color(0xFF1E2936), height: 1, thickness: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.remove_red_eye,
                      color:
                          isWatched ? Colors.green : const Color(0xFFAEBBC9)),
                  iconSize: 30,
                  onPressed: _toggleWatched,
                ),
                IconButton(
                  icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : const Color(0xFFAEBBC9)),
                  iconSize: 30,
                  onPressed: _toggleFavorite,
                ),
                IconButton(
                  icon: Icon(Icons.watch_later,
                      color:
                          isWatchLater ? Colors.blue : const Color(0xFFAEBBC9)),
                  iconSize: 30,
                  onPressed: _toggleWatchLater,
                ),
                IconButton(
                  icon: const Icon(Icons.rate_review, color: Color(0xFFAEBBC9)),
                  iconSize: 30,
                  onPressed: () {
                    // Adicionar lógica para "crítica"
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: Color(0xFFAEBBC9)),
                  iconSize: 30,
                  onPressed: () {
                    // Adicionar lógica para "compartilhar"
                  },
                ),
              ],
            ),
            const Divider(color: Color(0xFF1E2936), height: 1, thickness: 2),
          ],
        ),
      ),
    );
  }
}
