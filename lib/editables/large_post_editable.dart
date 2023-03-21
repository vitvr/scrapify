// ignore_for_file: unnecessary_import, implementation_imports, prefer_typing_uninitialized_variables, use_build_context_synchronously, curly_braces_in_flow_control_structures, unused_import, await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:scrapify/editables/post_editable.dart';
import 'package:scrapify/utils/colors.dart';

class LargePostEditable extends StatefulWidget {
  final snap;
  final ValueChanged<int> update;
  const LargePostEditable({Key? key, required this.snap, required this.update})
      : super(key: key);

  @override
  State<LargePostEditable> createState() => _LargePostEditableState();
}

class _LargePostEditableState extends State<LargePostEditable> {
  final captionController = TextEditingController();

  Future<void> editCaption() async {
    var userRef = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId']);

    if (captionController.text != "") {
      await userRef.update({
        'description': captionController.text.toLowerCase(),
      });
    }
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.4,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: FloatingActionButton(
                onPressed: () async {
                  await editCaption();
                  widget.update(0);
                  Navigator.of(context).pop();
                },
                backgroundColor: const CustomColors().light,
                child: const Icon(
                  Icons.check,
                ),
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.contain,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: size.height * 0.05,
                    bottom: size.height * 0.01,
                    left: size.width * 0.01,
                    right: size.width * 0.01,
                  ),
                  child: PostEditable(
                    snap: widget.snap,
                    update: (int value) {},
                    large: true,
                    captionController: captionController,
                  ),
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(
          //     bottom: 50,
          //   ),
          //   child: TextButton.icon(
          //     style: ButtonStyle(
          //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //         RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(18.0),
          //         ),
          //       ),
          //       backgroundColor:
          //           MaterialStatePropertyAll(Color.fromARGB(70, 0, 0, 0)),
          //     ),
          //     onPressed: () {},
          //     icon: Icon(
          //       Icons.delete,
          //       color: Colors.red,
          //     ),
          //     label: Text(
          //       'Delete Page',
          //       style: TextStyle(color: Colors.black),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
