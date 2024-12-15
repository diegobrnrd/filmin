import 'package:flutter/material.dart';
import 'filmes_grid.dart';
import 'filme.dart';
import 'criticas.dart';

class Perfil extends StatelessWidget {
  const Perfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil',
          style: TextStyle(color: Color(0xFFAEBBC9)),
        ),
        backgroundColor: const Color(0xFF161E27),
        iconTheme: const IconThemeData(
          color: Color(0xFFAEBBC9),
        ),
      ),
      body: Column(
        children: [
          const Divider(
            color: Color(0xFF1E2936),
            height: 1,
            thickness: 2,
          ),
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage('URL_DA_FOTO_DO_USUARIO'),
          ),
          const SizedBox(height: 20),
          const Divider(
            color: Color(0xFF1E2936),
            height: 1,
            thickness: 2,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _criarBotao(context, 'Filmes', 'Filmes', 0),
                  const SizedBox(height: 20),
                  _criarBotao(context, 'Críticas', 'Crítica', 0),
                  const SizedBox(height: 20),
                  _criarBotao(context, 'Quero Assistir', 'Quero Assistir', 0),
                  const SizedBox(height: 20),
                  _criarBotao(context, 'Favoritos', 'Favoritos', 0),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _criarBotao(BuildContext context, String tituloBotao, String tituloAppBar, int quantidade) {
    return TextButton(
      onPressed: () {
        if (tituloBotao == 'Crítica') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CriticasScreen(),
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
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        backgroundColor: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            tituloBotao,
            style: const TextStyle(color: Color(0xFFAEBBC9), fontSize: 16),
          ),
          Text(
            quantidade.toString(),
            style: const TextStyle(color: Color(0xFFAEBBC9), fontSize: 16),
          ),
        ],
      ),
    );
  }

  List<FilmeWidget> _mockFilmes() {
    return List.generate(
        40, (index) => FilmeWidget(titulo: 'Filme ${index + 1}'));
  }
}