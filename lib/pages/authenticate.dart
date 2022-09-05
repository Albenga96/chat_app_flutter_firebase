import 'package:chat_app_flutter_firebase/pages/chat_page.dart';
import 'package:chat_app_flutter_firebase/pages/chats_page.dart';
import 'package:chat_app_flutter_firebase/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatelessWidget {
  Authenticate({Key? key}) : super(key: key);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      return const ChatsPage();
    } else {
      return const LoginPage();
    }
  }
}
