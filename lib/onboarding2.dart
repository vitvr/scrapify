import 'package:flutter/material.dart';
import 'package:scrapify/register.dart';
import 'package:scrapify/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scrapify/homepage.dart';

// Packages for carousel
import 'package:scrapify/utils/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingPage2 extends StatefulWidget {
  const OnBoardingPage2({super.key});

  @override
  State<OnBoardingPage2> createState() => _OnBoardingPage2State();
}

class _OnBoardingPage2State extends State<OnBoardingPage2> {
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CarouselSlider(
                      items: carouselCards.map((card) {
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
                          height: MediaQuery.of(context).size.height * 0.60,
                          viewportFraction: 1,
                          enableInfiniteScroll: false,
                          onPageChanged: (index, reason) =>
                              setState(() => activeIndex = index)),
                      carouselController: _controller,
                    ),
                    const SizedBox(height: 15),
                    buildIndicator()
                  ],
                ),
                LayoutBuilder(builder: (context, constraints) {
                  return Container(
                    width: constraints.maxWidth * 0.8,
                    child: Column(children: [
                      const SizedBox(height: 20),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(191, 255, 99, 61),
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0)),
                          ),
                          minimumSize: const Size(1000000, 40),
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
                      const SizedBox(height: 0),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(64, 255, 99, 61),
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0)),
                          ),
                          minimumSize: const Size(1000000, 40),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Log in',
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
                      const SizedBox(height: 10),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0)),
                            side: BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            ),
                          ),
                          minimumSize: const Size(1000000, 40),
                        ),
                        onPressed: () async {
                          await signInWithGoogle();
                          await FirebaseAuth.instance
                              .authStateChanges()
                              .listen((User? user) {
                            if (user == null) {
                              print('NO SUCH USER');
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
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
  final carouselCards = [
    const Card1(),
    const Card2(),
    const Card3(),
    const Card4(),
    const Card5(),
  ];

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
        count: carouselCards.length,
        effect: const ExpandingDotsEffect(
            activeDotColor: Colors.black,
            dotHeight: 8,
            dotWidth: 8,
            expansionFactor: 3),
      );
}

// Below are the generated carousel cards for onboarding

class Card1 extends StatelessWidget {
  const Card1({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: const <Widget>[
        Image(image: AssetImage('assets/onboarding1.png')),
        Align(
            heightFactor: 1.4,
            alignment: Alignment.centerLeft,
            child: Text("Welcome to Scrapify",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: 'Inter',
                    height: 1.2,
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w800))),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
                "Where your memories are preserved, arranged, and presented in the form of AR scrapbooks.",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500))),
      ],
    );
  }
}

class Card2 extends StatelessWidget {
  const Card2({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: const <Widget>[
        Image(image: AssetImage('assets/onboarding2.png')),
        Align(
            heightFactor: 1.4,
            alignment: Alignment.centerLeft,
            child: Text("Express yourself freely",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: 'Inter',
                    height: 1.2,
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w800))),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
                "Share your perspectives of the world with your family, friends, and people around the world.",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500))),
      ],
    );
  }
}

class Card3 extends StatelessWidget {
  const Card3({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: const <Widget>[
        Image(image: AssetImage('assets/onboarding3.png')),
        Align(
            heightFactor: 1.4,
            alignment: Alignment.centerLeft,
            child: Text("Showcase your collections",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: 'Inter',
                    height: 1.2,
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w800))),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
                "Whether you’re a hobbyist or an institution, there’s an opportunity to show your content to the world.",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500))),
      ],
    );
  }
}

class Card4 extends StatelessWidget {
  const Card4({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: const <Widget>[
        Image(image: AssetImage('assets/onboarding4.png')),
        Align(
            heightFactor: 1.4,
            alignment: Alignment.centerLeft,
            child: Text("Interact with your communities",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: 'Inter',
                    height: 1.2,
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w800))),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
                "Found an interesting scrapbook? Let the creators know you like and support their content.",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500))),
      ],
    );
  }
}

class Card5 extends StatelessWidget {
  const Card5({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: const <Widget>[
        Image(image: AssetImage('assets/onboarding5.png')),
        Align(
            heightFactor: 1.4,
            alignment: Alignment.centerLeft,
            child: Text("Travel the world without traveling",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: 'Inter',
                    height: 1.2,
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w800))),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
                "Discover and experience different scrapbooks created by people around the world",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500))),
      ],
    );
  }
}
