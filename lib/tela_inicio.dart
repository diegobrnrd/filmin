import 'package:flutter/material.dart';
import 'cadastro_app.dart'; // Importe o arquivo cadastro.dart
import 'Tela_Login.dart'; // Importe o arquivo telaLogin.dart

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Bem-vindo!'),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCadastroButton(context),
          const SizedBox(height: 20),
          _buildLoginButton(context),
        ],
      ),
    );
  }

  Widget _buildCadastroButton(BuildContext context) {
    return ElevatedButton(
      style: _buttonStyle(),
      onPressed: () => _navigateToCadastro(context),
      child: const Text('Ir para Cadastro'),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      style: _buttonStyle(),
      onPressed: () => _navigateToLogin(context),
      child: const Text('Ir para Login'),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.lightGreen,
      foregroundColor: Colors.white,
    );
  }

  void _navigateToCadastro(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CadastroScreen()),
    );
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
