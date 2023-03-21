// ignore_for_file: avoid_print, await_only_futures, must_be_immutable, unnecessary_nullable_for_final_variable_declarations

/* welcoming page shown to new users before they log-in to an account, includes
google authentication */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrapify/mainpage.dart';
import 'package:scrapify/Login/register.dart';
import 'package:scrapify/Login/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auto_size_text/auto_size_text.dart';

// Packages for carousel
import 'package:scrapify/utils/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// WARNING
// Keep this false unless debugging.
//
// Usage:
// For applying colors on different containers
// for measurement accuracy
bool debuggingOn = false;

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? user = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await user!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> register() async {
    String email = FirebaseAuth.instance.currentUser!.email!;
    String name = FirebaseAuth.instance.currentUser!.displayName!.toLowerCase();
    try {
      // Add the user to firestore database
      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        'username': name,
        'uid': _auth.currentUser!.uid,
        'email': email,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            color: debuggingOn ? Colors.blueAccent : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CarouselSlider(
                      items: cards.map((card) {
                        return Builder(builder: (BuildContext context) {
                          return SizedBox(
                              width: MediaQuery.of(context).size.width * 0.80,
                              child: Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0)),
                                child: card,
                              ));
                        });
                      }).toList(),
                      options: CarouselOptions(
                          initialPage: 0,
                          height: MediaQuery.of(context).size.height * 0.55,
                          viewportFraction: 1,
                          enableInfiniteScroll: false,
                          onPageChanged: (index, reason) =>
                              setState(() => activeIndex = index)),
                      carouselController: _controller,
                    ),
                    buildIndicator()
                  ],
                ),
                LayoutBuilder(builder: (context, constraints) {
                  return Container(
                    color: debuggingOn ? Colors.amber : null,
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: constraints.maxWidth * 0.8,
                    child: Column(children: [
                      const SizedBox(height: 20),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const CustomColors().dark,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                          ),
                          minimumSize: const Size(1000000, 45),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const CustomColors().lighter,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                          ),
                          minimumSize: const Size(1000000, 45),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'or',
                      ),
                      const SizedBox(height: 6.5),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            side: BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            ),
                          ),
                          minimumSize: const Size(1000000, 45),
                        ),
                        onPressed: () async {
                          await signInWithGoogle();
                          await register();
                          await FirebaseAuth.instance
                              .authStateChanges()
                              .listen((User? user) {
                            if (user == null) {
                              print('NO SUCH USER');
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const MainPage(),
                                ),
                              );
                            }
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Image(
                              image: AssetImage('assets/google_logo.png'),
                              width: 22.0,
                              height: 22.0,
                            ),
                            SizedBox(width: 20),
                            Text(
                              'Continue with Google',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int activeIndex = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  final CarouselController _controller = CarouselController();
  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: cards.length,
        effect: const ExpandingDotsEffect(
            activeDotColor: Colors.black,
            dotHeight: 8,
            dotWidth: 8,
            expansionFactor: 3),
      );
}

// Below are the generated carousel cards for onboarding

class CarouselCard extends StatelessWidget {
  late AssetImage img;
  late String heading;
  late String caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: 50,
                minWidth: 300,
                maxHeight: MediaQuery.of(context).size.height * 0.3,
                maxWidth: MediaQuery.of(context).size.width),
            child: Image(image: img)),
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
                child: AutoSizeText(
                  heading,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontFamily: 'Inter',
                      height: 1.1,
                      color: Colors.black,
                      fontWeight: FontWeight.w800),
                  presetFontSizes: const [32],
                  maxLines: 2,
                ))),
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 20),
                child: AutoSizeText(
                  caption,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                  presetFontSizes: const [19, 17, 14],
                  maxLines: 2,
                ))),
      ],
    );
  }

  CarouselCard(
      {super.key,
      required this.img,
      required this.heading,
      required this.caption});
}

List<CarouselCard> cards = [
  CarouselCard(
      img: const AssetImage('assets/onboarding1.png'),
      heading: "Welcome to Scrapify",
      caption:
          "Where your memories are curated and presented in the form of AR scrapbooks."),
  CarouselCard(
      img: const AssetImage('assets/onboarding2.png'),
      heading: "Express your thoughts freely",
      caption:
          "Share your perspectives of the world with people around the world."),
  CarouselCard(
      img: const AssetImage('assets/onboarding3.png'),
      heading: "Showcase your collections",
      caption:
          "Whether you’re a hobbyist or an institution, there’s an opportunity to share."),
  CarouselCard(
      img: const AssetImage('assets/onboarding4.png'),
      heading: "Interact with your communities",
      caption:
          "Found an interesting scrapbook? Let the world know you support their content."),
  CarouselCard(
      img: const AssetImage('assets/onboarding5.png'),
      heading: "Travel the world without traveling",
      caption:
          "Discover and experience scrapbooks created by people around the world.")
];
