import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scrapify/new_scrapbook.dart';
import 'package:scrapify/utils/post.dart';

class BookmarkPage extends StatefulWidget {
  BookmarkPage({Key? key}) : super(key: key);

  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  List bookmarked = [];

  final String? _uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    getPosts(_uid!);
  }

  void getPosts(String uid) {
    FirebaseFirestore.instance.collection('users').doc(uid).get().then((snap) {
      setState(() {
        bookmarked = (snap.data()! as dynamic)['bookmarks'];
      });
    });
  }

  int _count = 0;

  void _update(int count) {
    setState(() => _count = count);
  }

  @override
  Widget build(BuildContext context) {
    double postPadding = MediaQuery.of(context).size.width.toDouble() * 0.019;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Scaffold(
          backgroundColor: const Color.fromARGB(14, 255, 99, 61),
          appBar: AppBar(
            title: const Text(
              'SCRAPIFY',
              style: TextStyle(fontSize: 35),
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
            child: bookmarked.isEmpty
                ? const Center(
                    child: Text('No bookmarked posts'),
                  )
                : StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .where('postId')
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
                      return ListView.separated(
                        padding: EdgeInsets.all(postPadding),
                        itemCount: snapshot.data!.docs.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 13,
                          );
                        },
                        itemBuilder: (context, index) {
                          if (!bookmarked.contains(
                              snapshot.data!.docs[index].get("postId"))) {
                            return Container();
                          }
                          return Flexible(
                            child: PostCard(
                              snap: snapshot.data!.docs[index].data(),
                              update: _update,
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
