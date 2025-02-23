import 'package:flutter/material.dart';
import 'package:filmin/helpers/filme.dart';
import 'package:filmin/services/review_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filmin/screens/update_delete_critica_screen.dart';
import 'package:filmin/screens/ler_critica_completa_screen.dart';


class CriticasUsuarioScreen extends StatefulWidget {
  const CriticasUsuarioScreen({super.key});

  @override
  _CriticasUsuarioScreen createState() => _CriticasUsuarioScreen();
}

class _CriticasUsuarioScreen extends State<CriticasUsuarioScreen> {
  final ReviewService _reviewService = ReviewService();

  @override
  Widget build(BuildContext context) {
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _reviewService.getUserReviews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar críticas.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhuma crítica encontrada.'));
          }

          final reviews = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return _buildCritica(
                review['movieId'],
                review['title'],
                review['content'],
                review['poster_path'],
                review['year'],
                review.id,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCritica(int movieId, String tituloFilme, String textoCritica, String posterPath, String year, String reviewId) {
    const int maxLength = 100; // Limite de caracteres
    String truncatedText = textoCritica.length > maxLength
        ? textoCritica.substring(0, maxLength) + '...'
        : textoCritica;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                tituloFilme,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFFAEBBC9),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                year,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              FilmeWidget(
                posterPath: posterPath,
                movieId: movieId,
                runtime: 0,
                releaseDate: year,
                dateAdded: null,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      truncatedText,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                    if (textoCritica.length > maxLength)
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LerCriticaCompletaScreen(
                                    reviewId: reviewId,
                                    tituloFilme: tituloFilme,
                                    textoCritica: textoCritica,
                                  ),
                            ),
                          );
                        },
                        child: const Text(
                          'Leia mais',
                          style: TextStyle(color: Color(0xFFAEBBC9)),
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                color: const Color(0xFFAEBBC9),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UpdateDeleteCriticaScreen(
                            reviewId: reviewId,
                            initialContent: textoCritica,
                          ),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
        ],
      ),
    );
  }
}