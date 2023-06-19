import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/views/auth/loginview.dart';
import 'package:firebase_project/views/post/postview.dart';
import 'package:firebase_project/views/seledatabase.dart';
import 'package:flutter/material.dart';

import '../views/firestore/firestore_ist_screen.dart';
import '../views/firestore/upload_image.dart';

class SplashServices {
  void islogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SelectClass())));
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginView())));
    }
  }
}
