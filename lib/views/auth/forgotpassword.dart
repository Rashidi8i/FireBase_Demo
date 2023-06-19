import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/utils/utils.dart';
import 'package:firebase_project/widgets/round_button.dart';
import 'package:flutter/material.dart';

class ForgotPassowrd extends StatefulWidget {
  const ForgotPassowrd({super.key});

  @override
  State<ForgotPassowrd> createState() => _ForgotPassowrdState();
}

class _ForgotPassowrdState extends State<ForgotPassowrd> {
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.mail),
                hintText: 'Email',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Email';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
              onPress: () {
                auth
                    .sendPasswordResetEmail(
                        email: emailController.text.toString())
                    .then((value) {
                  Utils.toastMessage('email send');
                  setState(() {
                    loading = false;
                  });
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const PostView()));
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
              title: 'forget',
            ),
          ],
        ),
      ),
    );
  }
}
