import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scrapify/onboarding2.dart';
import 'package:scrapify/onboarding.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'scrapify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OnBoardingPage2(),
    );
  }
}
