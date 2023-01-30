/* page for reset pass confirmation*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scrapify/login.dart';
import 'package:scrapify/utils/colors.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
            child: Column(children: [
          Expanded(
            flex: 9,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.075,
                  MediaQuery.of(context).size.width * 0,
                  MediaQuery.of(context).size.width * 0.075,
                  0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 75),
                    child: Image(image: AssetImage('assets/mainLogoNoBG.png')),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                        text: 'Password reset email sent\n',
                        style: TextStyle(
                            color: const CustomColors().dark,
                            fontWeight: FontWeight.w800),
                        children: const <InlineSpan>[
                          WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: SizedBox(height: 20)),
                          TextSpan(
                              text:
                                  'If the details you entered matches an account in our system, you will receive an email containing instructions on resetting your password. If you have not received an email in the last 5 minutes, feel free to have the email resent.',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black))
                        ]),
                  ),
                  const SizedBox(height: 25),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const CustomColors().dark,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      minimumSize: const Size(1000000, 50),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Back to Login',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ])),
      ),
    );
  }
}
