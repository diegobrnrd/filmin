import 'package:filmin/screens/cadastro_2_screen.dart';
import 'package:flutter/material.dart';
import 'package:filmin/screens/home_screen.dart';
import 'package:filmin/services/auth_service.dart';

class CadastroScreen extends StatefulWidget {
  final String nome;
  final String sobrenome;
  final String nomeDeUsuario;

  const CadastroScreen({
    super.key,
    required this.nome,
    required this.sobrenome,
    required this.nomeDeUsuario,
  });

  @override
  CadastroScreenState createState() => CadastroScreenState();
}

class CadastroScreenState extends State<CadastroScreen> {
  bool _isPasswordHidden = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.03),
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
              'Email',
              controller: _emailController,
              fillColor: const Color(0xFF1E2936),
              textColor: const Color(0xFF788EA5),
              focusedTextColor: const Color(0xFF208BFE),
              inputTextColor: const Color(0xFFF1F3F5),
            ),
            SizedBox(height: screenHeight * 0.011),
            _buildTextField(
              'Senha',
              controller: _passwordController,
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
            SizedBox(height: screenHeight * 0.03),
            _buildButton(
              'Criar conta',
              backgroundColor: const Color(0xFF208BFE),
              textColor: const Color(0xFFF1F3F5),
              onPressed: () {
                AuthService autoService = AuthService();
                autoService
                    .signUpWithEmailAndPassword(
                        email: _emailController.text,
                        senha: _passwordController.text,
                        nome: widget.nome,
                        sobrenome: widget.sobrenome,
                        username: widget.nomeDeUsuario)
                    .then((String? erro) {
                  if (erro != null) {
                    final snackBar = SnackBar(
                      content: Text(
                        erro,
                        style: const TextStyle(color: Color(0xFFF1F3F5)),
                      ),
                      backgroundColor: const Color(0xFFF52958),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  }
                });
              },
            ),
            SizedBox(height: screenHeight * 0.007),
            _buildButton(
              'Voltar',
              backgroundColor: const Color(0xFF1E2936),
              textColor: const Color(0xFFAEBBC9),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Cadastro2Screen()),
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

  Widget _buildButton(String text,
      {required Color backgroundColor,
      required Color textColor,
      required VoidCallback onPressed}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: screenWidth * 0.60,
      height: screenHeight * 0.050,
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
