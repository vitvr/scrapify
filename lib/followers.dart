import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class FollowersPage extends StatefulWidget {
  final bool following;
  const FollowersPage({Key? key, required this.following}) : super(key: key);

  @override
  State<FollowersPage> createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  List<String> followingIds = [];
  Future<void> fetchFollowing() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (widget.following) {
      followingIds = List<String>.from(snapshot.get('following'));
    } else {
      followingIds = List<String>.from(snapshot.get('followers'));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchFollowing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FittedBox(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.following ? Text('Following') : Text('Followers'),
          )),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .where('uid', whereIn: followingIds.isEmpty ? [""] : followingIds)
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
                        (snapshot.data! as dynamic).docs[index]['profImage']),
                  ),
                  title: Text(
                    (snapshot.data! as dynamic).docs[index]['username'],
                  ),
                  onTap: () {
                    final currentUser = FirebaseAuth.instance.currentUser?.uid;
                    final targetUid =
                        (snapshot.data! as dynamic).docs[index]['uid'];
                    if (currentUser == targetUid) {
                    } else {}
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
