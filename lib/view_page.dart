import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:scrapify/edit_page.dart';
import 'package:scrapify/utils/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:uuid/uuid.dart';

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
  List pageIndex = [];

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

  @override
  void initState() {
    super.initState();
    pageIndex = widget.snap['pageIndex'];
    print(pageIndex);
  }

  Future<void> newPage() async {
    String pageId = const Uuid().v1();
    List newContents = [null, null, null, null, null, null];
    Map<String, List> map = <String, List>{"contents": newContents};
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .collection('pages')
        .doc(pageId)
        .set(map);
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .update({
      'pageIndex': FieldValue.arrayUnion([pageId])
    });
    pageIndex.add(pageId);
  }

  Future<void> getContents() async {
    if (received) {
      return;
    }
    var ss;
    try {
      if (pageIndex.length <= page) {
        await newPage();
      }
      print(pageIndex);
      DocumentSnapshot s = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('pages')
          .doc(pageIndex[page])
          .get();
      ss = s.data() as Map<String, dynamic>;
    } catch (e) {
      print(e);
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
        // showImage[i] = Center(child: Text(contents[i]));
        showImage[i] = Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          child: Center(
            child: AutoSizeText(
              contents[i],
              softWrap: true,
              minFontSize: 26.0,
              maxFontSize: 40.0,
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }

    bool belongsToUser =
        (widget.snap['uid'] == FirebaseAuth.instance.currentUser?.uid);

    return Scaffold(
      floatingActionButton: Visibility(
        visible: belongsToUser,
        child: FloatingActionButton(
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
      ),
      body: GestureDetector(
        onPanEnd: (details) {
          // print(details.velocity.pixelsPerSecond.dx > 0);
          // Swipe left
          if (details.velocity.pixelsPerSecond.dx < 0) {
            if (!belongsToUser) {
              return;
            }
            if (page == 7) {
              return;
            }
            page++;
            received = false;
            setState(() {});
          }
          // Swipe right
          if (details.velocity.pixelsPerSecond.dx > 0) {
            if (page == 0) {
              return;
            }
            page--;
            received = false;
            setState(() {});
          }
        },
        child: Container(
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
                          if (page == 0) {
                            return;
                          }
                          page--;
                          received = false;
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.arrow_left,
                        ),
                        iconSize: MediaQuery.of(context).size.width * 0.1,
                      ),
                      Text('Page: ' + (page + 1).toString()),
                      IconButton(
                        onPressed: () {
                          if (!belongsToUser) {
                            return;
                          }
                          if (page == 7) {
                            return;
                          }
                          page++;
                          received = false;
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.arrow_right,
                        ),
                        iconSize: MediaQuery.of(context).size.width * 0.1,
                      ),
                      TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              CustomColors().extremelyLight),
                        ),
                        onPressed: () async {
                          int prevPage = page;
                          if (page == 0) {
                            page++;
                          } else {
                            page--;
                          }
                          await FirebaseFirestore.instance
                              .collection('posts')
                              .doc(widget.snap['postId'])
                              .collection('pages')
                              .doc(pageIndex[prevPage])
                              .delete();
                          pageIndex.removeAt(prevPage);
                          await FirebaseFirestore.instance
                              .collection('posts')
                              .doc(widget.snap['postId'])
                              .update({'pageIndex': pageIndex});
                        },
                        icon: Icon(Icons.delete),
                        label: Text(
                          'Delete Page',
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
