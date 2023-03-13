import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scrapify/bookmarks.dart';
import 'package:scrapify/comentscreen.dart';
import 'package:scrapify/utils/like_animation.dart';

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
  bool isLikeAnimating = false;
  bool isBookmark = false;

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
  // double picHeight = 0.3 + (Random().nextDouble() % 0.26);
  double picHeight = 0.0;
  Widget build(BuildContext context) {
    picHeight = getPicHeight();
    getPicHeightByRatio();
    final String? _uid = FirebaseAuth.instance.currentUser?.uid;
    return Padding(
      // padding: EdgeInsets.all(
      //   MediaQuery.of(context).size.width.toDouble() * 0.013,
      // ),
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
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image(
                    image: NetworkImage(widget.snap["postUrl"]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.snap["description"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    widget.snap["username"],
                                    style: const TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          widget.snap['profImage'],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
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
                      Text('${widget.snap['likes'].length} likes'),
                    ],
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
                  IconButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BookmarkPage(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.share,
                      color: Colors.red,
                    ),
                    visualDensity: VisualDensity.comfortable,
                  ),
                  IconButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      bookmarkPost(
                        widget.snap['postId'],
                        _uid!,
                      );
                    },
                    icon: Icon(
                      Icons.bookmark,
                      color: Colors.red,
                    ),
                    visualDensity: VisualDensity.comfortable,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
