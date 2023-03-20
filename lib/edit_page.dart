import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:scrapify/storage_methods.dart';
import 'package:scrapify/utils/choose_image.dart';
import 'package:scrapify/utils/colors.dart';

class EditPage extends StatefulWidget {
  final snap;
  int page;
  final pageIndex;
  EditPage({
    Key? key,
    required this.snap,
    required this.page,
    required this.pageIndex,
  }) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  List contents = [
    null,
    null,
    null,
    null,
    null,
    null,
  ];

  List files = [
    null,
    null,
    null,
    null,
    null,
    null,
  ];

  String text = "THE ERROR";

  Future<String> postImage(int i) async {
    var file = files[i]!;
    print(file);
    if (file.runtimeType == String) {
      contents[i] = file;
      return "";
    }
    String photoURL =
        await Storage_Methods().uploadImageToStorage('temp', file, true);
    contents[i] = photoURL;
    return "";
  }

  Future<void> postList() async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .collection('pages')
        .doc(widget.snap['pageIndex'][widget.page])
        .set({
      'contents': contents,
    });
  }

  Future<void> postPage() async {
    for (int i = 0; i < 6; i++) {
      if (files[i] != null) {
        await postImage(i);
      } else {
        continue;
      }
    }
    await postList();
  }

  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<dynamic> pickText(int index) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Text'),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(hintText: 'write here...'),
          controller: controller,
        ),
        actions: [
          TextButton(
            onPressed: () {
              text = controller.text;
              files[index] = text;
              Navigator.of(context).pop();
              setState(() {
                // files[index] = text;
              });
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  _selectImage(BuildContext context, int index) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create Post'),
            children: [
              //camera option
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a Photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    files[index] = file;
                  });
                },
              ),
              //gallery option
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose From Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    files[index] = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Enter Text'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await pickText(index);
                  // files[index] = text;
                  setState(() {});
                },
              ),
              //cancel
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  bool received = false;

  void loadContents() {
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
  }

  Future<void> getContents() async {
    if (received) {
      return;
    }
    DocumentSnapshot s = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .collection('pages')
        .doc(widget.snap['pageIndex'][widget.page])
        .get();
    var ss = s.data() as Map<String, dynamic>;
    if (ss['contents'] == null) {
      contents = [null, null, null, null, null, null];
    } else {
      contents = await ss['contents'];
    }
    received = true;
    loadContents();
    setState(() {});
    print(contents);
  }

  List<Widget> showImage = [
    Container(),
    Container(),
    Container(),
    Container(),
    Container(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    getContents();

    for (int i = 0; i < 6; i++) {
      if (files[i] == null) {
        showImage[i] = showImage[i];
      } else if (files[i].runtimeType != String) {
        showImage[i] = Image(
          image: MemoryImage(files[i]!),
          fit: BoxFit.cover,
        );
      } else {
        showImage[i] = Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          child: Center(
            child: AutoSizeText(
              files[i],
              softWrap: true,
              minFontSize: 26.0,
              maxFontSize: 40.0,
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async {
        await postPage();
        Navigator.of(context).pop();
      }),
      body: Column(
        children: <Widget>[
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
                        child: showImage[0],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Color.fromARGB(75, 0, 0, 0),
                        ),
                        onPressed: () {
                          _selectImage(context, 0);
                        },
                        iconSize: MediaQuery.of(context).size.width * 0.2,
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
                        child: showImage[1],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Color.fromARGB(75, 0, 0, 0),
                        ),
                        onPressed: () {
                          _selectImage(context, 1);
                        },
                        iconSize: MediaQuery.of(context).size.width * 0.2,
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
                        child: showImage[2],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Color.fromARGB(75, 0, 0, 0),
                        ),
                        onPressed: () {
                          _selectImage(context, 2);
                        },
                        iconSize: MediaQuery.of(context).size.width * 0.2,
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
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Color.fromARGB(75, 0, 0, 0),
                        ),
                        onPressed: () {
                          _selectImage(context, 3);
                        },
                        iconSize: MediaQuery.of(context).size.width * 0.2,
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
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Color.fromARGB(75, 0, 0, 0),
                        ),
                        onPressed: () {
                          _selectImage(context, 4);
                        },
                        iconSize: MediaQuery.of(context).size.width * 0.2,
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
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Color.fromARGB(75, 0, 0, 0),
                        ),
                        onPressed: () {
                          _selectImage(context, 5);
                        },
                        iconSize: MediaQuery.of(context).size.width * 0.2,
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
              color: CustomColors().extremelyLight,
              child: Row(
                children: [
                  TextButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          CustomColors().extremelyLight),
                    ),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('posts')
                          .doc(widget.snap['postId'])
                          .collection('pages')
                          .doc(widget.pageIndex[widget.page])
                          .delete();
                      widget.pageIndex.removeAt(widget.page);
                      await FirebaseFirestore.instance
                          .collection('posts')
                          .doc(widget.snap['postId'])
                          .update({'pageIndex': widget.pageIndex});
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.delete),
                    label: Text(
                      'Delete Page',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
