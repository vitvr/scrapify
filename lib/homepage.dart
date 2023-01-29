/* the homepage of the app, it includes a feed of recommended posts as well as
the option to create new ones */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scrapify/onboarding.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(14, 255, 99, 61),
        // currently, the 'create scrapbook' button is being used as a
        // placeholder sign out button
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 255, 99, 61),
          child: const Icon(Icons.create),
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const OnboardingPage(),
              ),
            );
          },
        ),
        appBar: AppBar(
          title: const Text(
            'SCRAPIFY',
            style: TextStyle(fontSize: 35),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notification_add_outlined),
            ),
          ],
        ),
        // backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.separated(
                // scrollDirection: Axis.horizontal,
                itemCount: 20,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10);
                },
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      createBox(index),
                      createBox(index + 1), // this wont work on actual post
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // creates boxes of random colors, placeholder for actual posts
  Padding createBox(int index) {
    Color c = Colors.black;
    if (index % 3 == 0) {
      c = Colors.red;
    } else if (index % 3 == 1) {
      c = Colors.green;
    } else if (index % 3 == 2) {
      c = Colors.blue;
    }
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        color: c,
        child: const SizedBox(
          height: 150,
          width: 150,
        ),
      ),
    );
  }
}
