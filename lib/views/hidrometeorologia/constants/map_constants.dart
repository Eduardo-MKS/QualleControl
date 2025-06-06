import 'package:latlong2/latlong.dart';

class MapConstants {
  // Coordenadas de Santa Catarina
  static const LatLng scCenter = LatLng(-27.5954, -48.5480);

  // Configurações de zoom
  static const double initialZoom = 7.0;
  static const double minZoom = 5.0;
  static const double maxZoom = 18.0;

  // Configurações do tile
  static const String tileUrlTemplate =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String userAgentPackageName = 'com.example.hidrometeorologia';
}
