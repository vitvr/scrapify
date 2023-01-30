import 'package:flutter/material.dart';
import 'package:scrapify/homepage.dart';
import 'package:scrapify/utils/colors.dart';
import 'package:scrapify/utils/menu_button.dart';

class NewScrapbookPage extends StatefulWidget {
  NewScrapbookPage({super.key});

  @override
  State<NewScrapbookPage> createState() => _NewScrapbookPageState();
}

class _NewScrapbookPageState extends State<NewScrapbookPage> {
  final titleController = TextEditingController();

  final captionController = TextEditingController();

  final tagController = TextEditingController();

  final List<String> visibilityList = [
    'Public',
    'Private',
  ];

  final List<String> infoTypeList = [
    'Opinion',
    'Fact',
  ];

  String visibilityValue = 'Public';

  String infoTypeValue = 'Opinion';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(14, 255, 99, 61),
        // currently, the 'create scrapbook' button is being used as a
        // placeholder sign out button
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 255, 99, 61),
          child: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
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
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.width.toDouble() * 0.025,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'I\'LL MAKE THIS PAGE LOOK NICER LATER '
                    'THIS IS A PLACEHOLDER',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage('assets/selfie.jpg'),
                        radius: 40,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jane Doe',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Row(
                            children: [
                              DropdownButton(
                                value: visibilityValue,
                                icon: Icon(Icons.arrow_downward),
                                onChanged: (value) {
                                  setState(() {
                                    visibilityValue = value.toString();
                                  });
                                },
                                items: visibilityList.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              DropdownButton(
                                value: infoTypeValue,
                                icon: Icon(Icons.arrow_downward),
                                onChanged: (value) {
                                  setState(() {
                                    infoTypeValue = value.toString();
                                  });
                                },
                                items: infoTypeList.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                            ),
                            minimumSize: const Size(50, 50),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Finish',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const CustomColors().light,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      minimumSize: Size(
                        double.infinity,
                        MediaQuery.of(context).size.height * 0.28,
                      ),
                    ),
                    onPressed: () {},
                    child: Column(
                      children: const [
                        Icon(
                          Icons.add_circle_outline,
                          color: Colors.black,
                        ),
                        Text(
                          'Add cover photo',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text('Title'),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(64, 255, 99, 61),
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    child: const Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email Address',
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  Text('Caption'),
                  Container(
                    padding: EdgeInsets.symmetric(
                        // vertical: MediaQuery.of(context).size.height * 0.1,
                        ),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(64, 255, 99, 61),
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    child: const Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email Address',
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text('Location'),
                          MenuButton(
                            icon: Icons.error,
                            text: 'PLACEHOLDER',
                            page: HomePage(),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Tags'),
                          SizedBox(
                            // height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(64, 255, 99, 61),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)),
                              ),
                              child: const Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: TextField(
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Insert text here',
                                  ),
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
