import 'package:flutter/material.dart';
import 'filme.dart';

class CriticasScreen extends StatelessWidget {

  const CriticasScreen({super.key});

  List<Widget> get _criticas {
    return List.generate(
      5,
      (index) => _buildCritica(
        'Filme $index',
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque hendrerit lacinia consequat. Ut eu ex in magna porttitor feugiat. Cras eu nisi nec tortor bibendum blandit eu a mauris. Vivamus egestas felis felis, id convallis metus eleifend malesuada. Nulla laoreet sit amet ligula sit amet fermentum. Fusce pretium iaculis tincidunt.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Críticas")),
      body: Center(
      child: Column(
        children: _criticas,
      )),
    );
  }

  Widget _buildCritica(String tituloFilme, String textoCritica) {
    return Column(
      children: [
        Text("Título do Filme"),
        Row(
          children: [
            FilmeWidget(titulo: tituloFilme), 
            Text(textoCritica, style: const TextStyle(
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
