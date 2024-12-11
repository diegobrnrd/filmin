import 'package:filmin/busca.dart';
import 'package:filmin/configuracoes.dart';
import 'package:filmin/perfil.dart';
import 'package:filmin/criticas.dart';
import 'package:filmin/login.dart';
import 'package:flutter/material.dart';
import 'filmes_grid.dart';
import 'filme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Popular",
          style: TextStyle(color: Color(0xFFAEBBC9)),
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
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF161E27),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('URL_DA_FOTO_DO_USUARIO'),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Nome Sobrenome',
                        style: TextStyle(
                          color: Color(0xFFAEBBC9),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '@nomeusuario',
                        style: TextStyle(
                          color: Color(0xFFAEBBC9),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.star, color: Color(0xFFAEBBC9)),
              title: const Text(
                "Popular",
                style: TextStyle(
                  color: Color(0xFFAEBBC9),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.search, color: Color(0xFFAEBBC9)),
              title: const Text(
                "Busca",
                style: TextStyle(
                  color: Color(0xFFAEBBC9),
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
              title: const Text(
                "Perfil",
                style: TextStyle(
                  color: Color(0xFFAEBBC9),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Perfil()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time, color: Color(0xFFAEBBC9)),
              title: const Text(
                "Quero Assistir",
                style: TextStyle(
                  color: Color(0xFFAEBBC9),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilmeGrid(
                      tituloAppBar: "Quero Assistir",
                      filmes: _mockFilmes(),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.rate_review, color: Color(0xFFAEBBC9)),
              title: const Text(
                "Críticas",
                style: TextStyle(
                  color: Color(0xFFAEBBC9),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CriticasScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Color(0xFFAEBBC9)),
              title: const Text(
                "Configurações",
                style: TextStyle(
                  color: Color(0xFFAEBBC9),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ConfiguracoesScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFFAEBBC9)),
              title: const Text(
                "Sair",
                style: TextStyle(
                  color: Color(0xFFAEBBC9),
                ),
              ),
              onTap: () {
                Navigator.push(
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
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () => _onItemTapped(0),
                  style: TextButton.styleFrom(
                    foregroundColor: _selectedIndex == 0 ? const Color(0xFF208BFE) : const Color(0xFFAEBBC9),
                  ),
                  child: const Text("Filmes"),
                ),
                TextButton(
                  onPressed: () => _onItemTapped(1),
                  style: TextButton.styleFrom(
                    foregroundColor: _selectedIndex == 1 ? const Color(0xFF208BFE) : const Color(0xFFAEBBC9),
                  ),
                  child: const Text('Cinemas'),
                ),
              ],
            ),
          ),
          const Divider(
            color: Color(0xFF1E2936),
            height: 1,
            thickness: 2,
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildFilmesContent(),
                const CinemasScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilmesContent() {
    return Column(
      children: [
        const SizedBox(height: 20.0),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              'Em Cartaz',
              style: TextStyle(color: Color(0xFFAEBBC9), fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 20,
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
    );
  }

  List<FilmeWidget> _mockFilmes() {
    return List.generate(40, (index) => FilmeWidget(titulo: 'Filme ${index + 1}'));
  }
}

class CinemasScreen extends StatelessWidget {
  const CinemasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Cinemas',
        style: TextStyle(color: Color(0xFFAEBBC9)),
      ),
    );
  }
}