import 'package:flutter/material.dart';
import 'package:filmin/helpers/filme.dart';

class FilmeRow extends StatelessWidget {
  final List<FilmeWidget> filmes;

  const FilmeRow({super.key, required this.filmes});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: filmes,
      ),
    );
  }
}