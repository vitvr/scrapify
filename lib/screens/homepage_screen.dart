/* the homepage of the app, it includes a feed of recommended posts as well as
the option to create new ones */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrapify/screens/Posts/new_scrapbook.dart';
import 'package:scrapify/screens/Posts/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> followingIds = [];
  String profImage = "";

  Future<void> fetchData() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    followingIds = List<String>.from(snapshot.get('following'));
    profImage = snapshot.get('profImage');
    followingIds.add(uid);
    if (this.mounted) {
      setState(() {});
    }
  }

  int _count = 0;

  void _update(int count) {
    setState(() => _count = count);
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    double postPadding = MediaQuery.of(context).size.width.toDouble() * 0.019;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Scaffold(
          backgroundColor: const Color.fromARGB(14, 255, 99, 61),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 255, 99, 61),
            child: const Icon(Icons.create),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewScrapbookPage(),
                ),
              );
              if (this.mounted) {
                setState(() {});
              }
            },
          ),
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
                      padding: const EdgeInsets.symmetric(
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
                  : const CircularProgressIndicator(),
            ],
          ),
          body: SafeArea(
              child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('posts')
                .where('uid',
                    whereIn: (followingIds.isEmpty
                        ? [FirebaseAuth.instance.currentUser?.uid]
                        : followingIds))
                .orderBy('datePublished', descending: true)
                .get(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.docs.isNotEmpty) {
                return MasonryGridView.count(
                  padding: EdgeInsets.all(postPadding),
                  itemCount: snapshot.data!.docs.length,
                  crossAxisCount: 2,
                  mainAxisSpacing: postPadding,
                  crossAxisSpacing: postPadding,
                  itemBuilder: (context, index) {
                    return Flexible(
                      child: PostCard(
                        snap: snapshot.data!.docs[index].data(),
                        update: _update,
                        large: false,
                      ),
                    );
                  },
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(
                      child: Text(
                        'Not following anyone\nCheck out the browse page!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ],
                );
              }
            },
          )),
        ),
      ),
    );
  }

  // creates boxes of random colors, placeholder for actual posts
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
      padding: const EdgeInsets.all(10),
      child: Container(
        color: c,
        child: const SizedBox(
          height: 150,
          width: 150,
        ),
      ),
    );
  }
}
