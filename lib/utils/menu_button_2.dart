// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:scrapify/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuButton2 extends StatefulWidget {
  IconData icon = Icons.error;
  String text = '';
  Widget page = Container();
  final bool link;
  MenuButton2({
    Key? key,
    required this.icon,
    required this.text,
    required this.page,
    required this.link,
  }) : super(key: key);

  @override
  State<MenuButton2> createState() => _MenuButton2State();
}

class _MenuButton2State extends State<MenuButton2> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width.toDouble() * 0.02,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.455,
        height: MediaQuery.of(context).size.height * 0.13,
        child: Stack(
          children: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const CustomColors().light,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
              ),
              // use 'page' here
              onPressed: () async {
                if (!widget.link) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => widget.page,
                    ),
                  );
                } else {
                  String url =
                      'https://www.app-privacy-policy.com/live.php?token=mrpb4oFuilj5OpJWNuWnp1AeK10CeIRN';
                  Uri uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    throw 'Could not launch $url';
                  }
                }
              },
              child: Container(),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width.toDouble() * 0.03,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    widget.icon,
                    color: Colors.black,
                    size: MediaQuery.of(context).size.width.toDouble() * 0.12,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width.toDouble() * 0.01,
                    ),
                    child: Text(
                      widget.text,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
