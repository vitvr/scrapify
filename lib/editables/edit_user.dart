// ignore_for_file: unused_import, camel_case_types, prefer_final_fields, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scrapify/utils/storage_methods.dart';
import 'package:scrapify/utils/choose_image.dart';
import 'package:scrapify/utils/colors.dart';
import 'package:scrapify/models/post_image.dart';
import 'package:textfields/textfields.dart';

class editProfile extends StatefulWidget {
  const editProfile({Key? key}) : super(key: key);

  @override
  State<editProfile> createState() => _editPageState();
}

class _editPageState extends State<editProfile> {
  final _uid = FirebaseAuth.instance.currentUser?.uid;
  final usernameController = TextEditingController();
  final bioController = TextEditingController();

  String header = "";
  String profImage = "";
  String bio = "";
  String username = "";
  var userRef = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid);

  Future<String> postImage(Uint8List file) async {
    String photoURL =
        await Storage_Methods().uploadImageToStorage('user', file, true);
    return photoURL;
  }

  @override
  void dispose() {
    usernameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  List<Uint8List?> _files = [null, null]; // header, profile

  Future<dynamic> _selectImage(BuildContext context, int index) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Center(
            child: Text(
              "Choose Header",
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
                leading: const Icon(Icons.camera_alt, color: Colors.blueGrey),
                title: const Text("Take a Photo",
                    style: TextStyle(color: Colors.black54)),
                onTap: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    _files[index] = file;
                  });
                },
              ),
              Divider(color: Colors.grey[400]),
              ListTile(
                leading: Icon(Icons.photo, color: const CustomColors().dark),
                title: const Text("Choose From Gallery",
                    style: TextStyle(color: Colors.black54)),
                onTap: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _files[index] = file;
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

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    var snapshot = snap.data() as Map<String, dynamic>;
    setState(() {
      header = snapshot["header"];
      profImage = snapshot["profImage"];
      bio = snapshot["bio"];
      username = snapshot["username"];
    });
  }

  Future<void> postChanges() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (_files[0] != null) {
                String photoUrl = await postImage(_files[0]!);
                await userRef.update({
                  'header': photoUrl,
                });
              }
              if (_files[1] != null) {
                String photoUrl = await postImage(_files[1]!);
                await userRef.update({
                  'profImage': photoUrl,
                });
              }
              if (usernameController.text != "") {
                await userRef.update({
                  'username': usernameController.text.toLowerCase(),
                });
              }
              if (bioController.text != "") {
                await userRef.update({
                  'bio': bioController.text,
                });
              }

              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.check,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 20,
            ),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: (_files[0] == null)
                            ? NetworkImage(header)
                            : Image(image: MemoryImage(_files[0]!)).image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: IconButton(
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      _selectImage(context, 0);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                _selectImage(context, 1);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.35,
                ),
                child: FittedBox(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: (_files[1] == null)
                        ? NetworkImage(profImage)
                        : Image(image: MemoryImage(_files[1]!)).image,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  labelText: username,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: bioController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  labelText: bio,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
