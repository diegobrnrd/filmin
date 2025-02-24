import 'package:flutter/material.dart';
import 'package:filmin/services/auth_service.dart';
import 'package:filmin/screens/configuracoes_screen.dart';

class AlterarEmailScreen extends StatelessWidget {
  const AlterarEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final TextEditingController emailController = TextEditingController();
    final TextEditingController senhaController = TextEditingController();
    final AuthService authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Alterar Email',
          style: TextStyle(
              color: const Color(0xFFAEBBC9), fontSize: screenHeight * 0.025),
        ),
        backgroundColor: const Color(0xFF161E27),
        iconTheme: const IconThemeData(
          color: Color(0xFFAEBBC9),
        ),
      ),
      body: Column(
        children: [
          Divider(
            color: const Color(0xFF1E2936),
            height: screenHeight * 0.001,
            thickness: screenHeight * 0.002,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTextField(
                    'Novo email',
                    controller: emailController,
                    fillColor: const Color(0xFF1E2936),
                    textColor: const Color(0xFF788EA5),
                    focusedTextColor: const Color(0xFF208BFE),
                    inputTextColor: const Color(0xFFF1F3F5),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  _buildTextField(
                    'Senha',
                    controller: senhaController,
                    fillColor: const Color(0xFF1E2936),
                    textColor: const Color(0xFF788EA5),
                    focusedTextColor: const Color(0xFF208BFE),
                    inputTextColor: const Color(0xFFF1F3F5),
                    obscureText: true,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'Será necessário confirmar a alteração do email através de um link enviado para o novo email.',
                    style: TextStyle(
                        color: const Color(0xFF208BFE),
                        fontSize: screenHeight * 0.02),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  _buildButton(
                    context,
                    'Salvar Alterações',
                    backgroundColor: const Color(0xFF208BFE),
                    textColor: const Color(0xFFF1F3F5),
                    onPressed: () async {
                      String email = emailController.text;
                      String senha = senhaController.text;
                      String? result = await authService.updateEmail(
                        newEmail: email,
                        senha: senha,
                      );
                      if (result == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'confirme a alteração em seu novo email',
                              style: const TextStyle(color: Color(0xFFF1F3F5)),
                            ),
                            backgroundColor: const Color(0xFF208BFE),
                          ),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const ConfiguracoesScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              result,
                              style: const TextStyle(color: Color(0xFFF1F3F5)),
                            ),
                            backgroundColor: const Color(0xFFF52958),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
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