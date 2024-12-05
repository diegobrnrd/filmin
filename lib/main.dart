import 'package:flutter/material.dart';
import 'package:filmin/login.dart';
import 'package:filmin/criticas.dart';

void main() {
  runApp(const FilmIn());
}

class FilmIn extends StatelessWidget {
  const FilmIn({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF161E27),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFF1F3F5),
          selectionColor: Color(0xFF208BFE),
          selectionHandleColor: Color(0xFF208BFE),
        ),
      ),
      home: const CriticasScreen(),
    );
  }
}
