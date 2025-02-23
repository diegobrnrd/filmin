import 'package:flutter/material.dart';
import 'package:filmin/services/critics_service.dart';

class TelaEscreverCritica extends StatefulWidget {
  final String movieTitle;
  final String posterUrl;
  final int movieId;
  final int ano;

  const TelaEscreverCritica({
    required this.movieTitle,
    required this.posterUrl,
    required this.movieId,
    required this.ano,
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
  final ReviewService _reviewService = ReviewService();

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Escrever Crítica',
          style: TextStyle(
              color: const Color(0xFFAEBBC9),
              fontSize: screenHeight * 0.025),
        ),
        backgroundColor: const Color(0xFF161E27),
        iconTheme: const IconThemeData(
          color: Color(0xFFAEBBC9),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MovieSection(
              movieTitle: widget.movieTitle,
              posterUrl: widget.posterUrl,
              movieId: widget.movieId,
              ano: widget.ano,
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF1E2936)),
                  borderRadius: BorderRadius.circular(screenWidth * 0.01),
                ),
                padding: EdgeInsets.all(screenWidth * 0.025),
                child: TextField(
                  controller: _controller,
                  maxLength: 3500,
                  maxLines: null,
                  style: _getTextStyle(),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Escreva sua crítica aqui...',
                    counterStyle: TextStyle(color: Color(0xFFAEBBC9)),
                    hintStyle: TextStyle(color: Color(0xFF788EA5)),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.format_bold,
                    color: _isBold ? const Color(0xFF208BFE) : const Color(0xFF788EA5),
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
                    color: _isItalic ? const Color(0xFF208BFE) : const Color(0xFF788EA5),
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
                    color: _isUnderlined ? const Color(0xFF208BFE) : const Color(0xFF788EA5),
                  ),
                  onPressed: () {
                    setState(() {
                      _isUnderlined = !_isUnderlined;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            Center(
                child: ElevatedButton(
                  onPressed: _saveCritica,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF208BFE), // Cor do fundo
                    foregroundColor: const Color(0xFFF1F3F5), // Cor da letra
                  ),
                  child: const Text('Salvar Crítica'),
                )
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF161E27),
    );
  }

  void _saveCritica() async {
    final plainText = _controller.text;

    try {
      await _reviewService.addReview(
        widget.movieId.toString(),
        plainText,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'crítica salva com sucesso',
            style: TextStyle(color: Color(0xFFF1F3F5)),
          ),
          backgroundColor: Color(0xFF208BFE),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar crítica: $e'),
        ),
      );
    }
  }
}

class MovieSection extends StatelessWidget {
  final String movieTitle;
  final String posterUrl;
  final int movieId;
  final int ano;

  const MovieSection({
    required this.movieTitle,
    required this.posterUrl,
    required this.movieId,
    required this.ano,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Row(
      children: [
        Image.network(
          posterUrl,
          width: screenWidth * 0.25,
          height: screenHeight * 0.2,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movieTitle,
                style: TextStyle(fontSize: screenWidth * 0.045, color: Color(0xFFAEBBC9)),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                ano.toString(),
                style: TextStyle(fontSize: screenWidth * 0.035, color: Color(0xFFAEBBC9)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}