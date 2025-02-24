import 'package:flutter/material.dart';
import 'package:filmin/services/supabase_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:filmin/services/auth_service.dart';

class AtualizarFotoDePerfilScreen extends StatefulWidget {
  const AtualizarFotoDePerfilScreen({super.key});

  @override
  AtualizarFotoDePerfilScreenState createState() => AtualizarFotoDePerfilScreenState();
}

class AtualizarFotoDePerfilScreenState extends State<AtualizarFotoDePerfilScreen> {
  final SupabaseStorageService _storageService = SupabaseStorageService();
  final AuthService _authService = AuthService();
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  void _loadProfileImage() async {
    final String? profilePictureUrl = await _authService.getProfilePictureUrl();
    setState(() {
      _imageUrl = profilePictureUrl;
    });
  }

  void uploadImage() async {
    final XFile? imageFile = await _storageService.pickImage();
    if (imageFile != null) {
      final String? imageUrl = await _storageService.uploadImage(imageFile);
      if (imageUrl != null) {
        setState(() {
          _imageUrl = imageUrl;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'imagem enviada com sucesso',
              style: const TextStyle(color: Color(0xFFF1F3F5)),
            ),
            backgroundColor: const Color(0xFF208BFE),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'erro ao enviar a imagem',
              style: const TextStyle(color: Color(0xFFF1F3F5)),
            ),
            backgroundColor: const Color(0xFFF52958),
          ),
        );
      }
    }
  }

  void deleteImage() async {
    final String? profilePictureUrl = await _authService.getProfilePictureUrl();
    if (profilePictureUrl != null) {
      final bool success = await _storageService.deleteImage(profilePictureUrl);
      if (success) {
        setState(() {
          _imageUrl = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'imagem deletada com sucesso',
              style: const TextStyle(color: Color(0xFFF1F3F5)),
            ),
            backgroundColor: const Color(0xFF208BFE),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'erro ao deletar a imagem',
              style: const TextStyle(color: Color(0xFFF1F3F5)),
            ),
            backgroundColor: const Color(0xFFF52958),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Atualizar Foto de Perfil',
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
                    backgroundImage: _imageUrl != null && _imageUrl!.isNotEmpty
                        ? NetworkImage(_imageUrl!)
                        : const AssetImage('assets/default_avatar.png'),
                  ),
                  SizedBox(height: screenHeight * 0.02),
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
