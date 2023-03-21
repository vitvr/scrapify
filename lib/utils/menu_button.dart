// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:scrapify/utils/colors.dart';

class MenuButton extends StatelessWidget {
  IconData icon = Icons.error;
  String text = '';
  Widget page = Container();
  MenuButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.page,
  }) : super(key: key);

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
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => page,
                  ),
                );
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
                    icon,
                    color: Colors.black,
                    size: MediaQuery.of(context).size.width.toDouble() * 0.12,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width.toDouble() * 0.01,
                    ),
                    child: Text(
                      text,
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
