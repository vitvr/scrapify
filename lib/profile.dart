/* page to see current user's profile info */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:scrapify/utils/pic.dart';
import 'package:scrapify/utils/post.dart';
import 'utils/colors.dart';
import 'package:scrapify/utils/user_model.dart' as model;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final double coverHeight = 180;
  final double profileRadius = 65;
  final double profileSpacing = 20;

  Future<model.User> getUserDetails() async {
    User currentUser = FirebaseAuth.instance.currentUser!;
    print(currentUser);
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    return model.User.fromSnap(documentSnapshot);
  }

  @override
  Widget build(BuildContext context) {
    final String? _uid = FirebaseAuth.instance.currentUser?.uid;
    var a = FirebaseFirestore.instance.collection('users').doc(_uid);
    double postPadding = MediaQuery.of(context).size.width.toDouble() * 0.019;
    return Container(
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          title: Image(
            image: AssetImage('assets/mainLogoNoLogo.png'),
            width: MediaQuery.of(context).size.width * 0.5,
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
                      .doc(_uid)
                      .get(),
                  // future: getUserDetails()
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    // return Text(snapshot.data!.username);
                    return Column(
                      children: [
                        Stack(
                          children: [
                            Column(
                              children: [
                                Image(
                                  image: const AssetImage('assets/desk.jpeg'),
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

                      // return ListView.builder(
                      //   itemCount: snapshot.data!.docs.length,
                      //   itemBuilder: (context, index) => Row(
                      //     children: [
                      //       PostCard(
                      //         snap: snapshot.data!.docs[index].data(),
                      //       ),
                      //       PostCard(
                      //         snap: snapshot.data!.docs[index].data(),
                      //       ),
                      //     ],
                      //   ),
                      // );

                      // return GridView.builder(
                      //   itemCount: snapshot.data!.docs.length,
                      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //     crossAxisCount: 2,
                      //     // mainAxisSpacing: MediaQuery.of(context).size.height * 0.36,
                      //     childAspectRatio: 0.52,
                      //   ),
                      //   itemBuilder: (context, index) {
                      //     return Flexible(
                      //       child: PostCard(
                      //         snap: snapshot.data!.docs[index].data(),
                      //       ),
                      //     );
                      //   },
                      // );

                      return MasonryGridView.count(
                        padding: EdgeInsets.all(postPadding),
                        itemCount: snapshot.data!.docs.length,
                        crossAxisCount: 2,
                        mainAxisSpacing: postPadding,
                        crossAxisSpacing: postPadding,
                        itemBuilder: (context, index) {
                          if (snapshot.data!.docs[index].get('uid') != _uid) {
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

  Padding createBox(int index) {
    Color c = Colors.black;
    if (index % 3 == 0) {
      c = Colors.red;
    } else if (index % 3 == 1) {
      c = Colors.green;
    } else if (index % 3 == 2) {
      c = Colors.blue;
    }
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Container(
        color: c,
        child: const SizedBox(
          height: 120,
          width: 120,
        ),
      ),
    );
  }
}
