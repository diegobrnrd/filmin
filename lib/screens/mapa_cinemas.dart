import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TelaMapa extends StatelessWidget {
  const TelaMapa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cinemas em Pernambuco",
          style: TextStyle(color: Color(0xFFAEBBC9)),
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
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(-8.0476, -34.8770),
          initialZoom: 13.0,
        ),
        children: [
          openStreetMapTileLayer,
        ],
      ),
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: 'https://.tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example'
    );
