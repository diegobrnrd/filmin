import 'package:flutter/material.dart';
import 'package:filmin/services/user_service.dart';
import 'package:filmin/screens/visao_listas_screen.dart';

class BuscaUsuarioScreen extends StatefulWidget {
  const BuscaUsuarioScreen({super.key});

  @override
  BuscaUsuarioScreenState createState() => BuscaUsuarioScreenState();
}

class BuscaUsuarioScreenState extends State<BuscaUsuarioScreen> {
  List<Map<String, dynamic>> _searchResults = [];
  final TextEditingController _controller = TextEditingController();

  void _buscarUsuarios(String query) async {
    try {
      final results = await UserService().getUserDataByUsername(query);
      if (results != null) {
        setState(() {
          _searchResults = [results];
        });
      } else {
        setState(() {
          _searchResults.clear();
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF161E27),
        iconTheme: const IconThemeData(color: Color(0xFFAEBBC9)),
        title: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Buscar usuário...',
            hintStyle: TextStyle(color: Color(0xFFAEBBC9)),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Color(0xFFAEBBC9)),
          onSubmitted: _buscarUsuarios,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear, color: Color(0xFFAEBBC9)),
            onPressed: () {
              _controller.clear();
              setState(() {
                _searchResults.clear();
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final user = _searchResults[index];
          final username = user['username'] ?? 'Usuário Desconhecido';
          final imageUrl = user['imageUrl'] ?? 'URL_PADRAO_IMAGEM';
          final userId = user['id'] ?? '';

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                if (userId.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListasUsuariosScreen(userId: userId),
                    ),
                  );
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl),
                    onBackgroundImageError: (_, __) => const AssetImage('assets/default_avatar.png'),
                    radius: 30,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      username,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (userId.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListasUsuariosScreen(userId: userId),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Ver Listas',
                      style: TextStyle(color: Colors.blueAccent, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}