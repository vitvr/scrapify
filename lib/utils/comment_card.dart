import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:scrapify/utils/like_animation.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  void initState() {
    super.initState();
    getUsername();
  }

  Future<void> deleteComment() async {
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> commentOptions(BuildContext context) async {
    String commentUid = widget.snap['uid'];
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .get();
    String postUid = await snap['uid'];
    String myUid = FirebaseAuth.instance.currentUser!.uid;
    if (myUid == commentUid || myUid == postUid) {
      return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Comment Options",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    leading: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    title: Text(
                      "Delete comment",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () async {
                      await deleteComment();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                                size: 32,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Comment deleted',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
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
                  SizedBox(height: 20),
                  TextButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return;
    }
  }

  //getting UID
  final String? _uid = FirebaseAuth.instance.currentUser?.uid;

  //Getting username
  String username = 'EROORRR';
  String commentId = "ERORR";
  String postId = "ErRor";
  String profImg = "erROR";

  getUsername() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    var snapshot = snap.data() as Map<String, dynamic>;
    username = await snapshot["username"];
    profImg = await snapshot["profImage"];
    commentId = widget.snap["commentId"];
    postId = widget.snap['postId'];
    if (this.mounted) {
      setState(() {});
    }

    print(username);
    print(commentId);
    print('Here');
  }

  final _firestoreRef = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        commentOptions(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                profImg,
              ),
              radius: 18,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: widget.snap['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '\t\t\t',
                      ),
                      TextSpan(
                        text: widget.snap['text'],
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ])),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        DateFormat.yMMMd()
                            .format(widget.snap['datePublished'].toDate()),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
            )
          ],
        ),
      ),
    );
  }
}
