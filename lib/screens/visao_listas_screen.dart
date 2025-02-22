import 'package:flutter/material.dart';
import 'package:filmin/services/lists_service.dart';

class ListasUsuariosScreen extends StatefulWidget {
  final String userId;

  const ListasUsuariosScreen({super.key, required this.userId});

  @override
  ListasUsuariosScreenState createState() => ListasUsuariosScreenState();
}

class ListasUsuariosScreenState extends State<ListasUsuariosScreen> {
  final ListsService _listsService = ListsService();
  List<Map<String, dynamic>> _allLists = [];

  @override
  void initState() {
    super.initState();
    _fetchAllLists();
  }

  Future<void> _fetchAllLists() async {
    final lists = await _listsService.getAllListsWithContentsForUser(widget.userId);
    setState(() {
      _allLists = lists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listas do Usuário'),
      ),
      body: ListView.builder(
        itemCount: _allLists.length,
        itemBuilder: (context, index) {
          final list = _allLists[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: Text(list['name']),
              subtitle: Text(list['description']),
              children: (list['movies'] as List<Map<String, dynamic>>).map((movie) {
                return ListTile(
                  title: Text(movie['id']),
                  subtitle: Text(movie['release_date']),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}