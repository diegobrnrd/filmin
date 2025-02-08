import 'package:filmin/helpers/filme.dart';
import 'package:filmin/helpers/filmes_grid.dart';
import 'package:filmin/screens/criar_lista_screen.dart';
import 'package:flutter/material.dart';
import 'package:filmin/services/lists_service.dart';

class ListasScreen extends StatefulWidget {
  const ListasScreen({super.key});

  @override
  _ListasScreenState createState() => _ListasScreenState();
}

class _ListasScreenState extends State<ListasScreen> {
  final ListsService _listsService = ListsService();
  List<Map<String, dynamic>> userLists = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserLists();
  }

  void loadUserLists() async {
    userLists = await _listsService.getUserLists();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Listas',
          style: TextStyle(color: Color(0xFFAEBBC9)),
        ),
        backgroundColor: const Color(0xFF161E27),
        centerTitle: true,
        leading: IconButton(
          color: const Color(0xFFAEBBC9),
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Retorna à tela anterior
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userLists.isEmpty
              ? const Center(child: Text("Você não possui listas."))
              : ListView.builder(
                  itemCount: userLists.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                        key: Key(userLists[index]
                            ['name']), // Chave única para identificar o item
                        direction: DismissDirection
                            .endToStart, // Define a direção do swipe (direita para esquerda)
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: const Color.fromARGB(
                              255, 173, 14, 3), // Cor de fundo ao deslizar
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          setState(() async {
                            await _listsService
                                .deleteList(userLists[index]['documentId']);
                            userLists.removeAt(index); // Remove o item da lista
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Lista removida'),
                              action: SnackBarAction(
                                label: 'Desfazer',
                                onPressed: () {
                                  // Implementação para desfazer a remoção
                                },
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(userLists[index]['name'],
                              style: const TextStyle(color: Color(0xFFAEBBC9))),
                          subtitle: Text(
                            userLists[index]['description'],
                            style: const TextStyle(
                                color: Color.fromARGB(255, 152, 163, 175)),
                          ),
                          leading: IconButton(
                            color: const Color(0xFFAEBBC9),
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.pop(context); // Retorna à tela anterior
                            },
                          ),
                          onTap: () async {
                            final listMovies =
                            await ListsService().getList(userLists[index]['name']);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FilmeGrid(
                                    tituloAppBar: userLists[index]['name'],
                                    filmes: listMovies
                                        .map((movie) => FilmeWidget(
                                              posterPath: movie['poster_path'] ?? '',
                                            ))
                                        .toList(),
                                  ),
                                ),
                              );
                          },
                        ));
                  },
                ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFFAEBBC9),
          foregroundColor: const Color(0xFF161E27),
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CriarListaScreen()),
            );
          }),
    );
  }
}
