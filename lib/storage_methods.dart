import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class Storage_Methods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);
    print('1');
    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }
    print('2');
    UploadTask uploadTask = ref.putData(file);
    print('3');

    TaskSnapshot snap = await uploadTask;

    print('4');
    String downloadUrl = await snap.ref.getDownloadURL();
    print('5');
    return downloadUrl;
  }
}
