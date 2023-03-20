// This page is for the app to check if the user is already logged in when the
// app is opened. So the user doesnt have to log in every time they open it.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scrapify/mainpage.dart';
import 'package:scrapify/onboarding.dart';

class InitialAuth extends StatelessWidget {
  const InitialAuth({super.key});

  // This widget displays either the Main page or the Onboarding page
  // depending on whether the user is logged in or not.
  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.signOut(); // I sign out on each app restart...
    // for testing purposes, remove this line when the app is done so the...
    // user stays logged in even after closing the app
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // If user is logged in, display the Main page
          // else (if user is not logged in), display the Onboarding page
          if (snapshot.hasData) {
            return const MainPage();
          } else {
            return const OnboardingPage();
          }
        },
      ),
    );
  }
}
