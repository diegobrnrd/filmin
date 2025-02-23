import 'package:flutter/material.dart';

class LerCriticaCompletaScreen extends StatelessWidget {
  final String reviewId;
  final String tituloFilme;
  final String textoCritica;

  const LerCriticaCompletaScreen({
    Key? key,
    required this.reviewId,
    required this.tituloFilme,
    required this.textoCritica,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tituloFilme,
          style: const TextStyle(color: Color(0xFFAEBBC9)),
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
        padding: const EdgeInsets.all(16.0),
        child: Text(
          textoCritica,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}