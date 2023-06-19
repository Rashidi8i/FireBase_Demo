import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_project/utils/utils.dart';
import 'package:firebase_project/views/auth/loginview.dart';
import 'package:firebase_project/views/post/addPost.dart';
import 'package:flutter/material.dart';

class PostView extends StatefulWidget {
  const PostView({super.key});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post2');
  final searchController = TextEditingController();
  final editController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPost()));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Post'),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Utils.toastMessage('log Out!');
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search',
                  border: OutlineInputBorder()),
            ),
          ),

          // Expanded(
          //     child: StreamBuilder(
          //         stream: ref.onValue,
          //         builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          //           if (!snapshot.hasData) {
          //             return const CircularProgressIndicator();
          //           } else {
          //             Map<dynamic, dynamic> map =
          //                 snapshot.data!.snapshot.value as dynamic;
          //             List<dynamic> list = [];
          //             list.clear();
          //             list = map.values.toList();
          //             return ListView.builder(
          //                 itemCount: snapshot.data!.snapshot.children.length,
          //                 itemBuilder: (context, index) {
          //                   return ListTile(
          //                     title: Text(list[index]['title']),
          //                     subtitle: Text(list[index]['Icon']),
          //                   );
          //                 });
          //           }
          //         })),
          Expanded(
            child: FirebaseAnimatedList(
              query: ref,
              defaultChild: const Center(child: Text('Loading...')),
              itemBuilder: (context, snapshot, animation, index) {
                final title = snapshot.child('title').value.toString();
                if (searchController.text.isEmpty) {
                  return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                      trailing: PopupMenuButton(
                        icon: const Icon(Icons.more_vert_outlined),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              child: ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              showMyDialog(
                                  title, snapshot.child('id').value.toString());
                            },
                            leading: const Icon(Icons.edit),
                            title: const Text('Edit'),
                          )),
                          PopupMenuItem(
                              child: ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              ref
                                  .child(snapshot.child('id').value.toString())
                                  .remove()
                                  .then((value) {
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
                } else if (title
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase())) {
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('Icon').value.toString()),
                  );
                } else {
                  return Container();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update'),
            content: Container(
              child: TextFormField(
                controller: editController,
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
                    ref
                        .child(id)
                        .update({'title': editController.text.toString()}).then(
                            (value) {
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
