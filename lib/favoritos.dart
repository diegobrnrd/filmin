import 'package:flutter/material.dart';
import 'filmes_grid.dart';
import 'filme.dart';

class FavoritosScreen extends StatelessWidget {
  const FavoritosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FilmeGrid(
      tituloAppBar: 'Favoritos',
      filmes: _mockFilmes(),
    );
  }

  List<FilmeWidget> _mockFilmes() {
    return List.generate(
        5, (index) => FilmeWidget(titulo: 'Filme ${index + 1}'));
  }
}
