import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scrapify/storage_methods.dart';
import 'package:scrapify/utils/choose_image.dart';
import 'package:scrapify/utils/colors.dart';
import 'package:scrapify/utils/post_image.dart';
import 'package:textfields/textfields.dart';
import 'package:uuid/uuid.dart';

class editProfile extends StatefulWidget {
  const editProfile({super.key});

  @override
  State<StatefulWidget> createState() {
    return _editPageState();
  }
}

class _editPageState extends State<editProfile> {
  var _uid = FirebaseAuth.instance.currentUser?.uid;

  String header = "";
  String profImage = "";
  String bio = "";
  String username = "";
  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  getUserDetails() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    var snapshot = snap.data() as Map<String, dynamic>;
    header = await snapshot["header"];
    profImage = await snapshot["profImage"];
    bio = await snapshot["bio"];
    username = await snapshot["username"];

    print(username);
    print(bio);
  }

  @override
  Widget build(BuildContext context) {
    // username, bio, profImage, header.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.check,
              // Icons.check,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: FutureBuilder(builder: (context, snapshot) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 100,
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: CustomColors().light,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    minimumSize: const Size(1000000, 30),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => editProfile(),
                      ),
                    );
                  },
                  child: const Text(
                    'Edit header picture',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 100,
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: CustomColors().light,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    minimumSize: const Size(1000000, 30),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => editProfile(),
                      ),
                    );
                  },
                  child: const Text(
                    'Edit profile picture',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: MultiLineTextField(
                  maxLines: 4,
                  bordercolor: Colors.black,
                  label: 'Bio',
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Uint8List? _file;
  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Edit Profile Picture'),
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

  Uint8List? _file1;
  _selectImage2(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Edit Header Picture'),
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
                    _file1 = file;
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
                    _file1 = file;
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
  // _writeBio(BuildContext context) async {
  //   return MultiLineTextField(
  //     maxLines: 20,
  //     bordercolor: Colors.black,
  //   );
  // }
}
