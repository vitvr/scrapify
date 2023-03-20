import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:scrapify/homepage.dart';
import 'package:scrapify/onboarding.dart';
import 'package:scrapify/utils/colors.dart';
import 'package:scrapify/utils/comment_card.dart';
import 'package:scrapify/utils/menu_button.dart';
import 'package:uuid/uuid.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  CommentScreenState createState() => CommentScreenState();
}

class CommentScreenState extends State<CommentScreen> {
  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'postId': postId,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print('comment empty');
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  //getting UID
  final String? _uid = FirebaseAuth.instance.currentUser?.uid;

  //Getting username
  String username = 'EROORRR';

  getUsername() async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    var snapshot = snap.data() as Map<String, dynamic>;
    username = await snapshot["username"];
    print(username);
  }

  final _firestoreRef = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid);

  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(14, 255, 99, 61),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'SCRAPIFY',
            style: TextStyle(fontSize: 35),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Container(
          child: CommentBox(
            userImage: CommentBox.commentImageParser(
              imageURLorPath: NetworkImage(
                widget.snap["profImage"],
              ),
            ),
            labelText: 'Write a comment...',
            errorText: 'Comment cannot be blank',
            withBorder: false,
            sendButtonMethod: () async {
              await postComment(
                widget.snap['postId'],
                commentController.text,
                _uid!,
                username,
                widget.snap['profImage'],
              );
              setState(() {
                commentController.text = "";
              });
            },
            commentController: commentController,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.black),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.snap['postId'])
                  .collection('comments')
                  .orderBy('datePublished', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => CommentCard(
                      snap: (snapshot.data! as dynamic).docs[index].data()),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
