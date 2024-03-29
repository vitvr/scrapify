/* main file, app is initialized here */

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:scrapify/Login/intial_auth.dart';
import 'package:scrapify/utils/colors.dart';
import 'utils/firebase_options.dart';
import 'package:material_color_generator/material_color_generator.dart';

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        primarySwatch: generateMaterialColor(color: const CustomColors().light),
      ),
      home: const InitialAuth(),
      builder: EasyLoading.init(),
    );
  }
}
