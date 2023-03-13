/* the homepage of the app, it includes a feed of recommended posts as well as
the option to create new ones */

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scrapify/new_scrapbook.dart';
import 'package:scrapify/utils/post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double postPadding = MediaQuery.of(context).size.width.toDouble() * 0.019;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Scaffold(
          backgroundColor: const Color.fromARGB(14, 255, 99, 61),
          // currently, the 'create scrapbook' button is being used as a
          // placeholder sign out button
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 255, 99, 61),
            child: const Icon(Icons.create),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewScrapbookPage(),
                ),
              );
            },
          ),
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
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('datePublished', descending: true)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
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
                    return Flexible(
                      child: PostCard(
                        snap: snapshot.data!.docs[index].data(),
                      ),
                    );
                  },
                );

                // placeholder
              },
            ),

            // child: GridView.builder(
            //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2,
            //   ),
            //   itemBuilder: (context, index) {
            //     return Padding(
            //       padding: EdgeInsets.all(2),
            //       child: PostCard(),
            //     );
            //   },
            // ),

            // child: ListView.builder(
            //   itemCount: 20,
            //   itemBuilder: (context, index) {
            //     return Row(
            //       children: [
            //         PostCard(),
            //         PostCard(),
            //       ],
            //     );
            //   },
            // ),

            // child: Column(
            //   children: [
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         PostCard(),
            //         PostCard(),
            //       ],
            //     ),
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         PostCard(),
            //         PostCard(),
            //       ],
            //     ),
            //   ],
            // ),
          ),
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
