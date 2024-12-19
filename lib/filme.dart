import 'package:flutter/material.dart';

class FilmeWidget extends StatelessWidget {
  final String posterPath;

  const FilmeWidget({super.key, required this.posterPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF1E2936), width: 1),
      ),
      child: posterPath.isNotEmpty
          ? Image.network(
              'https://image.tmdb.org/t/p/w154$posterPath',
              fit: BoxFit.cover,
              width: 100,
              height: 150,
            )
          : Container(
              width: 100,
              height: 150,
              color: Colors.grey,
              child: const Icon(Icons.image_not_supported),
            ),
    );
  }
}
