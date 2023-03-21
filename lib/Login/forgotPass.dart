// ignore_for_file: unused_catch_clause, use_build_context_synchronously

/* page for password reset */

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scrapify/Login/login.dart';
import 'package:scrapify/Login/resetPass.dart';
import 'package:scrapify/utils/colors.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

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
                  MediaQuery.of(context).size.width * 0.075,
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
                        text: 'Let\'s find your account\n',
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
                                  'Please enter the email address associated with your account.',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black))
                        ]),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(64, 255, 99, 61),
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email Address',
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(64, 255, 99, 61),
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const CustomColors().dark,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      minimumSize: const Size(1000000, 50),
                    ),
                    onPressed: () async {
                      resetPassword();
                    },
                    child: const Text(
                      'Reset Password',
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
          Expanded(
              child: Column(
            children: [
              Expanded(flex: 3, child: Container()),
              Expanded(
                  flex: 7,
                  child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                  const CustomColors().extremelyLight)),
                          child: RichText(
                            text: TextSpan(
                                text: 'Have you remembered your password? ',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Log in here',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: const CustomColors().dark)),
                                  const TextSpan(text: '.')
                                ]),
                          ))))
            ],
          ))
        ])),
      ),
    );
  }

  Future resetPassword() async {
    showDialog(
        context: context,
        barrierDismissible: true, // Make this false after testing
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ResetPasswordPage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // ignore: todo
      // TODO
    }
  }
}
