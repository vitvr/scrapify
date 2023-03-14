import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ViewPage extends StatefulWidget {
  final snap;
  ViewPage({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  bool received = false;
  int page = 0;

  List contents = [
    null,
    null,
    null,
    null,
    null,
    null,
  ];

  List cols = [
    Colors.red,
    Colors.blue,
    Colors.amber,
    Colors.white,
    Colors.black,
    Colors.green,
  ];

  List<Uint8List?> files = [
    null,
    null,
    null,
    null,
    null,
    null,
  ];

  Future<void> getContents() async {
    if (received) {
      return;
    }
    DocumentSnapshot s = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .collection('pages')
        .doc(page.toString())
        .get();
    var ss = s.data() as Map<String, dynamic>;
    contents = await ss['contents'];
    received = true;
    setState(() {});
    print(contents);
  }

  @override
  Widget build(BuildContext context) {
    getContents();

    List<Widget> showImage = [
      Container(),
      Container(),
      Container(),
      Container(),
      Container(),
      Container(),
    ];

    for (int i = 0; i < 6; i++) {
      if (contents[i] == null) {
        showImage[i] = Container();
      } else {
        showImage[i] = Image(
          image: NetworkImage(contents[i]!),
          fit: BoxFit.cover,
        );
        // showImage[i] = SizedBox(
        //   height: 20,
        //   width: 20,
        //   child: Container(
        //     color: Colors.black,
        //   ),
        // );
      }
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: showImage[0],
                ),
                Expanded(
                  child: showImage[1],
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Stack(
                    fit: StackFit.passthrough,
                    alignment: Alignment.center,
                    children: [
                      Expanded(
                        child: showImage[2],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    fit: StackFit.passthrough,
                    alignment: Alignment.center,
                    children: [
                      Expanded(
                        child: showImage[3],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Stack(
                    fit: StackFit.passthrough,
                    alignment: Alignment.center,
                    children: [
                      Expanded(
                        child: showImage[4],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    fit: StackFit.passthrough,
                    alignment: Alignment.center,
                    children: [
                      Expanded(
                        child: showImage[5],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
