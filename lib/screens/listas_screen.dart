import 'package:filmin/screens/criar_lista_screen.dart';
import 'package:flutter/material.dart';

class ListasScreen extends StatelessWidget {
  const ListasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listas', 
          style: TextStyle(color: Color(0xFFAEBBC9)),),
        backgroundColor: const Color(0xFF161E27),
        leading: IconButton(
          color: const Color(0xFFAEBBC9),
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Retorna à tela anterior
          },
        ),
      ),
      body: const Placeholder(),
      floatingActionButton: FloatingActionButton(onPressed: () {Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CriarListaScreen()),
                );}),
    );
  }
}