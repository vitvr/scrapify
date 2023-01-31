import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scrapify/storage_methods.dart';
import 'package:scrapify/utils/choose_image.dart';
import 'package:scrapify/utils/colors.dart';
import 'package:scrapify/utils/post_image.dart';
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

  // Widget noPhoto = Column(
  //   children: const [
  //     Icon(
  //       Icons.add_circle_outline,
  //       color: Colors.black,
  //     ),
  //     Text(
  //       'Add cover photo',
  //       style: TextStyle(
  //         color: Colors.black,
  //         fontSize: 14,
  //       ),
  //     ),
  //   ],
  // );

  // Image image = Image.asset(
  //   'assets/parrot.png',
  //   fit: BoxFit.cover,
  // );

  // Widget showImage = Image.asset(
  //   'assets/parrot.png',
  //   fit: BoxFit.cover,
  // );

  Image image = Image.asset(
    'assets/parrot.png',
    fit: BoxFit.cover,
  );

  Widget showImage = Container();

  // bool hasImage = false;
  // Widget buttonImage = Column(
  //   children: const [
  //     Icon(
  //       Icons.add_circle_outline,
  //       color: Colors.black,
  //     ),
  //     Text(
  //       'Add cover photo',
  //       style: TextStyle(
  //         color: Colors.black,
  //         fontSize: 14,
  //       ),
  //     ),
  //   ],
  // );

  // Color buttonColor = CustomColors().lighter;

  //selecting image for post
  final String? _uid = FirebaseAuth.instance.currentUser?.uid;
  String getUsername() {
    String res = 'error';
    try {
      final _firestoreRef = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid);

      _firestoreRef.get().then((DocumentSnapshot doc) {
        return doc.get('username');
      });
    } catch (e) {
      res = e.toString();
      return res;
    }
    return 'ERORRRRRR';
  }

  final _firestoreRef = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid);
  // final String? _username = FirebaseAuth.instance.currentUser?.;

  Future<String> postImage(String caption, Uint8List file, String uid,
      String username, String profImage) async {
    String res = "error";
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      print('REACHED HERE');
      String photoURL =
          await Storage_Methods().uploadImageToStorage('posts', file, true);
      print('REACHED HERE');
      String postID = const Uuid().v1();

      Post post = Post(
          caption: caption,
          uid: uid,
          username: username,
          likes: [],
          postId: postID,
          datePublished: DateTime.now(),
          postUrl: photoURL,
          profImage: profImage);

      _firestore.collection('posts').doc(postID).set(post.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
      print(res);
    }
    return res;
  }

  Uint8List? _file;

  _selectImage(BuildContext context) async {
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
                    _file = file;
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
                    _file = file;
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

  bool display = false;

  @override
  Widget build(BuildContext context) {
    // if (hasImage) {
    //   buttonImage = image;
    //   buttonColor = Colors.white;
    // } else {
    //   buttonImage = noPhoto;
    //   buttonColor = CustomColors().lighter;
    // }
    print(_uid);
    if (_file == null) {
      showImage = Container();
    } else {
      showImage = Image(
        image: MemoryImage(_file!),
      );
    }
    String username = getUsername();
    return Container(
      child: Scaffold(
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
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notification_add_outlined),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.width.toDouble() * 0.025,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage('assets/selfie.jpg'),
                          radius: 40,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jane Doe',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Row(
                              children: [
                                DropdownButton(
                                  dropdownColor: CustomColors().light,
                                  borderRadius: BorderRadius.circular(20.0),
                                  value: visibilityValue,
                                  icon: Icon(Icons.arrow_downward),
                                  onChanged: (value) {
                                    setState(() {
                                      visibilityValue = value.toString();
                                    });
                                  },
                                  items: visibilityList.map((value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                DropdownButton(
                                  value: infoTypeValue,
                                  icon: Icon(Icons.arrow_downward),
                                  onChanged: (value) {
                                    setState(() {
                                      infoTypeValue = value.toString();
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
                            onPressed: () {
                              postImage(
                                'JEDSF',
                                _file!,
                                _uid!,
                                'ASDASD',
                                'gs://scrapify-9bcaa.appspot.com/selfie.jpg',
                              );
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
                      children: const [
                        Icon(
                          Icons.add_circle_outline,
                          color: Colors.black,
                        ),
                        Text(
                          'Add cover photo',
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
                    'Title',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.005,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(64, 255, 99, 61),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: const Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Title',
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
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
                    padding: EdgeInsets.symmetric(
                        // vertical: MediaQuery.of(context).size.height * 0.1,
                        ),
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
                              backgroundColor: Color.fromARGB(64, 255, 99, 61),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              minimumSize: Size(
                                MediaQuery.of(context).size.width * 0.45,
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
                                  Icons.add_circle_outline,
                                  color: Colors.black,
                                ),
                                Text(
                                  'Add cover photo',
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tags',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.005,
                          ),
                          SizedBox(
                            // height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(64, 255, 99, 61),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: const Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: TextField(
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Insert text here',
                                  ),
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
