/* page to see current user's profile info */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:scrapify/edit_page.dart';
import 'package:scrapify/utils/pic.dart';
import 'package:scrapify/utils/post.dart';
import 'package:scrapify/view_page.dart';
import 'utils/colors.dart';
import 'package:scrapify/utils/user_model.dart' as model;

class ProfileGeneral extends StatefulWidget {
  final uid;
  const ProfileGeneral({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileGeneral> createState() => _ProfileGeneralState();
}

class _ProfileGeneralState extends State<ProfileGeneral> {
  final double coverHeight = 180;

  final double profileRadius = 65;

  final double profileSpacing = 20;

  bool isFollowing = false;

  Future<void> checkFollowing() async {
    var userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();
    isFollowing = userSnap
        .data()!['followers']
        .contains(FirebaseAuth.instance.currentUser!.uid);
    print(isFollowing);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkFollowing();
  }

  Future<void> followUser(String cuid, String followId) async {
    try {
      DocumentSnapshot snap =
          await FirebaseFirestore.instance.collection('users').doc(cuid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(followId)
            .update({
          'followers': FieldValue.arrayRemove([cuid])
        });

        await FirebaseFirestore.instance.collection('users').doc(cuid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(followId)
            .update({
          'followers': FieldValue.arrayUnion([cuid])
        });

        await FirebaseFirestore.instance.collection('users').doc(cuid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget followButton = Container();
    if (isFollowing) {
      followButton = Padding(
        padding: EdgeInsets.all(profileSpacing),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: CustomColors().lighter,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            minimumSize: const Size(1000000, 30),
          ),
          onPressed: () async {
            await followUser(
                FirebaseAuth.instance.currentUser!.uid, widget.uid);
            isFollowing = !isFollowing;
            setState(() {});
          },
          child: const Text(
            'Unfollow',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      );
    } else {
      followButton = Padding(
        padding: EdgeInsets.all(profileSpacing),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: CustomColors().light,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            minimumSize: const Size(1000000, 30),
          ),
          onPressed: () async {
            await followUser(
                FirebaseAuth.instance.currentUser!.uid, widget.uid);
            isFollowing = !isFollowing;
            setState(() {});
          },
          child: const Text(
            'Follow',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      );
    }
    var a = FirebaseFirestore.instance.collection('users').doc(widget.uid);
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
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
                      .doc(widget.uid)
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
                                        ),
                                        SizedBox(
                                          height: profileSpacing / 2,
                                        ),
                                        Text(
                                          "\"" +
                                              snapshot.data!.get('bio') +
                                              "\"",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
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
                        followButton
                      ],
                    );
                  }),
              Expanded(
                child: Container(
                  color: CustomColors().lighter,
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
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
                            child: Image.network(
                              (snapshot.data! as dynamic).docs[index]
                                  ['postUrl'],
                              fit: BoxFit.cover,
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
