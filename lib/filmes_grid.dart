import 'package:flutter/material.dart';
import 'filme.dart';

class FilmeGrid extends StatelessWidget {
  final List<FilmeWidget> filmes;
  final String tituloAppBar;

  const FilmeGrid({
    super.key, 
    required this.filmes, 
    required this.tituloAppBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tituloAppBar),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: filmes.length,
        itemBuilder: (context, index) {
          return filmes[index];
        },
      ),
    );
  }
}