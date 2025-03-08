import 'package:filmin/screens/perfil_screen.dart';
import 'package:filmin/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:filmin/controlador/controlador.dart';
import 'package:flutter/foundation.dart';
import 'package:filmin/screens/detalhes_filme_screen.dart';
import 'package:filmin/services/user_service.dart';

class BuscaScreen extends StatefulWidget {
  const BuscaScreen({super.key});

  @override
  BuscaScreenState createState() => BuscaScreenState();
}

class BuscaScreenState extends State<BuscaScreen> {
  int _selectedIndex = 0;
  List<dynamic> _searchResults = [];
  final TextEditingController _controller = TextEditingController();
  Map<String, bool> _followStatus = {}; // Manter o estado de seguir

  Future<String?> _getCurrentUserId() async {
    return await AuthService().getCurrentUserId();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _searchResults.clear();
      _controller.clear();
    });
  }

  void _buscarFilmes(String query) async {
    try {
      final results = await Controlador().buscarFilmes(query);
      final filteredResults = results.where((movie) => movie['original_language'] == 'pt').toList();
      setState(() {
        _searchResults = filteredResults;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  void _buscarPerfil(String query) async {
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
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  void _navegarParaDetalhesFilme(int movieId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalhesFilmeScreen(movieId: movieId),
      ),
    );
  }

  void _navegarParaPerfilUsuario(String? username) {
    if (username != null && username.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PerfilScreen(anotherUserName: username),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não encontrado.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF161E27),
        iconTheme: const IconThemeData(
          color: Color(0xFFAEBBC9),
        ),
        title: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: _selectedIndex == 0 ? 'Buscar filme...' : 'Buscar perfil...',
            hintStyle: TextStyle(color: const Color(0xFFAEBBC9), fontSize: screenHeight * 0.02),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Color(0xFFAEBBC9)),
          onSubmitted: (query) {
            if (_selectedIndex == 0) {
              _buscarFilmes(query);
            } else if (_selectedIndex == 1) {
              _buscarPerfil(query);
            }
          },
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
      body: FutureBuilder<String?>(
        future: _getCurrentUserId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar usuário'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('Usuário não encontrado'));
          }

          final currentUserId = snapshot.data;

          return Column(
            children: [
              Container(
                color: const Color(0xFF161E27),
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () => _onItemTapped(0),
                      style: TextButton.styleFrom(
                        foregroundColor: _selectedIndex == 0
                            ? const Color(0xFF208BFE)
                            : const Color(0xFFAEBBC9),
                      ),
                      child: const Text("Filme"),
                    ),
                    TextButton(
                      onPressed: () => _onItemTapped(1),
                      style: TextButton.styleFrom(
                        foregroundColor: _selectedIndex == 1
                            ? const Color(0xFF208BFE)
                            : const Color(0xFFAEBBC9),
                      ),
                      child: const Text('Perfil'),
                    ),
                  ],
                ),
              ),
              Divider(
                color: const Color(0xFF1E2936),
                height: screenHeight * 0.001,
                thickness: screenHeight * 0.002,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    if (_selectedIndex == 0) {
                      final movie = _searchResults[index];
                      final posterPath = movie['poster_path'];
                      return InkWell(
                        onTap: () => _navegarParaDetalhesFilme(movie['id']),
                        child: Container(
                          padding: EdgeInsets.all(screenWidth * 0.02),
                          margin: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
                          child: Row(
                            children: [
                              if (posterPath != null && posterPath.isNotEmpty)
                                Image.network(
                                  'https://image.tmdb.org/t/p/w154$posterPath',
                                  fit: BoxFit.cover,
                                  width: screenWidth * 0.25,
                                  height: screenHeight * 0.2,
                                )
                              else
                                Container(
                                  width: screenWidth * 0.25,
                                  height: screenHeight * 0.2,
                                  color: const Color(0xFF1E2936),
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              SizedBox(width: screenWidth * 0.04),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      movie['title'],
                                      style: TextStyle(
                                        color: const Color(0xFFAEBBC9),
                                        fontSize: screenHeight * 0.02,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    Text(
                                      '${movie['release_date'] != null ? movie['release_date'].split('-')[0] : 'N/A'}',
                                      style: TextStyle(
                                        color: const Color(0xFFAEBBC9),
                                        fontSize: screenHeight * 0.02,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (_selectedIndex == 1) {
                      final user = _searchResults[index];
                      final username = user['username'] ?? 'Usuário Desconhecido';
                      String imageUrl = user['profilePictureUrl']?.isNotEmpty == true ? user['profilePictureUrl'] : 'assets/default_avatar.png';
                      final userUid = user['uid'];

                      return FutureBuilder<bool>(
                        future: UserService().checkIfFollowing(currentUserId, userUid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Erro ao carregar'));
                          } else if (!snapshot.hasData) {
                            return Center(child: Text('Erro inesperado'));
                          } else {
                            bool isFollowingUser = snapshot.data!;
                            _followStatus[userUid] = isFollowingUser; // Armazenar o estado

                            return InkWell(
                              onTap: () {
                                _navegarParaPerfilUsuario(username);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: screenWidth * 0.04),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(imageUrl),
                                      onBackgroundImageError: (_, __) => const AssetImage('assets/default_avatar.png'),
                                      radius: screenHeight * 0.04,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        username,
                                        style: TextStyle(color: const Color(0xFFAEBBC9), fontSize: screenHeight * 0.02),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (userUid == currentUserId) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'você não pode seguir a si mesmo',
                                                style: TextStyle(color: Color(0xFFF1F3F5)), // Cor do texto
                                              ),
                                              backgroundColor: Color(0xFFF52958), // Cor do fundo
                                            ),
                                          );
                                          return;
                                        }
                                        // Verifique o estado de "seguir" e execute a ação correspondente
                                        if (isFollowingUser) {
                                          await UserService().unfollowUser(currentUserId, userUid);
                                        } else {
                                          await UserService().followUser(currentUserId, userUid);
                                        }

                                        // Atualiza a UI
                                        setState(() {
                                          _followStatus[userUid] = !isFollowingUser; // Atualiza o estado
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF208BFE), // Cor do botão
                                        foregroundColor: const Color(0xFFF1F3F5),
                                      ),
                                      child: Text(
                                        isFollowingUser ? 'Deixar de Seguir' : 'Seguir',
                                        style: TextStyle(fontSize: screenHeight * 0.02),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      );
                    }
                    return Container(); // Caso não corresponda a nenhuma das opções
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
