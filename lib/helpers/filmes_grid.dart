import 'package:flutter/material.dart';
import 'package:filmin/helpers/filme.dart';
import 'package:filmin/helpers/ordenador.dart';

class FilmeGrid extends StatefulWidget {
  final List<FilmeWidget> filmes;
  final String tituloAppBar;

  const FilmeGrid({
    super.key,
    required this.filmes,
    required this.tituloAppBar,
  });

  @override
  FilmeGridState createState() => FilmeGridState();
}

class FilmeGridState extends State<FilmeGrid> {
  late List<FilmeWidget> _filmesOrdenados;

  @override
  void initState() {
    super.initState();
    _filmesOrdenados = widget.filmes;
    _ordenarFilmes('dataLancamentoRecente');
  }

  void _ordenarFilmes(String criterio) {
    setState(() {
      final ordenador = Ordenador();
      final filmesMap = _filmesOrdenados
          .map((filme) => {
                'poster_path': filme.posterPath,
                'id': filme.movieId,
                'runtime': filme.runtime,
                'release_date': filme.releaseDate,
                'dateAdded': filme.dateAdded, // Add dateAdded field
              })
          .toList();

      final filmesOrdenadosMap = ordenador.ordenar(filmesMap, criterio);
      _filmesOrdenados = filmesOrdenadosMap
          .map((filme) => FilmeWidget(
                posterPath: filme['poster_path'],
                movieId: filme['id'],
                runtime: filme['runtime'],
                releaseDate: filme['release_date'],
                dateAdded: filme['dateAdded'], // Add dateAdded field
              ))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.tituloAppBar,
          style: TextStyle(
              color: const Color(0xFFAEBBC9), fontSize: screenHeight * 0.025),
        ),
        backgroundColor: const Color(0xFF161E27),
        iconTheme: const IconThemeData(
          color: Color(0xFFAEBBC9),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: _ordenarFilmes,
            color: const Color(0xFF1E2936),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'dataAdicaoAntiga',
                  child: Text('Data de Adição - Antigos', style: TextStyle(color: Color(0xFF788EA5))),
                ),
                const PopupMenuItem<String>(
                  value: 'dataAdicaoRecente',
                  child: Text('Data de Adição - Recentes', style: TextStyle(color: Color(0xFF788EA5))),
                ),
                const PopupMenuItem<String>(
                  value: 'dataLancamentoAntiga',
                  child: Text('Data de Lançamento - Antigos', style: TextStyle(color: Color(0xFF788EA5))),
                ),
                const PopupMenuItem<String>(
                  value: 'dataLancamentoRecente',
                  child: Text('Data de Lançamento - Recentes', style: TextStyle(color: Color(0xFF788EA5))),
                ),
                const PopupMenuItem<String>(
                  value: 'duracaoMenor',
                  child: Text('Duração - Curtos', style: TextStyle(color: Color(0xFF788EA5))),
                ),
                const PopupMenuItem<String>(
                  value: 'duracaoMaior',
                  child: Text('Duração - Longos', style: TextStyle(color: Color(0xFF788EA5))),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.7,
                crossAxisSpacing: screenWidth * 0.01,
                mainAxisSpacing: screenHeight * 0.01,
              ),
              itemCount: _filmesOrdenados.length,
              itemBuilder: (context, index) {
                return _filmesOrdenados[index];
              },
            ),
          ),
        ],
      ),
    );
  }
}
