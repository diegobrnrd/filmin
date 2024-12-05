import 'package:flutter/material.dart';
import 'filmes_grid.dart'; 
import 'filme.dart';
import 'perfil.dart'; // Importe a classe Perfil

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bem-vindo ao FilmIn'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Quero Assistir'),
              onTap: () {
                // Navegar para a página "Quero Assistir"
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilmeGrid(
                      tituloAppBar: 'Quero Assistir', 
                      filmes: _mockFilmes(), 
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Perfil'), // Nova opção Perfil
              onTap: () {
                // Navegar para a página "Perfil"
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Perfil()),
                );
              },
            ),
            // Adicione outras opções do menu aqui
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10, 
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilmeWidget(
                    titulo: 'Filme ${index + 1}',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<FilmeWidget> _mockFilmes() {
    return List.generate(10, (index) =>  FilmeWidget(titulo: 'Filme ${index + 1}'));
  }
}