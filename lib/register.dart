import 'package:flutter/material.dart';
import 'package:scrapify/homepage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
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
                  child: Image(image: AssetImage('assets/mainLogo.png')),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(64, 255, 99, 61),
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '\t\t\t\t\tUsername',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(64, 255, 99, 61),
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '\t\t\t\t\tEmail Address',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(64, 255, 99, 61),
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '\t\t\t\t\tPassword',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(64, 255, 99, 61),
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '\t\t\t\t\tConfirm Password',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  child: Text(
                    'By registering, you agree to Scrapify\'s Terms and'
                    'Conditions and Privacy Policy.',
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(191, 255, 99, 61),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    minimumSize: Size(1000000, 50),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomePage()),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}