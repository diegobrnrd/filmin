import 'package:flutter/material.dart';
import 'package:filmin/services/lists_service.dart';

class DeletarFilmesListaScreen extends StatefulWidget {
  final String nomeLista;
  final String descricaoLista;

  const DeletarFilmesListaScreen(
      {super.key, required this.nomeLista, required this.descricaoLista});

  @override
  _DeletarFilmesListaScreenState createState() =>
      _DeletarFilmesListaScreenState();
}

class _DeletarFilmesListaScreenState extends State<DeletarFilmesListaScreen> {
  final ListsService _listsService = ListsService();
  List<Map<String, dynamic>> _movies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    try {
      final movies = await _listsService.getList(widget.nomeLista) ?? [];
      setState(() {
        _movies = List<Map<String, dynamic>>.from(movies);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar filmes: $e')),
      );
    }
  }

  Future<void> _deleteMovie(String movieId, int index) async {
    final deletedMovie = _movies[index];
    setState(() {
      _movies.removeAt(index);
    });

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: const Text('Filme removido!',
            style: TextStyle(color: Color(0xFFF1F3F5))),
        backgroundColor: Color(0xFF208BFE),
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Color(0xFFF1F3F5),
          onPressed: () {
            setState(() {
              _movies.insert(index, deletedMovie);
            });
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );

    await Future.delayed(const Duration(seconds: 5));

    if (!_movies.contains(deletedMovie)) {
      try {
        await _listsService.deleteFromList(movieId, widget.nomeLista);
      } catch (e) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Erro ao remover filme: $e')),
        );
        setState(() {
          _movies.insert(index, deletedMovie);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Remoção da lista',
          style: TextStyle(
              color: const Color(0xFFAEBBC9), fontSize: screenHeight * 0.025),
        ),
        backgroundColor: const Color(0xFF161E27),
        iconTheme: const IconThemeData(
          color: Color(0xFFAEBBC9),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _movies.length,
              itemBuilder: (context, index) {
                final movie = _movies[index];
                final posterPath = movie['poster_path'];
                return Dismissible(
                  key: Key(movie['documentId'].toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) =>
                      _deleteMovie(movie['documentId'].toString(), index),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    margin:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.005),
                    child: Row(
                      children: [
                        if (posterPath != null && posterPath.isNotEmpty)
                          Image.network(
                            'https://image.tmdb.org/t/p/w154$posterPath',
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
                                movie['title'],
                                style: TextStyle(
                                  color: const Color(0xFFAEBBC9),
                                  fontSize: screenHeight * 0.02,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                '${movie['release_date'] != null ? movie['release_date'].split('-')[0] : 'N/A'}',
                                style: TextStyle(
                                  color: const Color(0xFFAEBBC9),
                                  fontSize: screenHeight * 0.02,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
