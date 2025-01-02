import 'package:flutter/material.dart';
import 'package:filmin/helpers/filme.dart';
import 'package:filmin/helpers/filmes_grid.dart';
import 'package:filmin/screens/criticas_screen.dart';
import 'package:filmin/services/favorite_movie_service.dart';

class Perfil extends StatelessWidget {
  const Perfil({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Perfil',
          style: TextStyle(
              color: const Color(0xFFAEBBC9), fontSize: screenHeight * 0.025),
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
            backgroundImage: const NetworkImage('URL_DA_FOTO_DO_USUARIO'),
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
                  _criarBotao(context, 'Filmes', 'Filmes', 0, screenHeight),
                  SizedBox(height: screenHeight * 0.01),
                  _criarBotao(context, 'Críticas', 'Crítica', 0, screenHeight),
                  SizedBox(height: screenHeight * 0.01),
                  _criarBotao(context, 'Quero Assistir', 'Quero Assistir', 0,
                      screenHeight),
                  SizedBox(height: screenHeight * 0.01),
                  _criarBotao(
                      context, 'Favoritos', 'Favoritos', 0, screenHeight),
                  SizedBox(height: screenHeight * 0.01),
                ],
              ),
            ),
          ),
        ],
      ),
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
          final favoriteMovies =
              await FavoriteMovieService().getFavoriteMoviesOnce();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilmeGrid(
                tituloAppBar: tituloAppBar,
                filmes: favoriteMovies
                    .map((movie) => FilmeWidget(
                          posterPath: movie['poster_path'] ?? '',
                        ))
                    .toList(),
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilmeGrid(
                tituloAppBar: tituloAppBar,
                filmes: _mockFilmes(),
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

  List<FilmeWidget> _mockFilmes() {
    return List.generate(
      0,
      (index) => FilmeWidget(
        posterPath: '/path/to/poster${index + 1}.jpg',
      ),
    );
  }
}
