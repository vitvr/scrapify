import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const LatLng currentLocation = LatLng(25.102288819629432, 55.162227475793415);

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: GoogleMap(
      initialCameraPosition: CameraPosition(
        target: currentLocation,
        zoom: 14,
      ),
    ));
  }
}
