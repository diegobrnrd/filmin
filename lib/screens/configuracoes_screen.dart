import 'package:flutter/material.dart';
import 'package:filmin/screens/alterar_email_screen.dart';
import 'package:filmin/screens/alterar_senha_screen.dart';
import 'package:filmin/screens/alterar_nome_sobrenome_screen.dart';
import 'package:filmin/screens/deletar_conta_screen.dart';
import 'package:filmin/screens/home_screen.dart';

class ConfiguracoesScreen extends StatelessWidget {
  const ConfiguracoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Configurações de Perfil',
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
                    SizedBox(height: screenHeight * 0.03),
                    Align(
                      alignment: Alignment.center,
                      child: _buildButton(
                        context,
                        'Alterar nome e sobrenome',
                        backgroundColor: const Color(0xFF1E2936),
                        textColor: const Color(0xFF788EA5),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AlterarNomeSobrenomeScreen()),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.007),
                    Align(
                      alignment: Alignment.center,
                      child: _buildButton(
                        context,
                        'Alterar email',
                        backgroundColor: const Color(0xFF1E2936),
                        textColor: const Color(0xFF788EA5),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AlterarEmailScreen()),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.007),
                    Align(
                      alignment: Alignment.center,
                      child: _buildButton(
                        context,
                        'Alterar senha',
                        backgroundColor: const Color(0xFF1E2936),
                        textColor: const Color(0xFF788EA5),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AlterarSenhaScreen()),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.007),
                    Align(
                      alignment: Alignment.center,
                      child: _buildButton(
                        context,
                        'Deletar conta',
                        backgroundColor: const Color(0xFF1E2936),
                        textColor: const Color(0xFF788EA5),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DeletarContaScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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