import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scrapify/onboarding.dart';

void main(List<String> args) {
  runApp(new MaterialApp(
    home: Menu(),
  ));
}

class Menu extends StatefulWidget {
  const Menu({super.key});
  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(14, 255, 99, 61),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 255, 99, 61),
          child: const Icon(Icons.create),
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const OnboardingPage(),
              ),
            );
          },
        ),
        appBar: AppBar(
          title: const Text(
            'SCRAPIFY',
            style: TextStyle(fontSize: 35),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notification_add_outlined),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: const Color.fromARGB(191, 255, 99, 61),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
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
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(64, 255, 99, 61),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 40,
                              color: Colors.black,
                            ),
                            Text(
                              "Followers",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            )
                          ])),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(64, 255, 99, 61),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.black,
                            ),
                            Text(
                              "Following",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            )
                          ])),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(64, 255, 99, 61),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people,
                              size: 40,
                              color: Colors.black,
                            ),
                            Text(
                              "Groups",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            )
                          ])),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(64, 255, 99, 61),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.map,
                              size: 40,
                              color: Colors.black,
                            ),
                            Text(
                              "Geocatching",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            )
                          ])),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(64, 255, 99, 61),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bookmarks,
                              size: 40,
                              color: Colors.black,
                            ),
                            Text(
                              "Bookmarks",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            )
                          ])),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(64, 255, 99, 61),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.settings,
                              size: 40,
                              color: Colors.black,
                            ),
                            Text(
                              "Settings",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            )
                          ])),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(64, 255, 99, 61),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.help,
                              size: 40,
                              color: Colors.black,
                            ),
                            Text(
                              "Help & Support",
                              textAlign: TextAlign.right,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            )
                          ])),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(64, 255, 99, 61),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.document_scanner,
                              size: 40,
                              color: Colors.black,
                            ),
                            Text(
                              "Terms & Policies",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            )
                          ])),
                ],
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 30)),
          ),
        ),
      ),
    );
  }
}
