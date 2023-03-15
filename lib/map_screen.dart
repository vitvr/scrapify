import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const LatLng currentLocation =
      LatLng(25.102288819629432, 55.162327475793415);
  static const LatLng currentLocation2 =
      LatLng(25.102288819629432, 55.262427475793415);
  late GoogleMapController _mapController;
  Map<String, Marker> _markers = {};

  static final CameraPosition _defaultCameraPosition =
      CameraPosition(target: currentLocation, zoom: 14);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _defaultCameraPosition,
      onMapCreated: (controller) {
        _mapController = controller;
        addMarker("test1", currentLocation, "ScrapifyAR1", "ScrapifyARTest1");
        addMarker("test2", currentLocation2, "ScrapifyAR2", "ScrapifyARTest2");
      },
      markers: _markers.values.toSet(),
    ));
  }

  addMarker(String id, LatLng location, String markerTitle, String desc) async {
    var marker = Marker(
        markerId: MarkerId(id),
        position: location,
        infoWindow: InfoWindow(title: markerTitle, snippet: desc),
        icon: BitmapDescriptor.defaultMarkerWithHue(12));
    _markers[id] = marker;
    setState(() {});
  }
}
