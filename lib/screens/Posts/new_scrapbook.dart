// ignore_for_file: avoid_print, unused_field, no_leading_underscores_for_local_identifiers, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scrapify/utils/storage_methods.dart';
import 'package:scrapify/utils/choose_image.dart';
import 'package:scrapify/utils/colors.dart';
import 'package:scrapify/models/post_image.dart';
import 'package:uuid/uuid.dart';

class NewScrapbookPage extends StatefulWidget {
  NewScrapbookPage({super.key});

  @override
  State<NewScrapbookPage> createState() => _NewScrapbookPageState();
}

class _NewScrapbookPageState extends State<NewScrapbookPage> {
  final titleController = TextEditingController();

  final captionController = TextEditingController();

  final tagController = TextEditingController();

  final List<String> visibilityList = [
    'Public',
    'Private',
  ];

  final List<String> infoTypeList = [
    'Opinion',
    'Fact',
  ];

  String visibilityValue = 'Public';

  String infoTypeValue = 'Opinion';
  bool infoTypeBool = false;

  Image image = Image.asset(
    'assets/parrot.png',
    fit: BoxFit.cover,
  );

  Widget showImage = Container();

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  //getting UID
  final String? _uid = FirebaseAuth.instance.currentUser?.uid;

  //Getting username
  String username = 'EROORRR';
  String profImage = 'EROORRR';

  getUsername() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    var snapshot = snap.data() as Map<String, dynamic>;
    username = await snapshot["username"];
    profImage = await snapshot["profImage"];
    if (mounted) {
      setState(() {});
    }
  }

  final _firestoreRef = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid);

  Future<String> postImage(String caption, Uint8List file, String uid,
      String username, String profImage, bool fact) async {
    String res = "error";
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      String photoURL =
          await Storage_Methods().uploadImageToStorage('posts', file, true);
      String postID = const Uuid().v1();

      Post post = Post(
          caption: caption,
          uid: uid,
          username: username,
          likes: [],
          postId: postID,
          datePublished: DateTime.now(),
          postUrl: photoURL,
          profImage: profImage,
          location: const GeoPoint(0.0, 0.0),
          pageIndex: [],
          fact: fact);

      _firestore.collection('posts').doc(postID).set(post.toJson());

      await FirebaseFirestore.instance.collection('users').doc(_uid).update({
        'posts': FieldValue.arrayUnion([postID])
      });
      res = "success";
    } catch (e) {
      print(e.toString());
    }
    return res;
  }

  Uint8List? _file;

  String addOrReplace = 'Add cover photo';

  Future<dynamic> _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Center(
            child: Text(
              "Create Post",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.blueGrey),
                title: Text("Take a Photo",
                    style: TextStyle(color: Colors.black54)),
                onTap: () async {
                  Navigator.pop(context);
                  Uint8List file;
                  try {
                    file = await pickImage(
                      ImageSource.camera,
                    );
                  } catch (e) {
                    return;
                  }
                  setState(() {
                    _file = file;
                  });
                },
              ),
              Divider(color: Colors.grey[400]),
              ListTile(
                leading: Icon(Icons.photo, color: CustomColors().dark),
                title: Text("Choose From Gallery",
                    style: TextStyle(color: Colors.black54)),
                onTap: () async {
                  Navigator.pop(context);
                  Uint8List file;
                  try {
                    file = await pickImage(
                      ImageSource.gallery,
                    );
                  } catch (e) {
                    return;
                  }
                  setState(() {
                    _file = file;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  bool display = false;

  @override
  Widget build(BuildContext context) {
    if (_file == null) {
      showImage = Container();
      addOrReplace = 'Add cover photo';
    } else {
      addOrReplace = 'Replace cover photo';
      showImage = Padding(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.025,
        ),
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
              child: Image(
                image: MemoryImage(_file!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 99, 61),
        child: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      appBar: AppBar(
        title: const Text(
          'SCRAPIFY',
          style: TextStyle(fontSize: 35),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.width.toDouble() * 0.025,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Post Image',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(profImage),
                        radius: 40,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              DropdownButton(
                                dropdownColor: CustomColors().light,
                                borderRadius: BorderRadius.circular(20.0),
                                value: infoTypeValue,
                                icon: Icon(Icons.arrow_downward),
                                onChanged: (value) {
                                  setState(() {
                                    infoTypeValue = value.toString();
                                    if (infoTypeValue == 'Fact') {
                                      infoTypeBool = true;
                                    } else {
                                      infoTypeBool = false;
                                    }
                                  });
                                },
                                items: infoTypeList.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      Padding(
                        padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width.toDouble() * 0.02,
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: const CustomColors().dark,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.225,
                              MediaQuery.of(context).size.height * 0.055,
                            ),
                          ),
                          onPressed: () async {
                            if (_file == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(Icons.error_outline,
                                          color: Colors.white, size: 32),
                                      SizedBox(width: 10),
                                      Text(
                                        'Please add an image',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 3),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              );
                            } else if (captionController.text == "") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(Icons.error_outline,
                                          color: Colors.white, size: 32),
                                      SizedBox(width: 10),
                                      Text(
                                        'Please write a caption',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 3),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              );
                            } else {
                              await postImage(
                                captionController.text,
                                _file!,
                                _uid!,
                                username,
                                profImage,
                                infoTypeBool,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(Icons.check_circle_outline,
                                          color: Colors.white, size: 32),
                                      SizedBox(width: 10),
                                      Text(
                                        'Posted!',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 3),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            'Finish',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                showImage,
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(64, 255, 99, 61),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    minimumSize: Size(
                      double.infinity,
                      MediaQuery.of(context).size.height * 0.1,
                    ),
                  ),
                  onPressed: () {
                    _selectImage(context);
                    display = true;
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: Colors.black,
                      ),
                      Text(
                        addOrReplace,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                Text(
                  'Caption',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.005,
                ),
                Container(
                  padding: EdgeInsets.symmetric(),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(64, 255, 99, 61),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: TextField(
                      controller: captionController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Caption',
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.005,
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            backgroundColor: Color.fromARGB(64, 255, 99, 61),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.945,
                              MediaQuery.of(context).size.height * 0.16,
                            ),
                          ),
                          onPressed: () {
                            _selectImage(context);
                            display = true;
                          },
                          child: Column(
                            children: const [
                              Icon(
                                Icons.location_pin,
                                color: Colors.black,
                              ),
                              Text(
                                'Location Placeholder',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
