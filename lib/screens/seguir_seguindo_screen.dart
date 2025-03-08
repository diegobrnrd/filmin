import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filmin/services/user_service.dart';
import 'package:filmin/services/auth_service.dart';
import 'package:filmin/screens/perfil_screen.dart'; // Importe a tela PerfilScreen

class FollowersFollowingScreen extends StatefulWidget {
  @override
  _FollowersFollowingScreenState createState() =>
      _FollowersFollowingScreenState();
}

class _FollowersFollowingScreenState extends State<FollowersFollowingScreen> {
  int _selectedIndex = 0;
  String? _currentUserId;
  Map<String, bool> _followStatus = {};
  int _followersCount = 0;
  int _followingCount = 0;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  Future<void> _getCurrentUserId() async {
    _currentUserId = await AuthService().getCurrentUserId();
    if (mounted) {
      setState(() {
        _fetchCounts();
      });
    }
  }

  Future<void> _fetchCounts() async {
    if (_currentUserId != null) {
      _followersCount = await UserService().getFollowersCount(_currentUserId!);
      _followingCount = await UserService().getFollowingCount(_currentUserId!);
      if (mounted) {
        setState(() {});
      }
    }
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
        title: Text(
          'Seguidores e Seguindo',
          style: TextStyle(color: Color(0xFFAEBBC9), fontSize: screenHeight * 0.025),
        ),
        backgroundColor: const Color(0xFF161E27),
        iconTheme: const IconThemeData(
          color: Color(0xFFAEBBC9),
        ),
      ),
      body: _currentUserId == null
          ? Center(child: CircularProgressIndicator())
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
                        child: Row(
                          children: [
                            Text('Seguidores',
                                style: TextStyle(
                                    color: _selectedIndex == 0
                                        ? const Color(0xFF208BFE)
                                        : const Color(0xFFAEBBC9))),
                            SizedBox(width: 4),
                            Text('($_followersCount)',
                                style: TextStyle(
                                    color: const Color(0xFFAEBBC9))),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                        child: Row(
                          children: [
                            Text('Seguindo',
                                style: TextStyle(
                                    color: _selectedIndex == 1
                                        ? const Color(0xFF208BFE)
                                        : const Color(0xFFAEBBC9))),
                            SizedBox(width: 4),
                            Text('($_followingCount)',
                                style: TextStyle(
                                    color: const Color(0xFFAEBBC9))),
                          ],
                        ),
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
                  child: _buildList(screenHeight, screenWidth),
                ),
              ],
            ),
    );
  }

  Widget _buildList(double screenHeight, double screenWidth) {
    String collectionName =
        _selectedIndex == 0 ? 'followers' : 'following';
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUserId)
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
            final photoUrl = (doc['profilePictureUrl'] as String?)?.isNotEmpty == true ? doc['profilePictureUrl'] : 'assets/default_avatar.png';
            final userUid = doc.id;

            return FutureBuilder<bool>(
              future: UserService().checkIfFollowing(_currentUserId, userUid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar'));
                } else if (!snapshot.hasData) {
                  return Center(child: Text('Erro inesperado'));
                } else {
                  bool isFollowingUser = snapshot.data!;
                  _followStatus[userUid] = isFollowingUser;

                  return InkWell(
                    onTap: () {
                      _navegarParaPerfilUsuario(username);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.01,
                          horizontal: screenWidth * 0.04),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(photoUrl),
                            onBackgroundImageError: (_, __) =>
                                const AssetImage('assets/default_avatar.png'),
                            radius: screenHeight * 0.04,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              username,
                              style: TextStyle(
                                  color: const Color(0xFFAEBBC9),
                                  fontSize: screenHeight * 0.02),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (isFollowingUser) {
                                await UserService().unfollowUser(
                                    _currentUserId, userUid);
                              } else {
                                await UserService().followUser(
                                    _currentUserId, userUid);
                              }

                              setState(() {
                                _followStatus[userUid] = !isFollowingUser;
                                _fetchCounts();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF007BFF),
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
          },
        );
      },
    );
  }
}