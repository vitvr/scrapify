import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:scrapify/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scrapify/utils/post.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  // Default coordinates (HWUD)
  static final LatLng defaultLocation =
      LatLng(25.102288819629432, 55.162327475793415);
  // Coordinates to update when interactions happen
  static LatLng currentLocation = defaultLocation;

  // A Controller for Google Maps
  Completer<GoogleMapController> _controller = Completer();
  // A Controller for user input (search)
  TextEditingController _searchController = TextEditingController();
  // A set of markers to display on the map
  Map<String, Marker> _markers = {};
  // Default camera position on the map
  static late CameraPosition _defaultCameraPosition;
  // A Position that may be defined later
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _defaultCameraPosition = CameraPosition(target: defaultLocation, zoom: 14);
    _getCurrentPosition();
  }

  void _setMarker(LatLng point) {
    setState(() {
      addMarker("main", point); //"Current ", "test1");
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    EasyLoading.show(status: "Loading...");
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position1) {
      currentLocation = LatLng(position1.latitude, position1.longitude);
      _setMarker(currentLocation);
      _defaultCameraPosition =
          CameraPosition(target: currentLocation, zoom: 14);
      _currentPosition = position1;
    }).catchError((e) {
      debugPrint(e);
    });

    EasyLoading.dismiss();
  }

  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12)));

    _setMarker(LatLng(lat, lng));
  }

  addMarker(
      String id, LatLng location /*, String markerTitle, String desc*/) async {
    var marker = Marker(
        markerId: MarkerId(id),
        position: location,
        // infoWindow: InfoWindow(title: markerTitle, snippet: desc),
        icon: BitmapDescriptor.defaultMarkerWithHue(12));
    _markers[id] = marker;
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Image(
            image: AssetImage('assets/mainLogoNoLogo.png'), height: 35),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notification_add_outlined),
          ),
        ],
      ),
      body: SlidingUpPanel(
        minHeight: deviceSize.height * 0.18,
        maxHeight: deviceSize.height * 0.5,
        body: Column(
          children: [
            Container(
              height: deviceSize.height * 0.62 + 4,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: GoogleMap(
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                onCameraMove: (CameraPosition position) {
                  currentLocation = LatLng(
                      position.target.latitude, position.target.longitude);
                  _setMarker(currentLocation);
                },
                mapType: MapType.normal,
                initialCameraPosition: _MapScreenState._defaultCameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: _markers.values.toSet(),
              ),
            )
          ],
        ),
        panelBuilder: (controller) => PanelWidget(
          controller: controller,
        ),
        header: Container(
          height: deviceSize.height * 0.18,
          width: deviceSize.width,
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ]),
          child: Column(children: [
            Container(
              height: deviceSize.height * 0.04,
              padding: EdgeInsets.fromLTRB(
                  0, deviceSize.height * 0.0125, 0, deviceSize.height * 0.02),
              child: buildDragHandle(),
            ),
            Container(
                height: deviceSize.height * 0.14,
                width: deviceSize.width,
                padding: EdgeInsets.only(left: deviceSize.width * 0.075),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Enter a location: ",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          controller: _searchController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                              hintText:
                                  "Places of interest, cities, states, etc."),
                        )),
                        IconButton(
                            onPressed: () async {
                              var place = await LocationService()
                                  .getPlace(_searchController.text);
                              _goToPlace(place);
                            },
                            icon: const Icon(Icons.search))
                      ],
                    )
                  ],
                )),
          ]),
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        parallaxEnabled: true,
        parallaxOffset: 0.5,
      ),
    );
  }
}

class PanelWidget extends StatelessWidget {
  final ScrollController controller;

  int _count = 0;

  void _update(int count) {}

  PanelWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  Widget buildFeed() => Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SafeArea(
            child: StreamBuilder(
              stream: getNearbyResults(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.width.toDouble() * 0.019),
                  itemCount: snapshot.data!.docs.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 13,
                    );
                  },
                  itemBuilder: (context, index) {
                    return Flexible(
                      child: PostCard(
                        snap: snapshot.data!.docs[index].data(),
                        update: _update,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ));

  @override
  Widget build(BuildContext context) => ListView(
        padding: EdgeInsets.zero,
        controller: controller,
        children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          buildFeed(),
          SizedBox(height: 24),
        ],
      );
}

Widget buildDragHandle() => Center(
      child: Container(
        width: 50,
        height: 5,
        decoration: BoxDecoration(
            color: CustomColors().lightTextInput,
            borderRadius: BorderRadius.circular(12)),
      ),
    );

Stream<QuerySnapshot<Map<String, dynamic>>>? getNearbyResults() {
  Stream<QuerySnapshot<Map<String, dynamic>>>? rawResults = FirebaseFirestore
      .instance
      .collection('posts')
      .orderBy('datePublished', descending: true)
      .snapshots();

  // TODO: ADD LOGIC TO FILTER NEAREST LOCATIONS

  return rawResults;
}

double haversineDistance(
    {required double lat1,
    required double lat2,
    required double long1,
    required double long2}) {
  const radius = (6378137 + 6357852.3) / 2;
  double latDelta = _toRadians(lat1 - lat2);
  double longDelta = _toRadians(long1 - long2);

  double a = (sin(latDelta / 2) * sin(latDelta / 2)) +
      (cos(_toRadians(lat1)) *
          cos(_toRadians(lat2)) *
          sin(longDelta / 2) *
          sin(longDelta / 2));
  double distance = radius * 2 * atan2(sqrt(a), sqrt(1 - a)) / 1000;
  return double.parse(distance.toStringAsFixed(3));
}

double _toRadians(double num) {
  return num * (pi / 180.0);
}

class LocationService {
  final String key = 'AIzaSyA7f8dT30Z8ZPGBKGxWd-768yqlfcHiXnE';
  Future<String> getPlaceId(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var placeId = json['candidates'][0]['place_id'] as String;
    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;
    return results;
  }
}
