import 'package:flutter/material.dart';
import 'package:filmin/screens/detalhes_filme_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FilmeWidget extends StatelessWidget {
  final String posterPath;
  final int movieId;
  final int runtime;
  final String releaseDate;
  final Timestamp? dateAdded; // Change to Timestamp

  const FilmeWidget({
    super.key,
    required this.posterPath,
    required this.movieId,
    required this.runtime,
    required this.releaseDate,
    required this.dateAdded, // Change to Timestamp
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.25,
      height: screenHeight * 0.2,
      decoration: BoxDecoration(
        border: Border.all(
            color: const Color(0xFF1E2936), width: screenWidth * 0.002),
      ),
      child: posterPath.isNotEmpty
          ? InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetalhesFilmeScreen(movieId: movieId),
            ),
          );
        },
        child: Image.network(
          'https://image.tmdb.org/t/p/w154$posterPath',
          fit: BoxFit.cover,
          width: screenWidth * 0.25,
          height: screenHeight * 0.2,
        ),
      )
          : Container(
        width: screenWidth * 0.25,
        height: screenHeight * 0.2,
        color: const Color(0xFF1E2936),
        child: const Icon(Icons.image_not_supported),
      ),
    );
  }
}