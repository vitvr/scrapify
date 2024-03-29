// ignore_for_file: unused_import

/* this page contains the bottom navigation bar and the app bar (TODO);
other pages are built inside this one, this is so the navigation and app bar do
not have to be rebuilt when moving to another page */

import 'package:flutter/material.dart';
import 'package:scrapify/screens/homepage_screen.dart';
import 'package:scrapify/screens/ar_screen.dart';
import 'package:scrapify/screens/map_screen.dart';
import 'package:scrapify/screens/menuscreen.dart';
import 'package:scrapify/screens/Profiles/profile_personal.dart';
import 'package:scrapify/screens/Profiles/profile_general.dart';
import 'package:scrapify/utils/scrapbook_page.dart';
import 'package:scrapify/screens/search_screen.dart';
import 'package:scrapify/utils/colors.dart';
import 'package:scrapify/screens/Posts/post.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  // list of pages for the bottom navigation bar
  List<Widget> pages = [
    const HomePage(),
    const SearchPage(), // placeholder
    const MapScreen(), // placeholder
    const ProfilePersonal(),
    const Menu(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: const CustomColors().dark,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
      ),
      // this page contains other pages within it
      body: pages[currentIndex],
    );
  }
}
