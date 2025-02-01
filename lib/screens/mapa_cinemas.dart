import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:flutter/foundation.dart' show compute;

class TelaMapa extends StatefulWidget {
  const TelaMapa({super.key});

  @override
  TelaMapaState createState() => TelaMapaState();
}

class TelaMapaState extends State<TelaMapa> {
  final List<Marker> _cinemaMarkers = [];
  final TextEditingController _cityController = TextEditingController();
  bool _isLoading = false;
  final Map<String, List<Marker>> _cache = {};
  final MapController _mapController = MapController(); // Adicionando o MapController

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _fetchCinemas(String cityName) async {
    setState(() {
      _isLoading = true;
      _cinemaMarkers.clear();
    });

    try {
      // Primeiro, busca a cidade no Brasil
      Map<String, double>? cityLocation = await compute(_fetchCityLocation, {'cityName': cityName, 'countryCode': 'BR'});

      // Se não encontrar no Brasil, busca globalmente
      if (cityLocation == null) {
        cityLocation = await compute(_fetchCityLocation, {'cityName': cityName, 'countryCode': null});
        if (cityLocation == null) {
          _showError('Cidade não encontrada!');
          return;
        }
      }

      // Movendo o mapa para a localização da cidade e ajustando o zoom
      _mapController.move(LatLng(cityLocation['lat']!, cityLocation['lon']!), 13.0);

      // Verifica se os cinemas já estão em cache
      if (_cache.containsKey(cityName)) {
        setState(() {
          _cinemaMarkers.addAll(_cache[cityName]!);
        });
      } else {
        final cinemas = await compute(_fetchCinemasInArea, cityLocation);
        setState(() {
          _cinemaMarkers.addAll(cinemas);
          _cache[cityName] = List.from(cinemas);
        });
      }
    } catch (e) {
      _showError('Erro: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  static Future<Map<String, double>?> _fetchCityLocation(Map<String, dynamic> params) async {
    final String cityName = params['cityName'];
    final String? countryCode = params['countryCode'];

    final geocodeUrl = 'https://nominatim.openstreetmap.org/search?format=json&q=$cityName&countrycodes=${countryCode ?? ''}';
    final geocodeResponse = await http.get(Uri.parse(geocodeUrl));
    if (geocodeResponse.statusCode == 200) {
      final geocodeData = jsonDecode(geocodeResponse.body);
      if (geocodeData.isEmpty) return null;
      return {
        'lat': double.parse(geocodeData[0]['lat']),
        'lon': double.parse(geocodeData[0]['lon']),
      };
    }
    return null;
  }

  static Future<List<Marker>> _fetchCinemasInArea(Map<String, double> cityLocation) async {
    const overpassUrl = 'https://overpass-api.de/api/interpreter';
    const radius = 0.1; // Raio de busca em graus (~10 km)
    final query = '''
    [out:json];
    node["amenity"="cinema"](${cityLocation['lat']! - radius},${cityLocation['lon']! - radius},${cityLocation['lat']! + radius},${cityLocation['lon']! + radius});
    out;
    ''';

    final overpassResponse = await http.post(Uri.parse(overpassUrl), body: query);
    if (overpassResponse.statusCode == 200) {
      final data = jsonDecode(overpassResponse.body);
      final elements = data['elements'] as List;
      return elements.map((e) {
        return Marker(
          point: LatLng(e['lat'], e['lon']),
          width: 40,
          height: 40,
          child: const Icon(
            Icons.movie,
            color:  Color(0xFF208BFE),
            size: 30,
          ),
        );
      }).toList();
    }
    return [];
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Digite a cidade',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_cityController.text.isNotEmpty) {
                      _fetchCinemas(_cityController.text.trim());
                    } else {
                      _showError('Por favor, digite o nome de uma cidade!');
                    }
                  },
                  child: const Text('Buscar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController, // Passando o MapController para o FlutterMap
                  options: const MapOptions(
                    initialCenter: LatLng(-14.2350, -51.9253), // Centro do Brasil
                    initialZoom: 4.0, // Zoom inicial para mostrar todo o Brasil
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                    ),
                    MarkerLayer(
                      markers: _cinemaMarkers,
                    ),
                  ],
                ),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}