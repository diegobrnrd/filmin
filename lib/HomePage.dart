
import 'package:flutter/material.dart';


class MyHomePage extends StatelessWidget {
  // Define uma GlobalKey para o ScaffoldState
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Home Page'),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          _scaffoldKey.currentState!.openDrawer();
        },
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _buildDrawerHeader(),
          _buildDrawerItem(
            icon: Icons.account_circle,
            text: 'Perfil',
            onTap: () {
              
            },
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            text: 'Configurações',
            onTap: () {
              
            },
          ),
          _buildDrawerItem(
            icon: Icons.logout,
            text: 'Sair',
            onTap: () {    

          }        
          ),
        ],
      ),
    );
  }

  DrawerHeader _buildDrawerHeader() {
    return const DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.lightGreen,
      ),
      child: Text(
        'User Settings',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );
  }

  ListTile _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }


  Widget _buildBody() {
    return const Center();
  }
}

