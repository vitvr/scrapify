import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String profImage;
  final String header;
  final String username;
  final String bio;
  final bookmarks;
  final List posts;
  final List followers;
  final List following;

  const User(
      {required this.username,
      required this.uid,
      required this.profImage,
      required this.header,
      required this.email,
      required this.bio,
      required this.bookmarks,
      required this.posts,
      required this.followers,
      required this.following});

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      profImage: snapshot["profImage"],
      header: snapshot['header'],
      bio: snapshot["bio"],
      bookmarks: snapshot["bookmarks"],
      posts: snapshot["posts"],
      followers: snapshot["followers"],
      following: snapshot["following"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "profImage": profImage,
        "header": header,
        "bio": bio,
        "bookmarks": bookmarks,
        "posts": posts,
        "followers": followers,
        "following": following,
      };
}
