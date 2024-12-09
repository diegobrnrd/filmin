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
        title: Text(
          tituloAppBar,
          style: const TextStyle(color: Color(0xFFAEBBC9)),
        ),
        backgroundColor: const Color(0xFF161E27),
        iconTheme: const IconThemeData(
          color: Color(0xFFAEBBC9),
        ),
      ),
      body: Expanded(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.7,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemCount: filmes.length,
          itemBuilder: (context, index) {
            return filmes[index];
          },
        ),
      ),
    );
  }
}