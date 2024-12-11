import 'package:filmin/detalhes_filme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:filmin/controlador/controlador.dart';

class BuscaScreen extends StatefulWidget {
  const BuscaScreen({super.key});

  @override
  BuscaScreenState createState() => BuscaScreenState();
}

class BuscaScreenState extends State<BuscaScreen> {
  int _selectedIndex = 0;
  List<dynamic> _searchResults = [];
  final TextEditingController _controller = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _searchResults.clear();
      _controller.clear();
    });
  }

  void _buscarFilmes(String query) async {
    try {
      final results = await Controlador().buscarFilmes(query);
      final filteredResults = results.where((movie) => movie['original_language'] == 'pt').toList();
      setState(() {
        _searchResults = filteredResults;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  void _buscarPerfil() {
    // Implement profile search logic
  }

  void _navegarParaDetalhesFilme(int movieId) async {
    try {
      final movieDetails = await Controlador().buscarDetalhesFilme(movieId);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetalhesFilmeScreen(movieDetails: movieDetails),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF161E27),
        iconTheme: const IconThemeData(
          color: Color(0xFFAEBBC9),
        ),
        title: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Buscar...',
            hintStyle: TextStyle(color: Color(0xFFAEBBC9)),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Color(0xFFAEBBC9)),
          onSubmitted: (query) {
            if (_selectedIndex == 0) {
              _buscarFilmes(query);
            } else if (_selectedIndex == 1) {
              _buscarPerfil();
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear, color: Color(0xFFAEBBC9)),
            onPressed: () {
              _controller.clear();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF161E27),
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () => _onItemTapped(0),
                  style: TextButton.styleFrom(
                    foregroundColor: _selectedIndex == 0 ? const Color(0xFF208BFE) : const Color(0xFFAEBBC9),
                  ),
                  child: const Text("Filme"),
                ),
                TextButton(
                  onPressed: () => _onItemTapped(1),
                  style: TextButton.styleFrom(
                    foregroundColor: _selectedIndex == 1 ? const Color(0xFF208BFE) : const Color(0xFFAEBBC9),
                  ),
                  child: const Text('Perfil'),
                ),
              ],
            ),
          ),
          const Divider(
            color: Color(0xFF1E2936),
            height: 1,
            thickness: 2,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final movie = _searchResults[index];
                final posterPath = movie['poster_path'];
                return ListTile(
                  leading: GestureDetector(
                    onTap: () => _navegarParaDetalhesFilme(movie['id']),
                    child: posterPath != null && posterPath.isNotEmpty
                        ? Image.network(
                      'https://image.tmdb.org/t/p/w154$posterPath', // Increased size
                      fit: BoxFit.cover,
                    )
                        : const Icon(Icons.movie, color: Color(0xFFAEBBC9)), // Placeholder icon
                  ),
                  title: Text(movie['title'], style: const TextStyle(color: Color(0xFFAEBBC9))),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ano: ${movie['release_date'] != null ? movie['release_date'].split('-')[0] : 'N/A'}', style: const TextStyle(color: Color(0xFFAEBBC9))),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}