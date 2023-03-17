import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:scrapify/edit_page.dart';
import 'package:scrapify/utils/colors.dart';

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
    var ss;
    try {
      DocumentSnapshot s = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('pages')
          .doc(page.toString())
          .get();
      ss = s.data() as Map<String, dynamic>;
    } catch (e) {
      print('error');
      page--;
      setState(() {});
      return;
    }
    if (ss['contents'] == null) {
      contents = [null, null, null, null, null, null];
    } else {
      contents = await ss['contents'];
    }
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
      } else if (List.from(contents[i].split("")).take(5).toString() ==
          "(h, t, t, p, s)") {
        // print(List.from(contents[i].split("")).take(5).toString());
        showImage[i] = Image(
          image: NetworkImage(contents[i]!),
          fit: BoxFit.cover,
        );
      } else {
        showImage[i] = Center(child: Text(contents[i]));
      }
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditPage(
                snap: widget.snap,
                page: page,
              ),
            ),
          );
          received = false;
          getContents();
        },
      ),
      body: Container(
        color: CustomColors().extremelyLight,
        child: Column(
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Container(
                color: CustomColors().lighter,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        page--;
                        received = false;
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.arrow_left,
                      ),
                      iconSize: MediaQuery.of(context).size.width * 0.1,
                    ),
                    Text('Page: ' + page.toString()),
                    IconButton(
                      onPressed: () {
                        page++;
                        received = false;
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.arrow_right,
                      ),
                      iconSize: MediaQuery.of(context).size.width * 0.1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
