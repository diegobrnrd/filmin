import 'dart:convert';
import 'package:filmin/secrets.dart';
import 'package:http/http.dart' as http;

class Controlador {
  final String _apiKey = apiKey;
  final String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<dynamic>> buscarFilmes(String query) async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/search/movie?api_key=$_apiKey&query=$query&region=BR&language=pt-BR'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<Map<String, dynamic>> buscarDetalhesFilme(int movieId) async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl/movie/$movieId?api_key=$_apiKey&language=pt-BR&append_to_response=credits'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<List<dynamic>> buscarFilmesEmCartaz() async {
    List<dynamic> filmesEmCartaz = [];
    int page = 1;

    while (filmesEmCartaz.length < 6) {
      final response = await http.get(Uri.parse(
          '$_baseUrl/movie/now_playing?api_key=$_apiKey&language=pt-BR&sort_by=popularity.desc&page=$page'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final filmes = data['results']
            .where((filme) =>
                filme['original_language'] == 'pt' &&
                filme['poster_path'] != null &&
                !filmesEmCartaz
                    .any((existingFilme) => existingFilme['id'] == filme['id']))
            .toList();
        filmesEmCartaz.addAll(filmes);

        if (data['total_pages'] == page) {
          break;
        }
        page++;
      } else {
        throw Exception('Failed to load now playing movies');
      }
    }

    return filmesEmCartaz.take(6).toList();
  }
}
