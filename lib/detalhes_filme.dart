import 'package:flutter/material.dart';

class DetalhesFilmeScreen extends StatelessWidget {
  final Map<String, dynamic> movieDetails;

  const DetalhesFilmeScreen({super.key, required this.movieDetails});

  @override
  Widget build(BuildContext context) {
    final backdropPath = movieDetails['backdrop_path'];
    return Scaffold(
      body: Stack(
        children: [
          if (backdropPath != null && backdropPath.isNotEmpty)
            Image.network(
              'https://image.tmdb.org/t/p/w500$backdropPath',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250,
            ),
          if (backdropPath != null && backdropPath.isNotEmpty)
            Positioned(
              top: 40,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFFAEBBC9)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          Container(
            margin: EdgeInsets.only(top: backdropPath != null && backdropPath.isNotEmpty ? 250 : 0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF161E27).withOpacity(0.7), // Updated background color
            ),
            child: Center(
              child: Text(
                'Details for movie: ${movieDetails['title']}',
                style: const TextStyle(color: Color(0xFFAEBBC9)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}