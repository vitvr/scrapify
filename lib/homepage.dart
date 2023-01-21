import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Color.fromARGB(14, 255, 99, 61),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(191, 255, 99, 61),
          child: Icon(Icons.create),
          onPressed: () {},
        ),
        appBar: AppBar(
          // elevation: 0.0,
          // systemOverlayStyle: SystemUiOverlayStyle(
          //   statusBarColor: Colors.white,
          //   // systemNavigationBarDividerColor: Colors.white,
          // ),
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
              icon: Icon(Icons.notification_add_outlined),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Color.fromARGB(191, 255, 99, 61),
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
        // backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.separated(
                // scrollDirection: Axis.horizontal,
                itemCount: 20,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10);
                },
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      createBox(index),
                      createBox(index + 1), // this wont work on actual post
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding createBox(int index) {
    Color c = Colors.black;
    if (index % 3 == 0) {
      c = Colors.red;
    } else if (index % 3 == 1) {
      c = Colors.green;
    } else if (index % 3 == 2) {
      c = Colors.blue;
    }
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        color: c,
        child: const SizedBox(
          height: 150,
          width: 150,
        ),
      ),
    );
  }
}
