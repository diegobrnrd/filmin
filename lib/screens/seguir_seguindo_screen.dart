import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filmin/services/user_service.dart';
import 'package:filmin/services/auth_service.dart'; // Importe o serviço de autenticação

class FollowersFollowingScreen extends StatefulWidget {
  @override
  _FollowersFollowingScreenState createState() =>
      _FollowersFollowingScreenState();
}

class _FollowersFollowingScreenState extends State<FollowersFollowingScreen> {
  int _selectedIndex = 0; // 0 para seguidores, 1 para seguindo
  String? _currentUserId; // Adiciona uma variável para armazenar o ID do usuário atual

  @override
  void initState() {
    super.initState();
    _getCurrentUserId(); // Chama a função para obter o ID do usuário atual
  }

  // Função para obter o ID do usuário atual
  Future<void> _getCurrentUserId() async {
    _currentUserId = await AuthService().getCurrentUserId();
    if (mounted) {
      setState(() {}); // Atualiza o estado após obter o ID
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seguidores e Seguindo'),
        backgroundColor: const Color(0xFF161E27),
        iconTheme: const IconThemeData(
          color: Color(0xFFAEBBC9),
        ),
      ),
      body: _currentUserId == null
          ? Center(child: CircularProgressIndicator()) // Exibe loading enquanto carrega o ID
          : Column(
              children: [
                Container(
                  color: const Color(0xFF161E27),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 0;
                          });
                        },
                        child: Text('Seguidores',
                            style: TextStyle(
                                color: _selectedIndex == 0
                                    ? const Color(0xFF208BFE)
                                    : const Color(0xFFAEBBC9))),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                        child: Text('Seguindo',
                            style: TextStyle(
                                color: _selectedIndex == 1
                                    ? const Color(0xFF208BFE)
                                    : const Color(0xFFAEBBC9))),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: const Color(0xFF1E2936),
                  height: MediaQuery.of(context).size.height * 0.001,
                  thickness: MediaQuery.of(context).size.height * 0.002,
                ),
                Expanded(
                  child: _buildList(),
                ),
              ],
            ),
    );
  }

  Widget _buildList() {
    String collectionName =
        _selectedIndex == 0 ? 'followers' : 'following'; // Escolhe a coleção correta
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUserId) // Usa o ID do usuário atual
          .collection(collectionName)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar dados'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Nenhum usuário encontrado'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final username = doc['username'];
            final photoUrl = doc['profilePictureUrl'];

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(photoUrl),
                onBackgroundImageError: (_, __) =>
                    const AssetImage('assets/default_avatar.png'),
              ),
              title: Text(username,
                  style: const TextStyle(color: Color(0xFFAEBBC9))),
            );
          },
        );
      },
    );
  }
}