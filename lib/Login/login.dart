// ignore_for_file: use_build_context_synchronously, must_call_super

/* page for logging in with email and password */

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scrapify/Login/forgotPass.dart';
import 'package:scrapify/mainpage.dart';
import 'package:scrapify/Login/register.dart';
import 'package:scrapify/utils/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late bool passwordVisible;

  void signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.waving_hand_sharp, color: Colors.white, size: 32),
              SizedBox(width: 10),
              Text(
                'Welcome Back!',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    } on FirebaseAuthException {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.error_outline, color: Colors.white, size: 32),
              SizedBox(width: 10),
              Text(
                "Wrong email or password",
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
    }
  }

  @override
  void initState() {
    passwordVisible = false;
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
                  MediaQuery.of(context).size.width * 0.05,
                  MediaQuery.of(context).size.width * 0.075,
                  0),
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
                      padding: const EdgeInsets.only(left: 16.0),
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
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width * 0.075),
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordPage(),
                              ),
                            );
                          },
                          style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                  const CustomColors().extremelyLight)),
                          child: RichText(
                            text: TextSpan(
                                text: 'Forgot your password? ',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Click here',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: const CustomColors().dark)),
                                  const TextSpan(text: '.')
                                ]),
                          ))),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const CustomColors().dark,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      minimumSize: const Size(1000000, 50),
                    ),
                    onPressed: () {
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
                      'Log in',
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
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                          style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                  const CustomColors().extremelyLight)),
                          child: RichText(
                            text: TextSpan(
                                text: 'Don\'t have an account yet? ',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Register here',
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
}
