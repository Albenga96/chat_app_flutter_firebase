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
            List<List<dynamic>> ids = [];
            for (var element in (snapshot.data as QuerySnapshot).docs) {
              ids.add(element['partecipants']);
            }

            return ListView.builder(
                itemCount: (snapshot.data as QuerySnapshot).docs.length,
                itemBuilder: (context, index) {
                  ids[index].removeWhere((element) =>
                      element == FirebaseAuth.instance.currentUser!.uid);
                  return ListTile(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatPage(
                          chatRoomId:
                              (snapshot.data as QuerySnapshot).docs[index].id,
                        ),
                      ),
                    ),
                    title: FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(ids[index][0])
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          return Text(
                            (snapshot.data as DocumentSnapshot)['name'],
                          );
                        } else {
                          return const Text('');
                        }
                      },
                    ),
                  );
                });
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
