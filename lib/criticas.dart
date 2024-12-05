import 'package:flutter/material.dart';

class CriticasScreen extends StatelessWidget {
  const CriticasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Críticas")),
      body: Column(
        children: [],
      ),
    );
  }

  Widget _buildCritica() {
    return Column(
        children: [
            Text("Título do Filme"),
            Row(
                children: [filme, Text("Texto da crítica")],
            )
        ],
    );
  }
}
