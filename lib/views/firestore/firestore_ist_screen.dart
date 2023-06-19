import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_project/utils/utils.dart';
import 'package:firebase_project/views/auth/loginview.dart';
import 'package:firebase_project/views/firestore/addfirestoreData.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreScreen extends StatefulWidget {
  const FirestoreScreen({super.key});

  @override
  State<FirestoreScreen> createState() => _FirestoreScreenState();
}

class _FirestoreScreenState extends State<FirestoreScreen> {
  final auth = FirebaseAuth.instance;
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('users').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddFirestoreData()));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('FireStore Post'),
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
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: fireStore,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  Utils.toastMessage('some error!');
                }
                return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var name =
                              snapshot.data!.docs[index]['name'].toString();
                          var age =
                              snapshot.data!.docs[index]['age'].toString();
                          var id = snapshot.data!.docs[index]['id'].toString();
                          return ListTile(
                              title: Text(
                                  'Name: ${snapshot.data!.docs[index]['name'].toString()}'),
                              subtitle: Text(
                                  'Age: ${snapshot.data!.docs[index]['age'].toString()}'),
                              trailing: PopupMenuButton(
                                icon: const Icon(Icons.more_vert_outlined),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                      child: ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      showMyDialog(name, age, id);
                                    },
                                    leading: const Icon(Icons.edit),
                                    title: const Text('Edit'),
                                  )),
                                  PopupMenuItem(
                                      child: ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      ref.doc(id).delete().then((value) {
                                        Utils.toastMessage('Post Deleted!');
                                      }).onError((error, stackTrace) {
                                        Utils.toastMessage(error!.toString());
                                        setState(() {
                                          // loading = false;
                                        });
                                      }).catchError((error) {
                                        Utils.toastMessage(error!.toString());
                                        setState(() {
                                          // loading = false;
                                        });
                                      });
                                    },
                                    leading: const Icon(Icons.delete),
                                    title: const Text('Delete'),
                                  ))
                                ],
                              ));
                        }));
              }),
        ],
      ),
    );
  }

  Future<void> showMyDialog(String name, String age, String id) async {
    nameController.text = name;
    ageController.text = age;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update'),
            content: Container(
              height: 200,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                  ),
                  TextFormField(
                    controller: ageController,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    ref.doc(id).update({
                      'name': nameController.text.toString(),
                      'age': ageController.text.toString()
                    }).then((value) {
                      Utils.toastMessage('Post Updated!');
                    }).onError((error, stackTrace) {
                      Utils.toastMessage(error!.toString());
                      setState(() {
                        // loading = false;
                      });
                    }).catchError((error) {
                      Utils.toastMessage(error!.toString());
                      setState(() {
                        // loading = false;
                      });
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Update')),
            ],
          );
        });
  }
}
