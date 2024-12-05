import 'package:flutter/material.dart';
import 'filme.dart';

class CriticasScreen extends StatelessWidget {

  const CriticasScreen({super.key});

  List<Widget> get _criticas {
    return List.generate(
      5,
      (index) => _buildCritica(
        'Filme $index',
        'Esta é a crítica para o filme $index.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Críticas")),
      body: Column(
        children: _criticas,
      ),
    );
  }

  Widget _buildCritica(String titulo_filme, String texto_critica) {
    return Column(
      children: [
        Text("Título do Filme"),
        Row(
          children: [
            FilmeWidget(titulo: titulo_filme), 
            Text(texto_critica, style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blue
          ),
          )
          ],
        )
      ],
    );
  }
}
