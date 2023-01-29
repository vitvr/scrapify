/* page for registering with email and password */

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:scrapify/mainpage.dart';

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

  String? uid = '';

  void register() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      uid = credential.user?.uid;
    } on FirebaseAuthException {
      // Should avoid empty try blocks like this
    }
    await ref.set({
      uid: {
        "username": usernameController.text,
        "email": emailController.text,
        "followers": 0,
        "following": 0
      }
    });
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 75),
                  child: Image(image: AssetImage('assets/mainLogoNoBG.png')),
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
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                      ),
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
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Confirm Password',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 55),
                  child: Text(
                    'By registering, you agree to Scrapify\'s Terms and '
                    'Conditions and Privacy Policy.',
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(191, 255, 99, 61),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    minimumSize: const Size(1000000, 50),
                  ),
                  onPressed: () {
                    if (passwordController.text == passwordController2.text) {
                      register();
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
                    }
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
