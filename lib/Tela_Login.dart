

import 'package:flutter/material.dart';
import 'HomePage.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Login'),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _buildUsernameField(),
            const SizedBox(height: 16.0),
            _buildPasswordField(),
            const SizedBox(height: 20),
            _buildLoginButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      decoration: _buildInputDecoration('Nome de usuário'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira seu nome de usuário';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: _buildInputDecoration('Senha'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira sua senha';
        }
        return null;
      },
    );
  }

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.lightGreen),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.lightGreen),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      style: _buttonStyle(),
      onPressed: () {
        if(_handleLogin(context)) {
          _navigateToHomePage(context);
        }
      },
      child: const Text('Acessar')
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.lightGreen,
      foregroundColor: Colors.white,
    );
  }


  void _navigateToHomePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }
  
  // confere se os campos estao preenchidos
  bool _handleLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }
}


