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
  final MapController _mapController = MapController();
  bool _isDarkMode = false;

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
      Map<String, double>? cityLocation = await compute(_fetchCityLocation, {'cityName': cityName, 'countryCode': 'BR'});

      if (cityLocation == null) {
        cityLocation = await compute(_fetchCityLocation, {'cityName': cityName, 'countryCode': null});
        if (cityLocation == null) {
          _showError('Cidade não encontrada!');
          return;
        }
      }

      _mapController.move(LatLng(cityLocation['lat']!, cityLocation['lon']!), 13.0);

      if (_cache.containsKey(cityName)) {
        setState(() {
          _cinemaMarkers.addAll(_cache[cityName]!);
        });
      } else {
        final cinemas = await compute(_fetchCinemasInArea, {'cityLocation': cityLocation, 'context': context});
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
    final geocodeResponse = await http.get(
      Uri.parse(geocodeUrl),
      headers: {'User-Agent': 'YourAppName/1.0 (your@email.com)'},
    );

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

  static Future<List<Marker>> _fetchCinemasInArea(Map<String, dynamic> params) async {
    final Map<String, double> cityLocation = params['cityLocation'];
    final BuildContext context = params['context'];

    const overpassUrl = 'https://overpass-api.de/api/interpreter';
    const radius = 0.2; // Aumente o raio de busca
    final query = '''
    [out:json];
    node["amenity"="cinema"](${cityLocation['lat']! - radius},${cityLocation['lon']! - radius},${cityLocation['lat']! + radius},${cityLocation['lon']! + radius});
    out;
    ''';

    final overpassResponse = await http.post(
      Uri.parse(overpassUrl),
      body: query,
      headers: {'Content-Type': 'text/plain; charset=utf-8'},
    );

    if (overpassResponse.statusCode == 200) {
      final data = jsonDecode(utf8.decode(overpassResponse.bodyBytes));
      final elements = data['elements'] as List;
      return await Future.wait(elements.map((e) async {
        final cinemaName = e['tags']['name'] ?? 'Cinema Desconhecido';
        final address = await _fetchNearestAddress(LatLng(e['lat'], e['lon']));
        return Marker(
          point: LatLng(e['lat'], e['lon']),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CinemaDetailsScreen(
                    cinemaName: cinemaName,
                    address: address,
                  ),
                ),
              );
            },
            child: const Icon(
              Icons.movie,
              color: Color(0xFF208BFE),
              size: 30,
            ),
          ),
        );
      }));
    }
    return [];
  }

  static Future<String> _fetchNearestAddress(LatLng point) async {
    final reverseGeocodeUrl = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=${point.latitude}&lon=${point.longitude}&zoom=18&addressdetails=1';
    try {
      final response = await http.get(
        Uri.parse(reverseGeocodeUrl),
        headers: {'User-Agent': 'YourAppName/1.0 (your@email.com)'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final address = data['address'] as Map<String, dynamic>;
        final street = address['road'] ?? '';
        final housenumber = address['house_number'] ?? '';
        final city = address['city'] ?? address['town'] ?? address['village'] ?? '';
        final postcode = address['postcode'] ?? '';

        final addressParts = [street, housenumber, city, postcode];
        return addressParts.where((part) => part.isNotEmpty).join(', ');
      } else {
        print('Erro na requisição: ${response.statusCode}');
        return 'Endereço não disponível';
      }
    } catch (e) {
      print('Exceção ao buscar endereço: $e');
      return 'Endereço não disponível';
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
    setState(() {
      _isLoading = false;
    });
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
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
                  child: _buildTextField(
                    'Digite a cidade',
                    controller: _cityController,
                    fillColor: const Color(0xFF1E2936),
                    textColor: const Color(0xFF788EA5),
                    focusedTextColor: const Color(0xFF208BFE),
                    inputTextColor: const Color(0xFFF1F3F5),
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
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color(0xFFF1F3F5),
                    backgroundColor: Color(0xFF208BFE),
                  ),
                  child: const Text('Buscar'),
                ),
                IconButton(
                  icon: Icon(
                    _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: Colors.white,
                  ),
                  onPressed: _toggleDarkMode,
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: const MapOptions(
                    initialCenter: LatLng(-14.2350, -51.9253),
                    initialZoom: 4.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: _isDarkMode
                          ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png'
                          : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                      subdomains: const ['a', 'b', 'c'],
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

  Widget _buildTextField(String label,
      {required TextEditingController controller,
        bool obscureText = false,
        Color fillColor = Colors.transparent,
        Color textColor = Colors.black,
        Color focusedTextColor = Colors.black,
        Color inputTextColor = Colors.black,
        Widget? suffixIcon}) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (hasFocus) {}
      },
      child: Builder(
        builder: (context) {
          final isFocused = Focus.of(context).hasFocus;
          return TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              labelStyle:
              TextStyle(color: isFocused ? focusedTextColor : textColor),
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: fillColor,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF2E4052)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF208BFE)),
              ),
              suffixIcon: suffixIcon,
            ),
            obscureText: obscureText,
            style: TextStyle(color: inputTextColor),
          );
        },
      ),
    );
  }
}

class CinemaDetailsScreen extends StatelessWidget {
  final String cinemaName;
  final String address;

  const CinemaDetailsScreen({
    super.key,
    required this.cinemaName,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Cinema'),
        foregroundColor:  const Color(0xFF788EA5),
        backgroundColor: const Color(0xFF2E4052),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cinemaName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF788EA5),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Endereço: $address',
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF788EA5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}