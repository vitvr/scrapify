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
    return SizedBox(
      height: size.height * 0.4,
      child: Container(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: size.height * 0.1,
              horizontal: size.width * 0.01,
            ),
            child: PostCard(
              snap: widget.snap,
              update: (int value) {},
              large: true,
            ),
          ),
        ),
      ),
    );
  }
}
