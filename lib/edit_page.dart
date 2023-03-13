import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  List cols = [
    Colors.red,
    Colors.blue,
    Colors.amber,
    Colors.white,
    Colors.black,
    Colors.green,
  ]

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(color: cols[index])
        }
      ),
    );
  }
}
