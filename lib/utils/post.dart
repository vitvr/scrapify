import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scrapify/comentscreen.dart';
import 'package:scrapify/utils/colors.dart';
import 'package:scrapify/utils/like_animation.dart';
import 'package:scrapify/view_page.dart';
import '../profile.dart';
import '../profile_general.dart';

class PostCard extends StatefulWidget {
  final snap;
  final ValueChanged<int> update;
  const PostCard({Key? key, required this.snap, required this.update})
      : super(key: key);

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
    belongsToUser =
        (widget.snap['uid'] == FirebaseAuth.instance.currentUser?.uid);
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

  bool belongsToUser = false;

  Future<void> deletePost(String postId) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  postOptions(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Delete Post'),
                onPressed: () async {
                  await deletePost(widget.snap['postId']);
                  widget.update(100);
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle_outline,
                              color: Colors.white, size: 32),
                          SizedBox(width: 10),
                          Text(
                            'Post deleted',
                            style: TextStyle(color: Colors.white, fontSize: 16),
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
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Edit Post'),
                onPressed: () {},
                //placeholder
              ),
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

  @override
  Widget build(BuildContext context) {
    final String? _uid = FirebaseAuth.instance.currentUser?.uid;
    return GestureDetector(
      onLongPress: () {
        if (belongsToUser) {
          postOptions(context);
        } else {
          return;
        }
      },
      child: Padding(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                          child: FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('posts')
                                .doc(widget.snap['postId'])
                                .get(),
                            builder: (context, snapshot) {
                              int likes = 0;
                              bool liked = false;
                              List likesList = [];
                              if (snapshot.hasData) {
                                likesList = snapshot.data!.get('likes');
                              }
                              if (likesList.contains(_uid)) {
                                liked = true;
                              }

                              return Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(likesList.length.toString()),
                                  ),
                                  LikeAnimation(
                                    isAnimating: liked,
                                    smallLike: true,
                                    child: IconButton(
                                      padding: EdgeInsets.all(0),
                                      onPressed: () async {
                                        await likePost(
                                          widget.snap['postId'],
                                          _uid!,
                                          snapshot.data!.get('likes'),
                                        );
                                        liked = !liked;
                                        setState(() {});
                                      },
                                      icon: liked
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
                              );
                            },
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
                                      color: Colors.black,
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
      ),
    );
  }
}
