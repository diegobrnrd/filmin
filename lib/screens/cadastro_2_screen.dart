import 'package:flutter/material.dart';
import 'package:filmin/screens/cadastro_screen.dart';

class Cadastro2Screen extends StatelessWidget {
  const Cadastro2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.04),
            Text(
              'Complete seu cadastro',
              style: TextStyle(
                color: const Color(0xFF208BFE),
                fontSize: screenHeight * 0.040,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            _buildTextField(
              'Nome',
              fillColor: const Color(0xFF1E2936),
              textColor: const Color(0xFF788EA5),
              focusedTextColor: const Color(0xFF208BFE),
              inputTextColor: const Color(0xFFF1F3F5),
            ),
            SizedBox(height: screenHeight * 0.01),
            _buildTextField(
              'Sobrenome',
              fillColor: const Color(0xFF1E2936),
              textColor: const Color(0xFF788EA5),
              focusedTextColor: const Color(0xFF208BFE),
              inputTextColor: const Color(0xFFF1F3F5),
            ),
            SizedBox(height: screenHeight * 0.01),
            _buildTextField(
              'Nome de usuário',
              fillColor: const Color(0xFF1E2936),
              textColor: const Color(0xFF788EA5),
              focusedTextColor: const Color(0xFF208BFE),
              inputTextColor: const Color(0xFFF1F3F5),
            ),
            SizedBox(height: screenHeight * 0.04),
            _buildButton(
              context,
              'Criar conta',
              backgroundColor: const Color(0xFF208BFE),
              textColor: const Color(0xFFF1F3F5),
              onPressed: () {},
            ),
            SizedBox(height: screenHeight * 0.006),
            _buildButton(
              context,
              'Voltar',
              backgroundColor: const Color(0xFF1E2936),
              textColor: const Color(0xFFAEBBC9),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CadastroScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label,
      {bool obscureText = false,
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
