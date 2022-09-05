import 'package:chat_app_flutter_firebase/firebase_options.dart';
import 'package:chat_app_flutter_firebase/pages/authenticate.dart';
import 'package:chat_app_flutter_firebase/pages/chat_page.dart';
import 'package:chat_app_flutter_firebase/pages/chats_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Authenticate(),
    );
  }
}
