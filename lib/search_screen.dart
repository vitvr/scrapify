import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scrapify/large_post.dart';
import 'package:scrapify/profile.dart';
import 'package:scrapify/profile_general.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:scrapify/utils/post_image.dart';
import 'package:scrapify/view_page.dart';
import 'package:scrapify/view_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  double postPadding = 0.0;
  bool isShowUsers = false;
  List<String> followingIds = [];

  Future<void> fetchFollowing() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    followingIds = List<String>.from(snapshot.get('following'));
    followingIds.add(uid);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchFollowing();
  }

  @override
  Widget build(BuildContext context) {
    postPadding = MediaQuery.of(context).size.width * 0.015;
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(labelText: 'Search for a user'),
          onFieldSubmitted: (String _) {
            if (searchController.text.trim().isEmpty) {
              showDialog(
                context: context,
                builder: (context) => ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: AlertDialog(
                    title: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 8),
                        const Text('Error',
                            style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    content: const Text('Please enter a search term.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              setState(() {
                isShowUsers = true;
              });
            }
          },
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo:
                          searchController.text.trim().toLowerCase(),
                      isLessThanOrEqualTo:
                          searchController.text.trim().toLowerCase() + "\uf8ff")
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            (snapshot.data! as dynamic).docs[index]
                                ['profImage']),
                      ),
                      title: Text(
                        (snapshot.data! as dynamic).docs[index]['username'],
                      ),
                      onTap: () {
                        final currentUser =
                            FirebaseAuth.instance.currentUser?.uid;
                        final targetUid =
                            (snapshot.data! as dynamic).docs[index]['uid'];

                        if (currentUser == targetUid) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const ProfilePersonal()),
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
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('posts')
                  .where('uid',
                      whereNotIn: (followingIds.isEmpty
                          ? [FirebaseAuth.instance.currentUser?.uid]
                          : followingIds))
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return MasonryGridView.count(
                  crossAxisCount: 2,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return LargePost(
                              snap: snapshot.data!.docs[index].data(),
                            );
                          },
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.network(
                          (snapshot.data! as dynamic).docs[index]['postUrl'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  mainAxisSpacing: postPadding,
                  crossAxisSpacing: postPadding,
                  padding: EdgeInsets.all(postPadding),
                );
              },
            ),
    );
  }
}
