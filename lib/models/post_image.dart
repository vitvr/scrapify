// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String caption;
  final String uid;
  final String username;
  final likes;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final GeoPoint location;
  final List pageIndex;
  final bool fact;

  const Post(
      {required this.caption,
      required this.uid,
      required this.username,
      required this.likes,
      required this.postId,
      required this.datePublished,
      required this.postUrl,
      required this.profImage,
      required this.location,
      required this.pageIndex,
      required this.fact});

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        caption: snapshot["description"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        postId: snapshot["postId"],
        datePublished: snapshot["datePublished"],
        username: snapshot["username"],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage'],
        location: snapshot['location'],
        pageIndex: snapshot['pageIndex'],
        fact: snapshot['fact']);
  }

  Map<String, dynamic> toJson() => {
        "description": caption,
        "uid": uid,
        "likes": likes,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        'location': location,
        'pageIndex': pageIndex,
        'fact': fact
      };
}
