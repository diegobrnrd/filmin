import 'package:flutter/material.dart';
import 'package:filmin/helpers/filme.dart';

class FilmeGrid extends StatelessWidget {
  final List<FilmeWidget> filmes;
  final String tituloAppBar;

  const FilmeGrid({
    super.key,
    required this.filmes,
    required this.tituloAppBar,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tituloAppBar,
          style: TextStyle(
              color: const Color(0xFFAEBBC9), fontSize: screenHeight * 0.025),
        ),
        backgroundColor: const Color(0xFF161E27),
        iconTheme: const IconThemeData(
          color: Color(0xFFAEBBC9),
        ),
      ),
      body: Expanded(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.7,
            crossAxisSpacing: screenWidth * 0.01,
            mainAxisSpacing: screenHeight * 0.01,
          ),
          itemCount: filmes.length,
          itemBuilder: (context, index) {
            return filmes[index];
          },
        ),
      ),
    );
  }
}
