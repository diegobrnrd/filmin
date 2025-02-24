import 'package:flutter/material.dart';
import 'package:filmin/services/lists_service.dart';

class EscolherListaScreen extends StatefulWidget {
  final Map<String, dynamic> movie;

  const EscolherListaScreen({super.key, required this.movie});

  @override
  _EscolherListaScreenState createState() => _EscolherListaScreenState();
}

class _EscolherListaScreenState extends State<EscolherListaScreen> {
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
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Adicionar Filme na Lista',
          style: TextStyle(
              color: Color(0xFFAEBBC9), fontSize: screenHeight * 0.025),
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
                  itemCount:
                      userLists.length, // Define o número de itens na lista
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        userLists[index]['name'],
                        style: const TextStyle(color: Color(0xFFF1F3F5)),
                      ),
                      subtitle: Text(
                        userLists[index]['description'],
                        style: const TextStyle(
                          color: Color(0xFFF1F3F5),
                        ),
                      ),
                      leading: IconButton(
                        color: const Color(0xFF208BFE),
                        icon: const Icon(Icons.list),
                        onPressed: () async {
                          await _listsService.addToList(
                              widget.movie, userLists[index]['name']);
                          Navigator.pop(context); // Retorna à tela anterior
                        },
                      ),
                      onTap: () async {
                        await _listsService.addToList(
                            widget.movie, userLists[index]['name']);
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
    );
  }
}
