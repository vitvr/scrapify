// ignore_for_file: prefer_const_constructors, unused_import, depend_on_referenced_packages, library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'dart:async';
import 'dart:math' as math;
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARScreen extends StatefulWidget {
  final String imageUrl;

  ARScreen({required this.imageUrl});

  @override
  _ARScreenState createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  late ARKitController arKitController;
  Size? imageSize;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getImageDimensions();
  }

  Future<void> _getImageDimensions() async {
    final image = NetworkImage(widget.imageUrl);
    final completer = Completer<Size>();
    image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(
          Size(info.image.width.toDouble(), info.image.height.toDouble()),
        );
      }),
    );
    imageSize = await completer.future;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back_outlined),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: ARKitSceneView(
        onARKitViewCreated: _onARKitViewCreated,
        enableTapRecognizer: true,
      ),
    );
  }

  void _onARKitViewCreated(ARKitController controller) {
    arKitController = controller;

    if (imageSize == null) {
      return;
    }

    final material = ARKitMaterial(
      lightingModelName: ARKitLightingModel.lambert,
      diffuse: ARKitMaterialProperty.image(widget.imageUrl),
      doubleSided: true,
    );

    final plane = ARKitPlane(
      width: imageSize!.width / 1000,
      height: imageSize!.height / 1000,
      materials: [material],
    );

    final node = ARKitNode(
      geometry: plane,
      position: vector.Vector3(0, 0, -3),
      eulerAngles: vector.Vector3.zero(),
    );

    arKitController.add(node);
  }

  @override
  void dispose() {
    arKitController.dispose();
    super.dispose();
  }
}
