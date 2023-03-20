import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:scrapify/utils/post.dart';

class LargePost extends StatefulWidget {
  final snap;
  const LargePost({Key? key, required this.snap}) : super(key: key);

  @override
  State<LargePost> createState() => _LargePostState();
}

class _LargePostState extends State<LargePost> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: size.height * 0.13,
      ),
      child: PostCard(
        snap: widget.snap,
        update: (int value) {},
        large: true,
      ),
    );
  }
}
