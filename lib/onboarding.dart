import 'package:flutter/material.dart';
import 'package:scrapify/register.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Image(image: AssetImage('assets/parrot.png')),
            const Text(
              'Welcome to Scrapify',
              style: TextStyle(fontSize: 50),
            ),
            const Text(
                'Where your memories are preserved, arranged, and presented in'
                'the form of Scrapbooks',
                style: TextStyle(fontSize: 20)),
            const Padding(padding: EdgeInsets.only(top: 12)),
            Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegisterPage()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        minimumSize: const Size(300, 45)),
                    child: const Text('Register')),
                const Padding(padding: EdgeInsets.all(4)),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegisterPage()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        minimumSize: const Size(300, 45)),
                    child: const Text('Login')),
              ],
            )
          ],
        ),
      ),
    )));
  }
}
