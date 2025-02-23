import 'package:flutter/material.dart';
import 'dart:math';

class TelaEscreverCritica extends StatefulWidget {
  final String movieTitle;
  final String posterUrl;

  const TelaEscreverCritica({
    required this.movieTitle,
    required this.posterUrl,
    super.key,
  });

  @override
  _TelaEscreverCriticaState createState() => _TelaEscreverCriticaState();
}

class _TelaEscreverCriticaState extends State<TelaEscreverCritica> {
  final TextEditingController _controller = TextEditingController();
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderlined = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TextStyle _getTextStyle() {
    return TextStyle(
      fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
      decoration:
          _isUnderlined ? TextDecoration.underline : TextDecoration.none,
      color: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escrever Crítica'),backgroundColor: const Color(0xFF161E27)
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MovieSection(
              movieTitle: widget.movieTitle,
              posterUrl: widget.posterUrl,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  style: _getTextStyle(),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Escreva sua crítica aqui...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.format_bold,
                    color: _isBold ? Colors.blue : Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isBold = !_isBold;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.format_italic,
                    color: _isItalic ? Colors.blue : Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isItalic = !_isItalic;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.format_underline,
                    color: _isUnderlined ? Colors.blue : Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isUnderlined = !_isUnderlined;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _saveCritica,
                child: const Text('Salvar Crítica'),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF161E27),
    );
  }

  void _saveCritica() {
    final plainText = _controller.text;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Crítica salva: ${plainText.substring(0, min(30, plainText.length))}...',
        ),
      ),
    );
  }
}

class MovieSection extends StatelessWidget {
  final String movieTitle;
  final String posterUrl;

  const MovieSection({
    required this.movieTitle,
    required this.posterUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.network(
          posterUrl,
          width: 100,
          height: 150,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            movieTitle,
            style: const TextStyle(fontSize: 18, color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
