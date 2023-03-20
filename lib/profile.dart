/* page to see current user's profile info */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:scrapify/edit_page.dart';
import 'package:scrapify/edit_user.dart';
import 'package:scrapify/utils/pic.dart';
import 'package:scrapify/utils/post.dart';
import 'package:scrapify/view_page.dart';
import 'utils/colors.dart';
import 'package:scrapify/utils/user_model.dart' as model;

class ProfilePersonal extends StatefulWidget {
  const ProfilePersonal({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePersonal> createState() => _ProfilePersonalState();
}

class _ProfilePersonalState extends State<ProfilePersonal> {
  final double coverHeight = 180;

  final double profileRadius = 65;

  final double profileSpacing = 20;

  var uid = FirebaseAuth.instance.currentUser?.uid;

  String profImage = "";

  Future<void> fetchData() async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    profImage = snapshot.get('profImage');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<model.User> getUserDetails() async {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  @override
  Widget build(BuildContext context) {
    var a = FirebaseFirestore.instance.collection('users').doc(uid);
    double postPadding = MediaQuery.of(context).size.width.toDouble() * 0.02;
    return Container(
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          title: const Image(
            image: AssetImage('assets/mainLogoNoLogo.png'),
            height: 35,
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          actions: [
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(Icons.notification_add_outlined),
            // ),
            (profImage != "")
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 5,
                    ),
                    child: FittedBox(
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          profImage,
                        ),
                      ),
                    ),
                  )
                : CircularProgressIndicator(),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Column(
                      children: [
                        Stack(
                          children: [
                            Column(
                              children: [
                                Image(
                                  image: NetworkImage(
                                    snapshot.data!.get('header'),
                                  ),
                                  width: double.infinity,
                                  height: coverHeight,
                                  fit: BoxFit.cover,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width:
                                          (profileRadius + profileSpacing) * 2,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: profileSpacing,
                                        ),
                                        Text(
                                          snapshot.data!.get('username'),
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: profileSpacing / 4,
                                        ),
                                        Text(
                                          '@' + snapshot.data!.get('username'),
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        SizedBox(
                                          height: profileSpacing / 4,
                                        ),
                                        Row(
                                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              snapshot.data!
                                                      .get('followers')
                                                      .length
                                                      .toString() +
                                                  ' followers',
                                            ),
                                            SizedBox(
                                              width: profileSpacing,
                                            ),
                                            Text(
                                              snapshot.data!
                                                      .get('following')
                                                      .length
                                                      .toString() +
                                                  ' following',
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Positioned(
                              top: coverHeight - profileRadius / 2,
                              child: Padding(
                                padding: EdgeInsets.only(left: profileSpacing),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage: NetworkImage(
                                      snapshot.data!.get('profImage')),
                                  radius: profileRadius,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: profileSpacing / 2,
                        ),
                        Text(
                          "\"" + snapshot.data!.get('bio') + "\"",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(profileSpacing),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: CustomColors().light,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)),
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
                              'Edit Profile',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
              Expanded(
                child: Container(
                  color: CustomColors().lighter,
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return MasonryGridView.count(
                        padding: EdgeInsets.all(postPadding),
                        itemCount: (snapshot.data! as dynamic)!.docs.length,
                        crossAxisCount: 2,
                        mainAxisSpacing: postPadding,
                        crossAxisSpacing: postPadding,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ViewPage(
                                      snap: snapshot.data!.docs[index].data()),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.network(
                                (snapshot.data! as dynamic).docs[index]
                                    ['postUrl'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      );
                    },
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
