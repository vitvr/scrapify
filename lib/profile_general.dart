/* page to see current user's profile info */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:scrapify/edit_page.dart';
import 'package:scrapify/utils/pic.dart';
import 'package:scrapify/utils/post.dart';
import 'utils/colors.dart';
import 'package:scrapify/utils/user_model.dart' as model;

class ProfileGeneral extends StatelessWidget {
  final uid;
  const ProfileGeneral({
    Key? key,
    required this.uid,
  }) : super(key: key);

  final double coverHeight = 180;
  final double profileRadius = 65;
  final double profileSpacing = 20;

  Future<model.User> getUserDetails() async {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  @override
  Widget build(BuildContext context) {
    var a = FirebaseFirestore.instance.collection('users').doc(uid);
    double postPadding = MediaQuery.of(context).size.width.toDouble() * 0.019;
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
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notification_add_outlined),
            ),
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
                        // SizedBox(
                        //   height: profileSpacing,
                        // ),
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
                            onPressed: () {},
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
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .orderBy('datePublished', descending: true)
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return MasonryGridView.count(
                        padding: EdgeInsets.all(postPadding),
                        itemCount: snapshot.data!.docs.length,
                        crossAxisCount: 2,
                        mainAxisSpacing: postPadding,
                        crossAxisSpacing: postPadding,
                        itemBuilder: (context, index) {
                          if (snapshot.data!.docs[index].get('uid') != uid) {
                            print(snapshot.data!.docs[index].data());
                            return Container();
                            // this approach returns an empty container
                            // bad because it causes some padding to appear
                            // not that noticeable ig
                          }
                          // return Tile(
                          //   index: index,
                          //   extent: (index % 5 + 1) * 100,
                          // );
                          return Flexible(
                            child: Pic(
                              snap: snapshot.data!.docs[index].data(),
                            ),
                          );
                        },
                      );

                      // placeholder
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
