import 'package:flutter/material.dart';
import 'package:filmin/screens/busca_screen.dart';
import 'package:filmin/screens/configuracoes_screen.dart';
import 'package:filmin/screens/perfil_screen.dart';
import 'package:filmin/screens/criticas_usuario_screen.dart';
import 'package:filmin/services/auth_service.dart';
import 'package:filmin/helpers/filmes_grid.dart';
import 'package:filmin/helpers/filme.dart';
import 'package:filmin/screens/login_screen.dart';
import 'package:filmin/services/watchlist_service.dart';
import 'package:filmin/screens/listas_screen.dart';
import 'package:filmin/screens/mapa_cinemas.dart';
import 'package:filmin/controlador/controlador.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  AuthService autoService = AuthService();
  Controlador controlador = Controlador();

  String? _nome;
  String? _sobrenome;
  String? _nomeUsuario;
  String? _profilePictureUrl;
  List<dynamic> _filmesEmCartaz = [];

  Future<void> _fetchUserData() async {
    _nome = await autoService.getUserName();
    _sobrenome = await autoService.getUserSurname();
    _nomeUsuario = await autoService.getUserUsername();
    _profilePictureUrl = await autoService.getProfilePictureUrl();
    _profilePictureUrl = await autoService.getProfilePictureUrl();
    setState(() {});
  }

  Future<void> _fetchFilmesEmCartaz() async {
    try {
      _filmesEmCartaz = await controlador.buscarFilmesEmCartaz();
      setState(() {});
    } catch (e) {
      print('Erro ao carregar filmes em cartaz: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao carregar filmes em cartaz.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchFilmesEmCartaz();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Popular",
          style: TextStyle(
              color: const Color(0xFFAEBBC9), fontSize: screenHeight * 0.025),
        ),
        backgroundColor: const Color(0xFF161E27),
        iconTheme: const IconThemeData(
          color: Color(0xFFAEBBC9),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BuscaScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF161E27),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: screenHeight * 0.05,
                    backgroundImage: _profilePictureUrl != null &&
                            _profilePictureUrl!.isNotEmpty
                        ? NetworkImage(_profilePictureUrl!)
                        : const AssetImage('assets/default_avatar.png'),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$_nome $_sobrenome',
                        style: TextStyle(
                          color: const Color(0xFFAEBBC9),
                          fontSize: screenHeight * 0.022,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '@$_nomeUsuario',
                        style: TextStyle(
                          color: const Color(0xFFAEBBC9),
                          fontSize: screenHeight * 0.02,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.star, color: Color(0xFFAEBBC9)),
              title: Text(
                "Popular",
                style: TextStyle(
                  color: const Color(0xFFAEBBC9),
                  fontWeight: FontWeight.bold,
                  fontSize: screenHeight * 0.02,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.search, color: Color(0xFFAEBBC9)),
              title: Text(
                "Busca",
                style: TextStyle(
                  color: const Color(0xFFAEBBC9),
                  fontSize: screenHeight * 0.02,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BuscaScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Color(0xFFAEBBC9)),
              title: Text(
                "Perfil",
                style: TextStyle(
                  color: const Color(0xFFAEBBC9),
                  fontSize: screenHeight * 0.02,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PerfilScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time, color: Color(0xFFAEBBC9)),
              title: Text(
                "Quero Assistir",
                style: TextStyle(
                  color: const Color(0xFFAEBBC9),
                  fontSize: screenHeight * 0.02,
                ),
              ),
              onTap: () async {
                final watchlist = await WatchListService().getWatchlist();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilmeGrid(
                      tituloAppBar: "Quero Assistir",
                      filmes: watchlist
                          .map((movie) => FilmeWidget(
                                posterPath: movie['poster_path'] ?? '',
                                movieId: movie['id'],
                                runtime: movie['runtime'],
                                releaseDate: movie['release_date'],
                                dateAdded: movie['dateAdded'],
                              ))
                          .toList(),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_on, color: Color(0xFFAEBBC9)),
              title: Text(
                "Listas",
                style: TextStyle(
                  color: const Color(0xFFAEBBC9),
                  fontSize: screenHeight * 0.02,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ListasScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.rate_review, color: Color(0xFFAEBBC9)),
              title: Text(
                "Críticas",
                style: TextStyle(
                  color: const Color(0xFFAEBBC9),
                  fontSize: screenHeight * 0.02,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CriticasUsuarioScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Color(0xFFAEBBC9)),
              title: Text(
                "Configurações",
                style: TextStyle(
                  color: const Color(0xFFAEBBC9),
                  fontSize: screenHeight * 0.02,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConfiguracoesScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFFAEBBC9)),
              title: Text(
                "Sair",
                style: TextStyle(
                  color: const Color(0xFFAEBBC9),
                  fontSize: screenHeight * 0.02,
                ),
              ),
              onTap: () {
                autoService.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF161E27),
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.001),
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
                  child: const Text("Filmes"),
                ),
                TextButton(
                  onPressed: () => _onItemTapped(1),
                  style: TextButton.styleFrom(
                    foregroundColor: _selectedIndex == 1
                        ? const Color(0xFF208BFE)
                        : const Color(0xFFAEBBC9),
                  ),
                  child: const Text('Cinemas'),
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
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildFilmesContent(),
                const TelaMapa(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilmesContent() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(height: screenHeight * 0.025),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.03),
            child: Text(
              'Em Cartaz',
              style: TextStyle(
                color: const Color(0xFFAEBBC9),
                fontSize: screenHeight * 0.02,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.018),
          child: SizedBox(
            height: screenHeight * 0.2,
            child: _filmesEmCartaz.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filmesEmCartaz.length,
                    itemBuilder: (context, index) {
                      final filme = _filmesEmCartaz[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenHeight * 0.005),
                        child: FilmeWidget(
                          posterPath: filme['poster_path'] ?? '',
                          movieId: filme['id'] ?? 0,
                          runtime: 0,
                          releaseDate: filme['release_date'] ?? '',
                          dateAdded: null,
                        ),
                      );
                    },
                  ),
          ),
        )
      ],
    );
  }
}
