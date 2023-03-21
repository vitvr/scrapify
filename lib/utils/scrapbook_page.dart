// ignore_for_file: unused_import, unnecessary_import, implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:scrapify/utils/scrapbook_painter.dart';

class ScrapbookPage extends StatefulWidget {
  const ScrapbookPage({super.key});

  @override
  State<ScrapbookPage> createState() => _ScrapbookPageState();
}

class _ScrapbookPageState extends State<ScrapbookPage> {
  List<Offset?> points = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 99, 61),
        child: const Icon(Icons.create),
        onPressed: () {},
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 5.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
          child: GestureDetector(
            onPanDown: (details) {
              setState(() {
                points.add(details.localPosition);
              });
            },
            onPanUpdate: (details) {
              setState(() {
                points.add(details.localPosition);
              });
            },
            onPanEnd: (details) {
              setState(() {
                points.add(null);
              });
            },
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              child: CustomPaint(
                painter: ScrapbookPainter(points: points),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
