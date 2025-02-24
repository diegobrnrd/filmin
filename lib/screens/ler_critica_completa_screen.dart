import 'package:flutter/material.dart';

class LerCriticaCompletaScreen extends StatelessWidget {
  final String reviewId;
  final String tituloFilme;
  final String textoCritica;

  const LerCriticaCompletaScreen({
    super.key,
    required this.reviewId,
    required this.tituloFilme,
    required this.textoCritica,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tituloFilme,
          style: TextStyle(
                color: const Color(0xFFAEBBC9), fontSize: screenHeight * 0.025),
          ),
        backgroundColor: const Color(0xFF161E27),
        leading: IconButton(
          color: const Color(0xFFAEBBC9),
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Retorna à tela anterior
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenHeight * 0.02),
        child: Text(
          textoCritica,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: screenHeight * 0.016,
            color: Color(0xFFF1F3F5),
          ),
        ),
      ),
    );
  }
}