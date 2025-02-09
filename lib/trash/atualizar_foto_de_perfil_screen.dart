/*
import 'package:flutter/material.dart';
import 'package:filmin/services/auth_service.dart';

class AtualizarFotoDePerfilScreen extends StatefulWidget {
  const AtualizarFotoDePerfilScreen({super.key});

  @override
  AtualizarFotoDePerfilScreenState createState() => AtualizarFotoDePerfilScreenState();
}

class AtualizarFotoDePerfilScreenState extends State<AtualizarFotoDePerfilScreen> {
  final AuthService authService = AuthService();

  void uploadImage() async {
    String? imageUrl = await authService.uploadProfileImage();
    if (imageUrl != null) {
      print("Imagem enviada com sucesso: $imageUrl");
    }
  }

  void deleteImage() async {
    await authService.deleteProfileImage();
    print("Imagem deletada com sucesso");
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Atualizar foto de perfil',
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
                  CircleAvatar(
                    radius: screenWidth * 0.13,
                    backgroundImage: const NetworkImage('URL_DA_FOTO_DO_USUARIO'),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  _buildButton(
                    context,
                    'Atualizar foto',
                    backgroundColor: const Color(0xFF1E2936),
                    textColor: const Color(0xFF788EA5),
                    onPressed: uploadImage,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  _buildButton(
                    context,
                    'Deletar foto',
                    backgroundColor: const Color(0xFF1E2936),
                    textColor: const Color(0xFF788EA5),
                    onPressed: deleteImage,
                  ),
                ],
              ),
            ),
          ),
        ],
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
*/