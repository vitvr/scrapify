import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
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
      body: SlidingUpPanel(
        minHeight: MediaQuery.of(context).size.height * 0.2,
        maxHeight: MediaQuery.of(context).size.height * 0.5,
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _defaultCameraPosition,
          onMapCreated: (controller) {
            _mapController = controller;
            addMarker(
                "test1", currentLocation, "ScrapifyAR1", "ScrapifyARTest1");
            addMarker(
                "test2", currentLocation2, "ScrapifyAR2", "ScrapifyARTest2");
          },
          markers: _markers.values.toSet(),
        ),
        panelBuilder: (controller) => PanelWidget(
          controller: controller,
        ),
      ),
    );
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

class PanelWidget extends StatelessWidget {
  final ScrollController controller;

  const PanelWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView(
        padding: EdgeInsets.zero,
        controller: controller,
        children: <Widget>[
          SizedBox(height: 36),
          buildAboutText(),
          SizedBox(height: 24),
        ],
      );

  Widget buildAboutText() => Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'About',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12),
          Text(
              '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas ultricies sem sit amet purus venenatis hendrerit. Aenean pulvinar auctor volutpat. Vivamus non nibh nisi. Aliquam aliquet magna sit amet libero sollicitudin imperdiet. Aenean vitae massa sed eros blandit pellentesque. Etiam elit arcu, pharetra nec velit quis, consectetur iaculis ligula. Aenean ac sagittis odio. Sed at interdum arcu. Vivamus dignissim augue nec velit auctor pulvinar. Vestibulum aliquet odio risus, at tempor orci fermentum pulvinar. Donec a placerat urna. Ut sed magna sed neque pulvinar faucibus.

Morbi id sodales mi, euismod tempus justo. Mauris non consequat ex, et blandit arcu. Ut in lacinia elit. Nunc id efficitur leo, vitae scelerisque elit. Nulla varius in arcu nec consectetur. Aliquam dictum, purus non finibus volutpat, velit nunc cursus neque, at congue lorem orci vel metus. Vivamus tortor purus, auctor vitae lobortis sed, dictum quis mauris. Ut tempor vel lacus a venenatis. Nam sit amet blandit mi. Quisque vel neque eu odio condimentum porta eget vitae sapien. Sed non mauris volutpat, faucibus metus ac, congue nibh. Donec id nunc sapien.''')
        ],
      ));
}
