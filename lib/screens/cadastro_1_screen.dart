import 'package:filmin/screens/cadastro_2_screen.dart';
import 'package:flutter/material.dart';
import 'package:filmin/screens/login_screen.dart';
import 'package:filmin/services/auth_service.dart';

class Cadastro1Screen extends StatelessWidget {
  Cadastro1Screen({super.key});

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sobrenomeController = TextEditingController();
  final TextEditingController _nomeDeUsuarioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: screenWidth * 0.18,
              backgroundImage: const AssetImage('assets/cadastro.png'),
              child: Container(
                width: screenWidth * 0.4,
                height: screenWidth * 0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF208BFE),
                    width: screenWidth * 0.0025,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              'Cadastro',
              style: TextStyle(
                color: const Color(0xFF208BFE),
                fontSize: screenHeight * 0.040,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            _buildTextField(
              'Nome',
              controller: _nomeController,
              fillColor: const Color(0xFF1E2936),
              textColor: const Color(0xFF788EA5),
              focusedTextColor: const Color(0xFF208BFE),
              inputTextColor: const Color(0xFFF1F3F5),
            ),
            SizedBox(height: screenHeight * 0.01),
            _buildTextField(
              'Sobrenome',
              controller: _sobrenomeController,
              fillColor: const Color(0xFF1E2936),
              textColor: const Color(0xFF788EA5),
              focusedTextColor: const Color(0xFF208BFE),
              inputTextColor: const Color(0xFFF1F3F5),
            ),
            SizedBox(height: screenHeight * 0.01),
            _buildTextField(
              '@nomedeusuário',
              controller: _nomeDeUsuarioController,
              fillColor: const Color(0xFF1E2936),
              textColor: const Color(0xFF788EA5),
              focusedTextColor: const Color(0xFF208BFE),
              inputTextColor: const Color(0xFFF1F3F5),
            ),
            SizedBox(height: screenHeight * 0.04),
            _buildButton(
              context,
              'Prosseguir',
              backgroundColor: const Color(0xFF208BFE),
              textColor: const Color(0xFFF1F3F5),
              onPressed: () async {
                if (_nomeController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'o nome vazio.',
                        style: const TextStyle(color: Color(0xFFF1F3F5)),
                      ),
                      backgroundColor: const Color(0xFFF52958),
                    ),
                  );
                  return;
                }
                if (_sobrenomeController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'sobrenome vazio',
                        style: const TextStyle(color: Color(0xFFF1F3F5)),
                      ),
                      backgroundColor: const Color(0xFFF52958),
                    ),
                  );
                  return;
                }
                if (_nomeDeUsuarioController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'nome de usuário vazio',
                        style: const TextStyle(color: Color(0xFFF1F3F5)),
                      ),
                      backgroundColor: const Color(0xFFF52958),
                    ),
                  );
                  return;
                }

                AuthService authService = AuthService();
                String normalizedUsername = _nomeDeUsuarioController.text.toLowerCase();
                bool userExists = await authService.checkUsernameExists(normalizedUsername);
                if (userExists) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'nome de usuário em uso',
                        style: const TextStyle(color: Color(0xFFF1F3F5)),
                      ),
                      backgroundColor: const Color(0xFFF52958),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Cadastro2Screen(
                      nome: _nomeController.text,
                      sobrenome: _sobrenomeController.text,
                      nomeDeUsuario: _nomeDeUsuarioController.text,
                    )),
                  );
                }
              },
            ),
            SizedBox(height: screenHeight * 0.006),
            _buildButton(
              context,
              'Entrar',
              backgroundColor: const Color(0xFF1E2936),
              textColor: const Color(0xFFAEBBC9),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label,
      {required TextEditingController controller,
        bool obscureText = false,
        Color fillColor = Colors.transparent,
        Color textColor = Colors.black,
        Color focusedTextColor = Colors.black,
        Color inputTextColor = Colors.black,
        Widget? suffixIcon}) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (hasFocus) {}
      },
      child: Builder(
        builder: (context) {
          final isFocused = Focus.of(context).hasFocus;
          return TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              labelStyle:
              TextStyle(color: isFocused ? focusedTextColor : textColor),
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: fillColor,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF2E4052)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF208BFE)),
              ),
              suffixIcon: suffixIcon,
            ),
            obscureText: obscureText,
            style: TextStyle(color: inputTextColor),
          );
        },
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text,
      {required Color backgroundColor,
        required Color textColor,
        required VoidCallback onPressed}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: screenWidth * 0.45,
      height: screenHeight * 0.045,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
        ),
        child: Text(text),
      ),
    );
  }
}