import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filmin/services/review_service.dart';
import 'package:filmin/services/auth_service.dart';

class CriticasFilmeScreen extends StatelessWidget {
  final String movieId;

  const CriticasFilmeScreen({required this.movieId, super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final ReviewService reviewService = ReviewService();
    final AuthService authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Críticas do filme',
          style: TextStyle(
              color: const Color(0xFFAEBBC9),
              fontSize: screenHeight * 0.025),
        ),
        backgroundColor: const Color(0xFF161E27),
        iconTheme: const IconThemeData(
          color: Color(0xFFAEBBC9),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: reviewService.getMovieReviews(movieId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar críticas'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhuma crítica encontrada'));
          }

          final reviews = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              final userId = review['userId'];

              return FutureBuilder<Map<String, String>>(
                future: authService.getUserProfile(userId),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (userSnapshot.hasError || !userSnapshot.hasData) {
                    return const ListTile(
                      title: Text('Erro ao carregar usuário'),
                    );
                  }

                  final userProfile = userSnapshot.data!;
                  final username = userProfile['username']!;
                  final profilePictureUrl = userProfile['profilePictureUrl']!;

                  return ReviewTile(
                    username: username,
                    profilePictureUrl: profilePictureUrl,
                    reviewContent: review['content'],
                  );
                },
              );
            },
          );
        },
      ),
      backgroundColor: const Color(0xFF161E27),
    );
  }
}

class ReviewTile extends StatefulWidget {
  final String username;
  final String profilePictureUrl;
  final String reviewContent;

  const ReviewTile({
    required this.username,
    required this.profilePictureUrl,
    required this.reviewContent,
    super.key,
  });

  @override
  _ReviewTileState createState() => _ReviewTileState();
}

class _ReviewTileState extends State<ReviewTile> {
  bool isExpanded = false;
  static const int maxChars = 300;

  @override
  Widget build(BuildContext context) {
    final isLongReview = widget.reviewContent.length > maxChars;
    final displayContent = isExpanded || !isLongReview
        ? widget.reviewContent
        : widget.reviewContent.substring(0, maxChars) + '...';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.profilePictureUrl.isNotEmpty
                  ? NetworkImage(widget.profilePictureUrl)
                  : null,
              child: widget.profilePictureUrl.isEmpty
                  ? const Icon(Icons.person)
                  : null,
            ),
            const SizedBox(width: 8.0),
            Text(
              widget.username,
              style: const TextStyle(color: Color(0xFFAEBBC9)),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            Text(
              displayContent,
              style: const TextStyle(color: Color(0xFFF1F3F5)),
            ),
            if (isLongReview)
              TextButton(
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Text(
                  isExpanded ? 'Mostrar menos' : 'Mostrar mais',
                  style: const TextStyle(color: Color(0xFF208BFE)),
                ),
              ),
          ],
        ),
        tileColor: const Color(0xFF1E2936),
        contentPadding: const EdgeInsets.all(8.0),
      ),
    );
  }
}