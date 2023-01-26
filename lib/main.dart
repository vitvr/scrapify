import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scrapify/intial_auth.dart';
import 'package:scrapify/utils/template.dart';
import 'firebase_options.dart';
// import 'package:scrapify/onboarding2.dart';

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
      title: 'Scrapify',
      theme: ThemeData(
        fontFamily: 'Inter',
        primarySwatch: Colors.pink,
      ),
      home: const InitialAuth(),
    );
  }
}
