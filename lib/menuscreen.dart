import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scrapify/bookmarks.dart';
import 'package:scrapify/followers.dart';
import 'package:scrapify/homepage.dart';
import 'package:scrapify/onboarding.dart';
import 'package:scrapify/utils/colors.dart';
import 'package:scrapify/utils/menu_button.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String profImage = "";

  Future<void> fetchData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    profImage = snapshot.get('profImage');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(14, 255, 99, 61),
        appBar: AppBar(
          title: const Image(
            image: AssetImage('assets/mainLogoNoLogo.png'),
            height: 35,
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          actions: [
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(Icons.notification_add_outlined),
            // ),
            (profImage != "")
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 5,
                    ),
                    child: FittedBox(
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          profImage,
                        ),
                      ),
                    ),
                  )
                : CircularProgressIndicator(),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MenuButton(
                    icon: Icons.person_outline,
                    text: 'Followers',
                    page: FollowersPage(following: false),
                  ),
                  MenuButton(
                    icon: Icons.person,
                    text: 'Following',
                    page: FollowersPage(following: true),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MenuButton(
                    icon: Icons.bookmark,
                    text: 'Bookmarks',
                    page: BookmarkPage(),
                  ),
                  MenuButton(
                    icon: Icons.help,
                    text: 'Help & Support',
                    page: HomePage(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MenuButton(
                    icon: Icons.insert_page_break_rounded,
                    text: 'Terms & Policies',
                    page: HomePage(),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.width.toDouble() * 0.02,
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const CustomColors().dark,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const OnboardingPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Log out',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class Menu extends StatefulWidget {
//   const Menu({super.key});
//   @override
//   State<Menu> createState() => _MenuState();
// }

// class _MenuState extends State<Menu> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: Scaffold(
//         backgroundColor: const Color.fromARGB(14, 255, 99, 61),
//         floatingActionButton: FloatingActionButton(
//           backgroundColor: const Color.fromARGB(255, 255, 99, 61),
//           child: const Icon(Icons.create),
//           onPressed: () {
//             FirebaseAuth.instance.signOut();
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => const OnboardingPage(),
//               ),
//             );
//           },
//         ),
//         appBar: AppBar(
//           title: const Text(
//             'SCRAPIFY',
//             style: TextStyle(fontSize: 35),
//           ),
//           automaticallyImplyLeading: false,
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black,
//           actions: [
//             IconButton(
//               onPressed: () {},
//               icon: const Icon(Icons.notification_add_outlined),
//             ),
//           ],
//         ),
//         body: Container(
//           child: Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: GridView(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       color: Color.fromARGB(64, 255, 99, 61),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.person_outline,
//                           size: 40,
//                           color: Colors.black,
//                         ),
//                         // Padding(padding: const EdgeInsets.all(20),),
//                         Text(
//                           "Followers",
//                           style: TextStyle(color: Colors.black, fontSize: 15),
//                         )
//                       ],
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       color: Color.fromARGB(64, 255, 99, 61),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Icon(
//                           Icons.person,
//                           size: 40,
//                           color: Colors.black,
//                         ),
//                         Text(
//                           "Following",
//                           style: TextStyle(color: Colors.black, fontSize: 15),
//                         )
//                       ],
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       color: Color.fromARGB(64, 255, 99, 61),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.people,
//                           size: 40,
//                           color: Colors.black,
//                         ),
//                         Text(
//                           "Groups",
//                           style: TextStyle(color: Colors.black, fontSize: 15),
//                         )
//                       ],
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       color: Color.fromARGB(64, 255, 99, 61),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.map,
//                           size: 40,
//                           color: Colors.black,
//                         ),
//                         Text(
//                           "Geocatching",
//                           style: TextStyle(color: Colors.black, fontSize: 15),
//                         )
//                       ],
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       color: Color.fromARGB(64, 255, 99, 61),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.bookmarks,
//                           size: 40,
//                           color: Colors.black,
//                         ),
//                         Text(
//                           "Bookmarks",
//                           style: TextStyle(color: Colors.black, fontSize: 15),
//                         )
//                       ],
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       color: Color.fromARGB(64, 255, 99, 61),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.settings,
//                           size: 40,
//                           color: Colors.black,
//                         ),
//                         Text(
//                           "Settings",
//                           style: TextStyle(color: Colors.black, fontSize: 15),
//                         )
//                       ],
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       color: Color.fromARGB(64, 255, 99, 61),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.help,
//                           size: 40,
//                           color: Colors.black,
//                         ),
//                         Text(
//                           "Help & Support",
//                           textAlign: TextAlign.right,
//                           style: TextStyle(color: Colors.black, fontSize: 15),
//                         )
//                       ],
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       color: Color.fromARGB(64, 255, 99, 61),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.document_scanner,
//                           size: 40,
//                           color: Colors.black,
//                         ),
//                         Text(
//                           "Terms & Policies",
//                           style: TextStyle(color: Colors.black, fontSize: 15),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//                 gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//                     maxCrossAxisExtent: 220,
//                     childAspectRatio: 3 / 2,
//                     crossAxisSpacing: 20,
//                     mainAxisSpacing: 30)),
//           ),
//         ),
//       ),
//     );
//   }
// }
