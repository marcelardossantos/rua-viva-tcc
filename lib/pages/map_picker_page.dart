import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPickerResult {
  final double lat;
  final double lon;

  const MapPickerResult({
    required this.lat,
    required this.lon,
  });
}

class MapPickerPage extends StatefulWidget {
  final double initialLat;
  final double initialLon;

  const MapPickerPage({
    super.key,
    required this.initialLat,
    required this.initialLon,
  });

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  late final MapController _mapController;
  late LatLng _current;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _current = LatLng(widget.initialLat, widget.initialLon);
  }

  void _onTap(TapPosition tapPosition, LatLng latLng) {
    setState(() {
      _current = latLng;
    });
  }

  void _confirm() {
    Navigator.of(context).pop(
      MapPickerResult(
        lat: _current.latitude,
        lon: _current.longitude,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolher localização'),
      ),
      body: Column(
        children: [
          // 🗺 mapa ocupando a tela
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _current,
                initialZoom: 16,
                onTap: _onTap,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.rua_mvp',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _current,
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.location_on,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // coordenadas atuais
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                Text('Lat: ${_current.latitude.toStringAsFixed(5)}'),
                Text('Lon: ${_current.longitude.toStringAsFixed(5)}'),
              ],
            ),
          ),
          // botão confirmar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _confirm,
                child: const Text('Confirmar'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
