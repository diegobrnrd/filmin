import 'package:flutter/material.dart';
import 'filmes_grid.dart';
import 'filme.dart';

class QueroAssistirScreen extends StatelessWidget {
  const QueroAssistirScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FilmeGrid(
      tituloAppBar: 'Quero Assistir',
      filmes: _mockFilmes(), 
    );
  }

  List<FilmeWidget> _mockFilmes() {
    return List.generate(10, (index) => FilmeWidget(titulo: 'Filme ${index + 1}'));
  }
}