import 'package:flutter/material.dart';

class FilmeWidget extends StatelessWidget {
  final String titulo;

  const FilmeWidget({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF1E2936), width: 1),
      ),
      child: Center(
        child: Text(
          titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.blue
          ),
        ),
      ),
    );
  }
}