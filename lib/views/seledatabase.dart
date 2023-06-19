import 'package:firebase_database/ui/firebase_sorted_list.dart';
import 'package:firebase_project/views/firestore/firestore_ist_screen.dart';
import 'package:firebase_project/views/post/postview.dart';
import 'package:flutter/material.dart';

class SelectClass extends StatefulWidget {
  const SelectClass({super.key});

  @override
  State<SelectClass> createState() => _SelectClassState();
}

class _SelectClassState extends State<SelectClass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Data base'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            child: Text('Firebase Database'),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const PostView()));
            },
          ),
          ElevatedButton(
            child: const Text('FirebaseFirestore Database'),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FirestoreScreen()));
            },
          ),
        ],
      ),
    );
  }
}
