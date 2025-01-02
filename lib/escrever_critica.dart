import 'package:flutter/material.dart';

class TelaEscreverCritica extends StatefulWidget {
  @override
  _TelaEscreverCriticaState createState() => _TelaEscreverCriticaState();
}

class _TelaEscreverCriticaState extends State<TelaEscreverCritica> {
  String? _selectedMovie;
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderlined = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escrever Crítica'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Título do Filme',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: _selectedMovie,
              hint: Text('Selecione o título do filme',
                  style: TextStyle(color: Colors.white)),
              items:
                  <String>['Filme 1', 'Filme 2', 'Filme 3'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedMovie = newValue;
                });
              },
            ),
            SizedBox(height: 16),
            Text(
              'Sua Crítica',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 8),
            Expanded(
              child: TextField(
                maxLines: null,
                expands: true,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                  decoration: _isUnderlined
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Escreva sua crítica aqui',
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.format_bold,
                      color: _isBold
                          ? const Color.fromARGB(255, 1, 4, 156)
                          : Colors.white),
                  onPressed: () {
                    setState(() {
                      _isBold = !_isBold;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.format_italic,
                      color: _isItalic
                          ? const Color.fromARGB(255, 1, 4, 251)
                          : Colors.white),
                  onPressed: () {
                    setState(() {
                      _isItalic = !_isItalic;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.format_underline,
                      color: _isUnderlined
                          ? const Color.fromARGB(255, 1, 4, 251)
                          : Colors.white),
                  onPressed: () {
                    setState(() {
                      _isUnderlined = !_isUnderlined;
                    });
                  },
                ),
              ],
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para salvar a crítica
                },
                child: Text('Salvar Crítica'),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 32, 32, 35),
    );
  }
}
