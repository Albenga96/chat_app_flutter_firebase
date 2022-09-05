import 'package:chat_app_flutter_firebase/pages/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CHATS',
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('chatroom')
            .where('partecipants',
                arrayContains: FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return ListView.builder(
              itemCount: (snapshot.data as QuerySnapshot).docs.length,
              itemBuilder: (context, index) => ListTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatPage(
                      chatRoomId:
                          (snapshot.data as QuerySnapshot).docs[index].id,
                    ),
                  ),
                ),
                title: Text(
                  (snapshot.data as QuerySnapshot).docs[index].id,
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
