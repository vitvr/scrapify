// ignore_for_file: depend_on_referenced_packages, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors_in_immutables, unused_import, prefer_const_constructors

import 'dart:async';
import 'dart:math' as math;
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARScreen extends StatefulWidget {
  final snap;

  ARScreen({required this.snap});

  @override
  _ARScreenState createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  late ARKitController arKitController;
  Size? imageSize;
  bool isLoading = true;
  List contents = [];
  List images = [];
  String imageUrl = "";

  Future<void> getContents() async {
    imageUrl = widget.snap['postUrl'];
    var postStream = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .collection('pages')
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        contents.addAll(docSnapshot.data()['contents']);
      }
    });
    for (int i = 0; i < contents.length; i++) {
      if (contents[i] != null) {
        if (List.from(contents[i].split("")).take(5).toString() ==
            "(h, t, t, p, s)") {
          images.add(contents[i]);
        }
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getImageDimensions();
  }

  Future<void> _getImageDimensions() async {
    await getContents();
    final image = NetworkImage(imageUrl);
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
      diffuse: ARKitMaterialProperty.image(imageUrl),
      doubleSided: true,
    );

    var width = imageSize!.width;
    var height = imageSize!.height;
    var distance = 3.0;
    if (width > 3000 || height > 2500) {
      width = width / 1000;
      height = height / 1000;
      distance = 10.0;
    } else {
      width = width / 1000;
      height = height / 1000;
      distance = 6.0;
    }

    final plane = ARKitPlane(
      width: width,
      height: height,
      materials: [material],
    );

    // Calculate total width of image planes
    final totalImageWidth = images.length * width;

    // Calculate horizontal offset to center imageUrl plane
    final imageOffset = (totalImageWidth - width) / -2;

    // Add imageUrl plane node
    final imageUrlNode = ARKitNode(
      geometry: plane,
      position: vector.Vector3(0, 1, -distance),
      eulerAngles: vector.Vector3.zero(),
    );
    arKitController.add(imageUrlNode);

    // Add image planes nodes
    for (int i = 0; i < images.length; i++) {
      final imageMaterial = ARKitMaterial(
        lightingModelName: ARKitLightingModel.lambert,
        diffuse: ARKitMaterialProperty.image(images[i]),
        doubleSided: true,
      );

      final imagePlane = ARKitPlane(
        width: width,
        height: height,
        materials: [imageMaterial],
      );

      final imageNode = ARKitNode(
        geometry: imagePlane,
        position: vector.Vector3(imageOffset + i * width, -1, -distance),
        eulerAngles: vector.Vector3.zero(),
      );

      arKitController.add(imageNode);
    }
  }
}
