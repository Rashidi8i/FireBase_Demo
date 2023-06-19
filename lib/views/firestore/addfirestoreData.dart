// ignore_for_file: non_constant_identifier_names

import 'package:firebase_project/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/utils.dart';

class AddFirestoreData extends StatefulWidget {
  const AddFirestoreData({super.key});

  @override
  State<AddFirestoreData> createState() => _AddFirestoreDataState();
}

class _AddFirestoreDataState extends State<AddFirestoreData> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  bool loading = false;
  final fireStore = FirebaseFirestore.instance
      .collection('users'); //this will make table in firestore with name 'uers'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Firestore User'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.logout))],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                  hintText: 'Enter name', border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: ageController,
              decoration: const InputDecoration(
                  hintText: 'Enter age', border: OutlineInputBorder()),
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
                fireStore.doc(id).set({
                  'id': id,
                  'name': nameController.text.toString(),
                  'age': ageController.text.toString(),
                }).then((value) {
                  setState(() {
                    loading = false;
                    nameController.clear();
                    ageController.clear();
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
