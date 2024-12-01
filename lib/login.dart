import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0), // Ajuste o valor conforme necessário
              child: CircleAvatar(
                radius: 70,
                backgroundImage: const AssetImage('assets/login.png'),
                backgroundColor: Colors.transparent,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF208BFE),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Entrar no FilmIn',
              style: TextStyle(
                color: Color(0xFF208BFE),
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            _buildTextField(
              'Nome de usuário ou endereço de e-mail',
              fillColor: const Color(0xFF1E2936),
              textColor: const Color(0xFF788EA5),
              focusedTextColor: const Color(0xFF208BFE),
              inputTextColor: const Color(0xFFF1F3F5),
              cursorColor: const Color(0xFFF1F3F5),
            ),
            const SizedBox(height: 10),
            _buildTextField(
              'Senha',
              fillColor: const Color(0xFF1E2936),
              textColor: const Color(0xFF788EA5),
              focusedTextColor: const Color(0xFF208BFE),
              inputTextColor: const Color(0xFFF1F3F5),
              cursorColor: const Color(0xFFF1F3F5),
            ),
            const SizedBox(height: 30),
            _buildButton(
                'Acessar',
                backgroundColor: const Color(0xFF208BFE),
                textColor: const Color(0xFFF1F3F5)
            ),
            const SizedBox(height: 2),
            _buildButton(
                'Juntar-se',
                backgroundColor: const Color(0xFF1E2936),
                textColor: const Color(0xFFAEBBC9)
            ),
            const SizedBox(height: 2),
            _buildButton(
                'Redefinir senha',
                backgroundColor: const Color(0xFF1E2936),
                textColor: const Color(0xFFAEBBC9)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {bool obscureText = false, Color fillColor = Colors.transparent, Color textColor = Colors.black, Color focusedTextColor = Colors.black, Color inputTextColor = Colors.black, Color cursorColor = Colors.black}) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          // Change the text color when the field is focused
        }
      },
      child: Builder(
        builder: (context) {
          final isFocused = Focus.of(context).hasFocus;
          return TextFormField(
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: isFocused ? focusedTextColor : textColor),
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: fillColor,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF2E4052)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF208BFE)),
              ),
            ),
            obscureText: obscureText,
            style: TextStyle(color: inputTextColor),
            cursorColor: cursorColor,
          );
        },
      ),
    );
  }

  Widget _buildButton(String text, {required Color backgroundColor, required Color textColor}) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
        ),
        child: Text(text),
      ),
    );
  }
}