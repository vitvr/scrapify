import 'dart:io';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scrapify/bookmarks.dart';
import 'package:scrapify/comentscreen.dart';
import 'package:scrapify/utils/colors.dart';
import 'package:scrapify/utils/like_animation.dart';
import 'package:scrapify/view_page.dart';
import '../profile.dart';
import '../profile_general.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  String _username = "";
  String _profImage = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(widget.snap["uid"])
        .get();
    Map<String, dynamic> data = snapshot.data()!;

    setState(() {
      _username = data['username'];
      _profImage = data['profImage'];
    });
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    String res = 'ERROR';
    try {
      if (likes.contains(uid)) {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<void> bookmarkPost(String postId, String uid) async {
    DocumentSnapshot snap1 =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    List bookmarking = (snap1.data()! as dynamic)['bookmarks'];
    if (bookmarking.contains(postId)) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'bookmarks': FieldValue.arrayRemove([postId])
      });
    } else {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'bookmarks': FieldValue.arrayUnion([postId])
      });
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  double getPicHeight() {
    // return 0.2 + (Random().nextDouble() % 0.25);
    if (Random().nextDouble() > 0.5) {
      return 0.3;
    } else {
      return 0.5;
    }
  }

  Future<double> getPicHeightByRatio() async {
    // File img = File.fromUri(widget.snap["postUrl"]);
    // var decodedImg = await decodeImageFromList(img.readAsBytesSync());
    // print(decodedImg.height);
    // print(decodedImg.width);
    return 2;
  }

  @override
  double picHeight = 0.0;
  Widget build(BuildContext context) {
    picHeight = getPicHeight();
    getPicHeightByRatio();
    final String? _uid = FirebaseAuth.instance.currentUser?.uid;
    return Padding(
      padding: EdgeInsets.all(0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.46,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(spreadRadius: 1, blurRadius: 3, color: Colors.grey),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                // height: MediaQuery.of(context).size.height * picHeight,
                child: Stack(
                  fit: StackFit.passthrough,
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ViewPage(
                                snap: widget.snap,
                              ),
                            ),
                          );
                        },
                        child: Image(
                          image: NetworkImage(widget.snap["postUrl"]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.077,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 20,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 0,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  final currentUser =
                                      FirebaseAuth.instance.currentUser?.uid;
                                  final targetUid = widget.snap['uid'];

                                  if (currentUser == targetUid) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ProfilePersonal()),
                                    );
                                  } else {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProfileGeneral(uid: targetUid),
                                      ),
                                    );
                                  }
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      widget.snap["description"],
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      '@' + _username,
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final currentUser =
                              FirebaseAuth.instance.currentUser?.uid;
                          final targetUid = widget.snap['uid'];

                          if (currentUser == targetUid) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ProfilePersonal()),
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProfileGeneral(uid: targetUid),
                              ),
                            );
                          }
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            _profImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 4.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: CustomColors().extremelyLight,
                          // border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child:
                                  Text(widget.snap['likes'].length.toString()),
                            ),
                            LikeAnimation(
                              isAnimating: widget.snap['likes'].contains(_uid),
                              smallLike: true,
                              child: IconButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  likePost(
                                    widget.snap['postId'],
                                    _uid!,
                                    widget.snap['likes'],
                                  );
                                },
                                icon: widget.snap['likes'].contains(_uid)
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      )
                                    : const Icon(
                                        Icons.favorite_border,
                                      ),
                                visualDensity: VisualDensity.comfortable,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CommentScreen(
                            snap: widget.snap,
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.comment,
                      color: Colors.red,
                    ),
                    visualDensity: VisualDensity.comfortable,
                  ),
                  FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(_uid)
                          .get(),
                      builder: (context, snapshot) {
                        bool bookmarked = false;
                        print(_uid);
                        print(snapshot.data);
                        List bookmarks = [];
                        if (snapshot.hasData) {
                          bookmarks = snapshot.data!.get('bookmarks');
                        }
                        if (bookmarks.contains(widget.snap['postId'])) {
                          bookmarked = true;
                        }
                        return LikeAnimation(
                          isAnimating: bookmarked,
                          smallLike: true,
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () async {
                              await bookmarkPost(
                                widget.snap['postId'],
                                _uid!,
                              );
                              bookmarked = !bookmarked;
                              setState(() {});
                            },
                            icon: bookmarked
                                ? Icon(
                                    Icons.bookmark,
                                    color: Colors.red,
                                  )
                                : Icon(
                                    Icons.bookmark_outline,
                                  ),
                            visualDensity: VisualDensity.comfortable,
                          ),
                        );
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
