// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:scrapify/screens/ar_screen.dart';
import 'package:scrapify/utils/colors.dart';
import 'package:scrapify/screens/Posts/post.dart';

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
    return FittedBox(
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.4,
            child: Container(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: size.height * 0.04,
                    top: size.height * 0.1,
                    left: size.width * 0.005,
                    right: size.width * 0.005,
                  ),
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: [
                      PostCard(
                        snap: widget.snap,
                        update: (int value) {},
                        large: true,
                      ),
                      Positioned(
                        right: 0,
                        child: FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(70, 255, 255, 255),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: (widget.snap['fact'] == null ||
                                      !widget.snap['fact'])
                                  ? Icon(
                                      Icons.question_mark_outlined,
                                      color: Colors.amber,
                                    )
                                  : Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.green,
                                    ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ARScreen(
                    imageUrl: widget.snap['postUrl'],
                  ),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(
                top: size.height * 0.01,
                bottom: size.height * 0.05,
              ),
              child: FittedBox(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Color.fromARGB(160, 0, 0, 0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 7.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.camera,
                          color: CustomColors().lighter,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 14),
                          child: Text(
                            '\t\t View in AR',
                            style: TextStyle(
                              color: CustomColors().lighter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
