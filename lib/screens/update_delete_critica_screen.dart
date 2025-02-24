import 'package:flutter/material.dart';
import 'package:filmin/services/review_service.dart';

class UpdateDeleteCriticaScreen extends StatefulWidget {
  final String reviewId;
  final String initialContent;

  const UpdateDeleteCriticaScreen({
    required this.reviewId,
    required this.initialContent,
    super.key,
  });

  @override
  _UpdateDeleteCriticaScreenState createState() => _UpdateDeleteCriticaScreenState();
}

class _UpdateDeleteCriticaScreenState extends State<UpdateDeleteCriticaScreen> {
  final TextEditingController _controller = TextEditingController();
  final ReviewService _reviewService = ReviewService();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialContent;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateCritica() async {
    final newContent = _controller.text;
    if (newContent.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'a crítica não pode estar vazia',
            style: TextStyle(color: Color(0xFFF1F3F5)),
          ),
          backgroundColor: Color(0xFFF52958),
        ),
      );
      return;
    }

    try {
      await _reviewService.updateReview(widget.reviewId, newContent); // Ajuste conforme necessário
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'crítica atualizada com sucesso',
            style: TextStyle(color: Color(0xFFF1F3F5)),
          ),
          backgroundColor: Color(0xFF208BFE),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao atualizar crítica: $e',
            style: TextStyle(color: Color(0xFFF1F3F5)),
          ),
          backgroundColor: Color(0xFFF52958),
        ),
      );
    }
  }

  void _deleteCritica() async {
    try {
      await _reviewService.deleteReview(widget.reviewId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'crítica excluída com sucesso',
            style: TextStyle(color: Color(0xFFF1F3F5)),
          ),
          backgroundColor: Color(0xFF208BFE),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao excluir crítica: $e',
            style: TextStyle(color: Color(0xFFF1F3F5)),
          ),
          backgroundColor: Color(0xFFF52958),
        ),
      );
    }
  }

  @override
Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Editar e Excluir Crítica",
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
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    decoration: TextDecoration.none,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterStyle: TextStyle(color: Color(0xFFAEBBC9)),
                    hintStyle: TextStyle(color: Color(0xFF788EA5)),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _updateCritica,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF208BFE),
                    foregroundColor: const Color(0xFFF1F3F5),
                  ),
                  child: const Text('Atualizar Crítica'),
                ),
                ElevatedButton(
                  onPressed: _deleteCritica,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF52958),
                    foregroundColor: const Color(0xFFF1F3F5),
                  ),
                  child: const Text('Excluir Crítica'),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF161E27),
    );
  }
}