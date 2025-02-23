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

    try {
      await _reviewService.updateReview(widget.reviewId, newContent); // Ajuste conforme necessário
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Crítica atualizada com sucesso'),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar crítica: $e'),
        ),
      );
    }
  }

  void _deleteCritica() async {
    try {
      await _reviewService.deleteReview(widget.reviewId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Crítica excluída com sucesso'),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir crítica: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar/Excluir Crítica'),
        backgroundColor: const Color(0xFF161E27),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Edite sua crítica aqui...',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _updateCritica,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF208BFE),
                  ),
                  child: const Text('Atualizar'),
                ),
                ElevatedButton(
                  onPressed: _deleteCritica,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Excluir'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}