import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scrapify/homepage.dart';
import 'package:scrapify/onboarding2.dart';

class InitialAuth extends StatelessWidget {
  const InitialAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return OnBoardingPage2();
          }
        },
      ),
    );
  }
}
