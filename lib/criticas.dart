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
          title: const Text(
            "Críticas",
            style: TextStyle(color: Color(0xFFAEBBC9)),
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
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Center(
              child: Column(
            children: _criticas,
          )),
        )));
  }

  Widget _buildCritica(String tituloFilme, String textoCritica) {
    return Container(
        margin: const EdgeInsets.symmetric(
            vertical: 10.0, horizontal: 10.0), // Define a margem
        padding: const EdgeInsets.all(8.0), // (Opcional)
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(children: [
              Text(
                "Título do Filme",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFFAEBBC9)),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "2024",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.grey),
              )
            ]),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                const FilmeWidget(
                  posterPath: '',
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Text(
                  textoCritica,
                  style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                      color: Colors.white),
                ))
              ],
            )
          ],
        ));
  }
}
