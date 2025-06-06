import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../constants/map_constants.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: MapConstants.scCenter,
        initialZoom: MapConstants.initialZoom,
        minZoom: MapConstants.minZoom,
        maxZoom: MapConstants.maxZoom,
      ),
      children: [
        TileLayer(
          urlTemplate: MapConstants.tileUrlTemplate,
          userAgentPackageName: MapConstants.userAgentPackageName,
          maxZoom: MapConstants.maxZoom,
        ),
        // Controles de zoom
        Positioned(
          top: 20,
          right: 20,
          child: Column(
            children: [
              FloatingActionButton.small(
                heroTag: "zoom_in",
                onPressed: () {
                  // TODO: Implementar zoom in
                },
                backgroundColor: Colors.white,
                child: const Icon(Icons.add, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              FloatingActionButton.small(
                heroTag: "zoom_out",
                onPressed: () {
                  // TODO: Implementar zoom out
                },
                backgroundColor: Colors.white,
                child: const Icon(Icons.remove, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
