// perfil.dart
import 'package:flutter/material.dart';
import 'filmes_grid.dart';
import 'filme.dart';

class Perfil extends StatelessWidget {
  const Perfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _criarBotao(context, 'Filmes', 'Filmes'),
            const SizedBox(height: 20),
            _criarBotao(context, 'Favoritos', 'Favoritos'),
            const SizedBox(height: 20),
            _criarBotao(context, 'Quero Assistir', 'Quero Assistir'),
          ],
        ),
      ),
    );
  }

  Widget _criarBotao(
      BuildContext context, String tituloBotao, String tituloAppBar) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FilmeGrid(
              tituloAppBar: tituloAppBar,
              filmes: _mockFilmes(),
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
      child: Text(tituloBotao),
    );
  }

  List<FilmeWidget> _mockFilmes() {
    return List.generate(
        40, (index) => FilmeWidget(titulo: 'Filme ${index + 1}'));
  }
}
