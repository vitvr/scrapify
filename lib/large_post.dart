import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:scrapify/utils/colors.dart';
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
    return FittedBox(
      child: Column(
        children: [
          // Padding(
          //   padding: EdgeInsets.only(
          //     top: size.height * 0.03,
          //     bottom: size.height * 0.03,
          //     left: size.width * 0.3,
          //   ),
          //   child: (widget.snap['fact'] == null || !widget.snap['fact'])
          //       ? FittedBox(
          //           child: Container(
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(20.0),
          //               color: Color.fromARGB(160, 0, 0, 0),
          //             ),
          //             child: Padding(
          //               padding: const EdgeInsets.symmetric(
          //                   vertical: 5.0, horizontal: 7.0),
          //               child: Row(
          //                 children: [
          //                   Icon(
          //                     Icons.question_mark_outlined,
          //                     color: CustomColors().lighter,
          //                   ),
          //                   Text(
          //                     '\t\tOpinion',
          //                     style: TextStyle(
          //                       color: CustomColors().lighter,
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         )
          //       : FittedBox(
          //           child: Container(
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(20.0),
          //               color: Color.fromARGB(160, 0, 0, 0),
          //             ),
          //             child: Padding(
          //               padding: const EdgeInsets.symmetric(
          //                   vertical: 5.0, horizontal: 7.0),
          //               child: Row(
          //                 children: [
          //                   Icon(
          //                     Icons.check_circle_outline,
          //                     color: Colors.green,
          //                   ),
          //                   Text(
          //                     '\t\tFact',
          //                     style: TextStyle(
          //                       color: Colors.green,
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ),
          // ),
          SizedBox(
            height: size.height * 0.4,
            child: Container(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: size.height * 0.1,
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
                              child: Icon(
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
        ],
      ),
    );
  }
}
