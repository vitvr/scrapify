import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:scrapify/utils/choose_image.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  List content = [
    null,
    null,
    null,
    null,
    null,
    null,
  ];

  List cols = [
    Colors.red,
    Colors.blue,
    Colors.amber,
    Colors.white,
    Colors.black,
    Colors.green,
  ];

  List<Uint8List?> files = [
    null,
    null,
    null,
    null,
    null,
    null,
  ];

  _selectImage(BuildContext context, int index) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create Post'),
            children: [
              //camera option
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a Photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    files[index] = file;
                  });
                },
              ),

              //gallery option
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose From Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    files[index] = file;
                  });
                },
              ),
              //cancel
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Widget showImage = Container();

    if (files[2] == null) {
      showImage = Container();
    } else {
      showImage = Image(
        image: MemoryImage(files[2]!),
        fit: BoxFit.cover,
      );
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Image.network(
                    'https://static01.nyt.com/images/2020/06/30/business/30india-tech-1/30india-tech-1-articleLarge.jpg?quality=75&auto=webp&disable=upscale',
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _selectImage(context, 1);
                    },
                    iconSize: MediaQuery.of(context).size.width * 0.2,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Stack(
                    fit: StackFit.passthrough,
                    alignment: Alignment.center,
                    children: [
                      Expanded(
                        child: showImage,
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          _selectImage(context, 2);
                        },
                        iconSize: MediaQuery.of(context).size.width * 0.2,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Image.network(
                    'https://static01.nyt.com/images/2020/06/30/business/30india-tech-1/30india-tech-1-articleLarge.jpg?quality=75&auto=webp&disable=upscale',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Image.network(
                    'https://static01.nyt.com/images/2020/06/30/business/30india-tech-1/30india-tech-1-articleLarge.jpg?quality=75&auto=webp&disable=upscale',
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Image.network(
                    'https://static01.nyt.com/images/2020/06/30/business/30india-tech-1/30india-tech-1-articleLarge.jpg?quality=75&auto=webp&disable=upscale',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
