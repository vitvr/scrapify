import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scrapify/screens/followers.dart';
import 'package:scrapify/screens/homepage_screen.dart';
import 'package:scrapify/screens/bookmarks_screen.dart';
import 'package:scrapify/Login/onboarding.dart';
import 'package:scrapify/utils/colors.dart';
import 'package:scrapify/utils/menu_button.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String profImage = "";

  Future<void> fetchData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    profImage = snapshot.get('profImage');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(14, 255, 99, 61),
        appBar: AppBar(
          title: const Image(
            image: AssetImage('assets/mainLogoNoLogo.png'),
            height: 35,
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          actions: [
            (profImage != "")
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 5,
                    ),
                    child: FittedBox(
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          profImage,
                        ),
                      ),
                    ),
                  )
                : const CircularProgressIndicator(),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MenuButton(
                    icon: Icons.person_outline,
                    text: 'Followers',
                    page: const FollowersPage(following: false),
                  ),
                  MenuButton(
                    icon: Icons.person,
                    text: 'Following',
                    page: const FollowersPage(following: true),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MenuButton(
                    icon: Icons.bookmark,
                    text: 'Bookmarks',
                    page: const BookmarkPage(),
                  ),
                  MenuButton(
                    icon: Icons.help,
                    text: 'Help & Support',
                    page: const HomePage(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MenuButton(
                    icon: Icons.insert_page_break_rounded,
                    text: 'Terms & Policies',
                    page: const HomePage(),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.width.toDouble() * 0.02,
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const CustomColors().dark,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const OnboardingPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Log out',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
