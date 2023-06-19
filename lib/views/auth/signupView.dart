import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/constants/constants.dart';
import 'package:firebase_project/utils/utils.dart';
import 'package:firebase_project/views/auth/loginview.dart';
import 'package:firebase_project/views/auth/signupview.dart';
import 'package:firebase_project/views/post/addPost.dart';
import 'package:firebase_project/widgets/round_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  bool loading = false;
  bool emailVerified = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future sendEmailverification() async {
    final user = FirebaseAuth.instance.currentUser!;
    user.sendEmailVerification().then((value) {
      Utils.toastMessage('mail send!');

      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      Utils.toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    }).catchError((error) {
      Utils.toastMessage(error!.toString());
      setState(() {
        loading = false;
      });
    });
  }

  void signup() {
    setState(() {
      loading = true;
    });
    _auth
        .createUserWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      Utils.toastMessage(value.toString());
      if (kDebugMode) {
        print(value.toString());
      }
      setState(() {
        loading = false;
        user = _auth.currentUser!;
      });
      if (!user.emailVerified) {
        user.sendEmailVerification().then((value) {
          Utils.toastMessage('mail send!');

          setState(() {
            loading = false;
          });
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPost()));
        }).onError((error, stackTrace) {
          Utils.toastMessage(error.toString());
          setState(() {
            loading = false;
          });
        }).catchError((error) {
          Utils.toastMessage(error!.toString());
          setState(() {
            loading = false;
          });
        });
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginView()));
      }
    }).onError((error, stackTrace) {
      Utils.toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    }).catchError((error) {
      Utils.toastMessage(error!.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: Container(
        height: Constants.getHeight(context),
        width: Constants.getWidth(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                  key: _formkey,
                  child: Column(
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
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          hintText: 'password',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Password';
                          }
                          return null;
                        },
                      ),
                    ],
                  )),
              const SizedBox(
                height: 30,
              ),
              RoundButton(
                loading: loading,
                onPress: () {
                  if (_formkey.currentState!.validate()) {
                    signup();
                  }
                },
                title: 'SignUp',
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginView()));
                      },
                      child: const Text('signup'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
