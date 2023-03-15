import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:scrapify/storage_methods.dart';
import 'package:scrapify/utils/choose_image.dart';

class EditPage extends StatefulWidget {
  final snap;
  EditPage({
    Key? key,
    required this.snap,
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

  Future<String> postImage(int i) async {
    Uint8List file = files[i]!;
    String photoURL =
        await Storage_Methods().uploadImageToStorage('temp', file, true);
    contents[i] = photoURL;
    return "";
  }

  Future<void> postList() async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc('4ddf5dd0-c1bc-11ed-89a5-ddc41581b6ca')
        .collection('pages')
        .doc('0')
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
  int page = 0;

  void loadContents() {
    for (int i = 0; i < 6; i++) {
      if (contents[i] != null) {
        showImage[i] = Image(
          image: NetworkImage(contents[i]),
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
        .doc(page.toString())
        .get();
    var ss = s.data() as Map<String, dynamic>;
    contents = await ss['contents'];
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
      } else {
        showImage[i] = Image(
          image: MemoryImage(files[i]!),
          fit: BoxFit.cover,
        );
      }
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        postPage();
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
                        icon: Icon(Icons.add),
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
                        icon: Icon(Icons.add),
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
                        icon: Icon(Icons.add),
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
                        icon: Icon(Icons.add),
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
                        icon: Icon(Icons.add),
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
                        icon: Icon(Icons.add),
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
        ],
      ),
    );
  }
}
