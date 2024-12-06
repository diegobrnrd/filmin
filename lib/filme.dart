import 'package:flutter/material.dart';

class FilmeWidget extends StatelessWidget {
  final String titulo;

  const FilmeWidget({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(10),
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