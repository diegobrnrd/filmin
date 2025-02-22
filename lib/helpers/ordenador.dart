import 'package:cloud_firestore/cloud_firestore.dart';

class Ordenador {
  List<Map<String, dynamic>> ordenar(List<Map<String, dynamic>> filmes, String criterio) {
    switch (criterio) {
      case 'dataAdicaoRecente':
        filmes.sort((a, b) => (b['dateAdded'] as Timestamp).toDate().compareTo((a['dateAdded'] as Timestamp).toDate()));
        break;
      case 'dataAdicaoAntiga':
        filmes.sort((a, b) => (a['dateAdded'] as Timestamp).toDate().compareTo((b['dateAdded'] as Timestamp).toDate()));
        break;
      case 'dataLancamentoRecente':
        filmes.sort((a, b) => b['release_date'].compareTo(a['release_date']));
        break;
      case 'dataLancamentoAntiga':
        filmes.sort((a, b) => a['release_date'].compareTo(b['release_date']));
        break;
      case 'duracaoMenor':
        filmes.sort((a, b) => a['runtime'].compareTo(b['runtime']));
        break;
      case 'duracaoMaior':
        filmes.sort((a, b) => b['runtime'].compareTo(a['runtime']));
        break;
      default:
        throw ArgumentError('Critério de ordenação desconhecido: $criterio');
    }
    return filmes;
  }
}