import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:scrapify/utils/post.dart';
import 'package:scrapify/utils/post_editable.dart';

class LargePostEditable extends StatefulWidget {
  final snap;
  const LargePostEditable({Key? key, required this.snap}) : super(key: key);

  @override
  State<LargePostEditable> createState() => _LargePostEditableState();
}

class _LargePostEditableState extends State<LargePostEditable> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.4,
      child: Container(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Padding(
            padding: EdgeInsets.only(
              top: size.height * 0.1,
              bottom: size.height * 0.1,
              left: size.width * 0.01,
              right: size.width * 0.01,
            ),
            child: PostEditable(
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
