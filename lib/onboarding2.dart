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
                    CarouselSlider.builder(
                        itemCount: carouselImages.length,
                        options: CarouselOptions(
                            height: 350,
                            viewportFraction: 1,
                            enableInfiniteScroll: false,
                            onPageChanged: (index, reason) =>
                                setState(() => activeIndex = index)),
                        itemBuilder: ((context, index, realIndex) {
                          final carouselImage = carouselImages[index];
                          return buildImage(carouselImage, index);
                        }),
                        carouselController: _controller),
                    ElevatedButton(
                        onPressed: () => _controller.nextPage(),
                        child: Text("→"),
                        style: size),
                    const SizedBox(height: 20),
                    buildIndicator()
                  ],
                ),

                // const Image(image: AssetImage('assets/parrot.png')),
                // const SizedBox(height: 20),
                // const Text(
                //   'Welcome to Scrapify',
                //   style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(height: 10),
                // const Text(
                //   'Where your memories are preserved, arranged, and presented'
                //   ' in the form of scrapbooks.',
                //   style: TextStyle(fontSize: 16),
                // ),

                const SizedBox(height: 50),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(191, 255, 99, 61),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    minimumSize: const Size(1000000, 50),
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
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(64, 255, 99, 61),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    minimumSize: const Size(1000000, 50),
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
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'or',
                ),
                const SizedBox(height: 10),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      side: BorderSide(
                        color: Colors.black,
                        width: 1.5,
                      ),
                    ),
                    minimumSize: const Size(1000000, 50),
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
                        width: 30.0,
                        height: 30.0,
                      ),
                      SizedBox(width: 20),
                      Text(
                        'Continue with Google',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int activeIndex = 0;
  final CarouselController _controller = CarouselController();

  final carouselImages = [
    const AssetImage('assets/onboarding1.png'),
    const AssetImage('assets/onboarding2.png'),
    const AssetImage('assets/onboarding3.png'),
    const AssetImage('assets/onboarding4.png')
  ];

  Widget buildImage(AssetImage imagePath, int index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Image(image: carouselImages[index]),
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: carouselImages.length,
        effect: const ExpandingDotsEffect(
            activeDotColor: Colors.black,
            dotHeight: 10,
            dotWidth: 10,
            expansionFactor: 3),
      );
}
