import 'package:flutter/material.dart';
import 'filme.dart';

class QueroAssistirScreen extends StatelessWidget {
  const QueroAssistirScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text(
              'Quero Assistir',
              style: TextStyle(color: Color(0xFFAEBBC9)),
            ),
            backgroundColor: const Color(0xFF161E27),
            iconTheme: const IconThemeData(
              color: Color(0xFFAEBBC9),
            ),
            pinned: true,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: const Color(0xFF1E2936),
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.7,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return FilmeWidget(
                  titulo: 'Filme ${index + 1}',
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}
