// ignore_for_file: prefer_const_literals_to_create_immutables, use_build_context_synchronously, must_call_super

/* page for registering with email and password */

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scrapify/Login/login.dart';
import 'package:scrapify/mainpage.dart';
import 'package:scrapify/utils/colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController2 = TextEditingController();

  final usernameController = TextEditingController();

  final ref = FirebaseDatabase.instance.ref('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? uid = '';
  late bool passwordVisible;
  late bool confirmPasswordVisible;
  bool registered = false;
  Future<void> register() async {
    try {
      // Check if the username is already taken
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: usernameController.text.toLowerCase())
          .get();

      QuerySnapshot snapshot1 = await _firestore
          .collection('users')
          .where('email', isEqualTo: emailController.text)
          .get();

      if (snapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 32),
                const SizedBox(width: 10),
                const Text(
                  'Username already taken',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
        return;
      }

      if (snapshot1.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 32),
                const SizedBox(width: 10),
                const Text(
                  'Account with this email already exists',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
        return;
      }
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Add the user to firestore database
      await _firestore.collection('users').doc(cred.user!.uid).set({
        'username': usernameController.text.toLowerCase(),
        'uid': cred.user!.uid,
        'email': emailController.text,
        'profImage':
            'https://firebasestorage.googleapis.com/v0/b/scrapify-9bcaa.appspot.com/o/Default_pfp.svg.png?alt=media&token=5f34d45e-9105-4a70-901a-1cbc8ce4866b',
        'header':
            'https://firebasestorage.googleapis.com/v0/b/scrapify-9bcaa.appspot.com/o/Grey_full.png?alt=media&token=cf4a2d92-cbd5-4588-aa26-19fe0182177b',
        'bio': "available",
        'bookmarks': [],
        'posts': [],
        'followers': [],
        'following': [],
      });
    } on FirebaseAuthException {
      // Handle FirebaseAuthException
    }
  }

  void signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException {
      // Should avoid empty try blocks like this
    }
  }

  @override
  void initState() {
    passwordVisible = false;
    confirmPasswordVisible = false;
  }

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
                    MediaQuery.of(context).size.width * 0.125,
                    MediaQuery.of(context).size.width * 0.075,
                    0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 75),
                      child:
                          Image(image: AssetImage('assets/mainLogoNoBG.png')),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(64, 255, 99, 61),
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: TextField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Username',
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
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                        child: TextField(
                          controller: passwordController,
                          obscureText: !passwordVisible,
                          decoration: InputDecoration(
                              isDense: true,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              border: InputBorder.none,
                              hintText: 'Password',
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                  },
                                  icon: Icon(
                                    passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.black,
                                  ))),
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
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: TextField(
                          controller: passwordController2,
                          obscureText: !confirmPasswordVisible,
                          decoration: InputDecoration(
                              isDense: true,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              border: InputBorder.none,
                              hintText: 'Confirm Password',
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      confirmPasswordVisible =
                                          !confirmPasswordVisible;
                                    });
                                  },
                                  icon: Icon(
                                    confirmPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.black,
                                  ))),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.085),
                        child: RichText(
                          text: TextSpan(
                              text: 'By registering, you agree to Scrapify\'s ',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Terms and Conditions',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: const CustomColors().dark)),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: const CustomColors().dark)),
                                const TextSpan(text: '.')
                              ]),
                        )),
                    const SizedBox(height: 15),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 99, 61),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        minimumSize: const Size(1000000, 50),
                      ),
                      onPressed: () async {
                        if (passwordController.text !=
                            passwordController2.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  const Icon(Icons.error_outline,
                                      color: Colors.white, size: 32),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Passwords do not match',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ],
                              ),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          );
                          return;
                        }
                        await register();
                        signIn();
                        FirebaseAuth.instance
                            .authStateChanges()
                            .listen((User? user) {
                          if (user == null) {
                            // print('NO SUCH USER');
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const MainPage(),
                              ),
                            );
                          }
                        });
                      },
                      child: const Text(
                        'Register',
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
                flex: 1,
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
                                      text: 'Already have an account? ',
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.black),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Log in here',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    const CustomColors().dark)),
                                        const TextSpan(text: '.')
                                      ]),
                                ))))
                  ],
                ))
          ]),
        ),
      ),
    );
  }
}
