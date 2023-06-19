import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_project/widgets/round_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

import '../../utils/utils.dart';
import '../auth/loginview.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? _image;
  bool loading = false;
  final auth = FirebaseAuth.instance;

  final picker = ImagePicker();
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref('Post2');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  Future getGalleryImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        if (kDebugMode) {
          print('Some error!');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Images'),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Utils.toastMessage('SigningOut!');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginView()));
                }).onError((error, stackTrace) {
                  Utils.toastMessage(error.toString());
                }).catchError((error) {
                  Utils.toastMessage(error.toString());
                });
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(
            child: InkWell(
              onTap: () {
                getGalleryImage();
              },
              child: Container(
                width: 200,
                height: 200,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: _image != null
                    ? Image.file(_image!.absolute)
                    : const Center(
                        child: Icon(
                          Icons.image,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          RoundButton(
              loading: loading,
              title: 'Upload',
              onPress: () {
                setState(() {
                  loading = true;
                });
                String id = DateTime.now().millisecondsSinceEpoch.toString();

                firebase_storage.Reference ref = firebase_storage
                    .FirebaseStorage.instance
                    .ref('/images/' + id);
                firebase_storage.UploadTask uploadTask =
                    ref.putFile(_image!.absolute);

                Future.value(uploadTask).then((value) async {
                  var newUrl = await ref.getDownloadURL();

                  databaseReference.child(id).set(
                      {'id': id, 'title': newUrl.toString()}).then((value) {
                    Utils.toastMessage('Image uploaded!');
                    setState(() {
                      loading = false;
                    });
                  }).onError((error, stackTrace) {
                    Utils.toastMessage(error!.toString());
                    setState(() {
                      loading = false;
                    });
                  }).catchError((error) {
                    Utils.toastMessage(error!.toString());
                    setState(() {
                      loading = false;
                    });
                  });
                }).onError((error, stackTrace) {
                  Utils.toastMessage(error!.toString());
                  setState(() {
                    loading = false;
                  });
                }).catchError((error) {
                  Utils.toastMessage(error!.toString());
                  setState(() {
                    loading = false;
                  });
                });
                ;
              })
        ]),
      ),
    );
  }
}
