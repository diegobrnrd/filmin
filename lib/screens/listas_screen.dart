import 'package:filmin/helpers/filme.dart';
import 'package:filmin/helpers/filmes_grid.dart';
import 'package:filmin/screens/criar_lista_screen.dart';
import 'package:filmin/screens/editar_lista_screen.dart';
import 'package:flutter/material.dart';
import 'package:filmin/services/lists_service.dart';
import 'package:filmin/services/user_service.dart';

class ListasScreen extends StatefulWidget {
  final String? anotherUserName;
  const ListasScreen({super.key, this.anotherUserName});

  @override
  _ListasScreenState createState() => _ListasScreenState();
}

class _ListasScreenState extends State<ListasScreen> {
  final ListsService _listsService = ListsService();
  final UserService _userService = UserService();
  List<Map<String, dynamic>> userLists = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.anotherUserName == null) {
      loadUserLists();
    } else {
      loadAnotherUserLists(widget.anotherUserName!);
    }
  }

  void loadUserLists() async {
    userLists = await _listsService.getUserLists();
    setState(() {
      isLoading = false;
    });
  }

  void loadAnotherUserLists(String username) async {
    userLists = await _userService.getAnotherUserLists(username);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Listas',
          style: TextStyle(
              color: const Color(0xFFAEBBC9), fontSize: screenHeight * 0.025),
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
              ? Center(
                  child: widget.anotherUserName == null
                      ? const Text("Este perfil não possui listas.")
                      : const Text("Você não possui listas."))
              : ListView.builder(
                  itemCount: userLists.length,
                  itemBuilder: (context, index) {
                    return widget.anotherUserName == null
                        ? Dismissible(
                            key: Key(userLists[index][
                                'name']), // Chave única para identificar o item
                            direction: DismissDirection
                                .endToStart, // Define a direção do swipe (direita para esquerda)
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenHeight * 0.02),
                              color: const Color(
                                  0xFFF52958), // Cor de fundo ao deslizar
                              child: const Icon(Icons.delete,
                                  color: Color(0xFFF1F3F5)),
                            ),
                            onDismissed: (direction) async {
                              final removedList = userLists[index];
                              await _listsService
                                  .deleteList(removedList['documentId']);
                              setState(() {
                                userLists
                                    .removeAt(index); // Remove o item da lista
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'lista removida com sucesso',
                                    style: TextStyle(color: Color(0xFFF1F3F5)),
                                  ),
                                  backgroundColor: const Color(0xFF208BFE),
                                ),
                              );
                            },
                            child: ListTile(
                              title: Text(userLists[index]['name'],
                                  style: const TextStyle(
                                      color: Color(0xFFAEBBC9))),
                              subtitle: Text(
                                userLists[index]['description'],
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 152, 163, 175)),
                              ),
                              leading: IconButton(
                                color: const Color(0xFF208BFE),
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditarListaScreen(
                                              nomeAtual: userLists[index]
                                                  ['name'],
                                              descAtual: userLists[index]
                                                  ['description'],
                                            )),
                                  ); // Retorna à tela anterior
                                },
                              ),
                              onTap: () async {
                                final listMovies = await ListsService()
                                    .getList(userLists[index]['name']);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FilmeGrid(
                                      tituloAppBar: userLists[index]['name'],
                                      filmes: listMovies
                                          .map((movie) => FilmeWidget(
                                                posterPath:
                                                    movie['poster_path'] ?? '',
                                                movieId: movie['id'],
                                                runtime: movie['runtime'],
                                                releaseDate:
                                                    movie['release_date'],
                                                dateAdded: movie['dateAdded'],
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                );
                              },
                            ))
                        : ListTile(
                            title: Text(userLists[index]['name'],
                                style:
                                    const TextStyle(color: Color(0xFFAEBBC9))),
                            subtitle: Text(
                              userLists[index]['description'],
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 152, 163, 175)),
                            ),
                            onTap: () async {
                              final listMovies = await _userService.getListFromAnotherUser(
                                      userLists[index]['name'],
                                      widget.anotherUserName!);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FilmeGrid(
                                    tituloAppBar: userLists[index]['name'],
                                    filmes: listMovies
                                        .map((movie) => FilmeWidget(
                                              posterPath:
                                                  movie['poster_path'] ?? '',
                                              movieId: movie['id'],
                                              runtime: movie['runtime'],
                                              releaseDate:
                                                  movie['release_date'],
                                              dateAdded: movie['dateAdded'],
                                            ))
                                        .toList(),
                                  ),
                                ),
                              );
                            },
                          );
                  },
                ),
      floatingActionButton: widget.anotherUserName == null
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF208BFE),
              foregroundColor: const Color(0xFFF1F3F5),
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CriarListaScreen()),
                );
              })
          : null,
    );
  }
}
