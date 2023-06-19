// ignore_for_file: non_constant_identifier_names

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_project/utils/utils.dart';
import 'package:firebase_project/views/auth/loginview.dart';
import 'package:firebase_project/widgets/round_button.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final postController = TextEditingController();
  bool loading = false;
  final databaseRef_Post1 = FirebaseDatabase.instance.ref(
      'Post2'); //this will make table in firebase database with name 'post'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add post'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.logout))],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: const InputDecoration(
                  hintText: 'what is in your mind?',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            RoundButton(
              title: 'Add',
              onPress: () {
                setState(() {
                  loading = true;
                });
                String id = DateTime.now().millisecondsSinceEpoch.toString();
                databaseRef_Post1.child(id).set({
                  'title': postController.text,
                  'Icon': 'const Icon(Icons.ac_unit_sharp)',
                  'id': id
                }).then((value) {
                  setState(() {
                    loading = false;
                    postController.clear();
                  });
                  Utils.toastMessage('Post Added!');
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
              },
              loading: loading,
            )
          ],
        ),
      ),
    );
  }
}
