import 'package:flutter/material.dart';
import 'package:filmin/cadastro2.dart';
import 'package:filmin/login.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  CadastroScreenState createState() => CadastroScreenState();
}

class CadastroScreenState extends State<CadastroScreen> {
  bool _isPasswordHidden = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

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
              backgroundColor: Colors.transparent,
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
            SizedBox(height: screenHeight * 0.04),
            Text(
              'Criar Conta',
              style: TextStyle(
                color: const Color(0xFF208BFE),
                fontSize: screenHeight * 0.040,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            _buildTextField(
              'E-mail',
              fillColor: const Color(0xFF1E2936),
              textColor: const Color(0xFF788EA5),
              focusedTextColor: const Color(0xFF208BFE),
              inputTextColor: const Color(0xFFF1F3F5),
            ),
            SizedBox(height: screenHeight * 0.010),
            _buildTextField(
              'Senha',
              obscureText: _isPasswordHidden,
              fillColor: const Color(0xFF1E2936),
              textColor: const Color(0xFF788EA5),
              focusedTextColor: const Color(0xFF208BFE),
              inputTextColor: const Color(0xFFF1F3F5),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFF788EA5),
                ),
                onPressed: _togglePasswordVisibility,
              ),
            ),
            SizedBox(height: screenHeight * 0.010),
            _buildTextField(
              'Confirme a senha',
              obscureText: _isPasswordHidden,
              fillColor: const Color(0xFF1E2936),
              textColor: const Color(0xFF788EA5),
              focusedTextColor: const Color(0xFF208BFE),
              inputTextColor: const Color(0xFFF1F3F5),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFF788EA5),
                ),
                onPressed: _togglePasswordVisibility,
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            _buildButton(
              'Próximo',
              backgroundColor: const Color(0xFF208BFE),
              textColor: const Color(0xFFF1F3F5),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Cadastro2Screen()),
                );
              },
            ),
            SizedBox(height: screenHeight * 0.006),
            _buildButton(
              'Fazer login',
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

  Widget _buildTextField(String label, {bool obscureText = false, Color fillColor = Colors.transparent, Color textColor = Colors.black, Color focusedTextColor = Colors.black, Color inputTextColor = Colors.black, Widget? suffixIcon}) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (hasFocus) {
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
              suffixIcon: suffixIcon,
            ),
            obscureText: obscureText,
            style: TextStyle(color: inputTextColor),
          );
        },
      ),
    );
  }

  Widget _buildButton(String text, {required Color backgroundColor, required Color textColor, required VoidCallback onPressed}) {
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