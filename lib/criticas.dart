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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: _criticas,
      )),
    ));
  }

  Widget _buildCritica(String tituloFilme, String textoCritica) {
    return Column(
      children: [
        const Text("Título do Filme", style: TextStyle(
          fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.blue
        ),),
        Row(
          children: [
            FilmeWidget(titulo: tituloFilme),
            const SizedBox(width: 20,),
            Expanded( 
            child: Text(textoCritica, style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 16,
              color: Colors.white
          ),
          )
          )
          ],
        )
      ],
    );
  }
}
