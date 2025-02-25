import 'package:flutter/material.dart';
import 'package:filmin/helpers/filme.dart';
import 'package:filmin/services/review_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filmin/screens/update_delete_critica_screen.dart';
import 'package:filmin/screens/ler_critica_completa_screen.dart';
import 'package:filmin/services/user_service.dart';

class CriticasUsuarioScreen extends StatefulWidget {
  String? anotherUserName;

  CriticasUsuarioScreen({super.key, this.anotherUserName});

  @override
  _CriticasUsuarioScreen createState() => _CriticasUsuarioScreen();
}

class _CriticasUsuarioScreen extends State<CriticasUsuarioScreen> {
  final ReviewService _reviewService = ReviewService();
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Críticas",
          style: TextStyle(
              color: Color(0xFFAEBBC9), fontSize: screenHeight * 0.025),
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
        stream: widget.anotherUserName == null
            ? _reviewService.getUserReviews()
            : _userService.getAnotherUserReviews(widget.anotherUserName!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
                child: Text('Erro ao carregar críticas.',
                    style: TextStyle(color: Color(0xFFAEBBC9))));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text('Nenhuma crítica encontrada.',
                    style: TextStyle(color: Color(0xFFAEBBC9))));
          }

          final reviews = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return _buildCritica(
                int.parse(review['movieId']),
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

  Widget _buildCritica(int movieId, String tituloFilme, String textoCritica,
      String posterPath, String year, String reviewId) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const int maxLength = 100; // Limite de caracteres
    String truncatedText = textoCritica.length > maxLength
        ? textoCritica.substring(0, maxLength) + '...'
        : textoCritica;

    return Container(
      margin: EdgeInsets.symmetric(
          vertical: screenHeight * 0.01, horizontal: screenWidth * 0.02),
      padding: EdgeInsets.all(screenHeight * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                tituloFilme,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenHeight * 0.025,
                  color: Color(0xFFAEBBC9),
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(
                year,
                style: TextStyle(
                  fontSize: screenHeight * 0.015,
                  color: Color(0xFFAEBBC9),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          Row(
            children: [
              FilmeWidget(
                posterPath: posterPath,
                movieId: movieId,
                runtime: 0,
                releaseDate: year,
                dateAdded: null,
              ),
              SizedBox(width: screenWidth * 0.05),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      truncatedText,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: screenHeight * 0.016,
                        color: Color(0xFFF1F3F5),
                      ),
                    ),
                    if (textoCritica.length > maxLength)
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LerCriticaCompletaScreen(
                                reviewId: reviewId,
                                tituloFilme: tituloFilme,
                                textoCritica: textoCritica,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Leia mais',
                          style: TextStyle(color: Color(0xFF208BFE)),
                        ),
                      ),
                  ],
                ),
              ),
              if (widget.anotherUserName == null)
              IconButton(
                color: const Color(0xFFAEBBC9),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateDeleteCriticaScreen(
                        reviewId: reviewId,
                        initialContent: textoCritica,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
              ) 
              ,
            ],
          ),
        ],
      ),
    );
  }
}
