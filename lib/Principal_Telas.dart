import 'package:flutter/material.dart';
import 'tela_inicio.dart';


void main() {
  runApp(const Filmln());
}

class Filmln extends StatelessWidget {
  const Filmln({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Filmln',
      theme: ThemeData(primarySwatch: Colors.lightGreen),
      home: const HomeScreen(),
    );
  }
}

