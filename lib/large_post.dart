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
          SizedBox(
            height: size.height * 0.4,
            child: Container(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: size.height * 0.1,
                    left: size.width * 0.005,
                    right: size.width * 0.005,
                  ),
                  child: PostCard(
                    snap: widget.snap,
                    update: (int value) {},
                    large: true,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.03),
            child: (widget.snap['fact'] == null || !widget.snap['fact'])
                ? FittedBox(
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
                              Icons.question_mark_outlined,
                              color: CustomColors().light,
                            ),
                            Text(
                              '\t\tOpinion',
                              style: TextStyle(
                                color: CustomColors().light,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : FittedBox(
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
                              Icons.check_circle_outline,
                              color: Colors.green,
                            ),
                            Text(
                              '\t\tFact',
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            ),
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
