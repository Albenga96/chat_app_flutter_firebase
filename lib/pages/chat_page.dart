import 'package:chat_app_flutter_firebase/widgets/chat_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatelessWidget {
  ChatPage({
    Key? key,
    required this.chatRoomId,
  }) : super(key: key);
  final String chatRoomId;
  final TextEditingController _message = TextEditingController();

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": FirebaseAuth.instance.currentUser!.uid,
        "message": _message.text,
        "type": "text",
        "time": Timestamp.now(),
      };

      _message.clear();
      await FirebaseFirestore.instance
          .collection('chatroom')
          .doc('chatRoomId')
          .collection('chats')
          .add(messages);
    } else {
      print("Enter Some Text");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '',
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chatroom')
                  .doc(chatRoomId)
                  .collection('chats')
                  .orderBy("time", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> currentMessageMap =
                          snapshot.data!.docs[index].data()
                              as Map<String, dynamic>;
                      Map<String, dynamic> afterMessageMap = currentMessageMap;
                      if (index < snapshot.data!.docs.length - 1) {
                        afterMessageMap = snapshot.data!.docs[index + 1].data()
                            as Map<String, dynamic>;
                      }

                      if ((afterMessageMap['time'] as Timestamp).toDate().day ==
                          (currentMessageMap['time'] as Timestamp)
                              .toDate()
                              .day) {
                        return ChatMessages(
                          map: currentMessageMap,
                        );
                      } else {
                        return Column(
                          children: [
                            ChatMessages(
                              map: currentMessageMap,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Center(
                                child: Text(
                                  DateFormat.MMMMd().format(
                                    (afterMessageMap['time'] as Timestamp)
                                        .toDate(),
                                  ),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  );
                } else {
                  return Container(
                    color: Colors.black,
                  );
                }
              },
            ),
          ),
          Container(
            height: size.height / 10,
            width: size.width,
            alignment: Alignment.center,
            child: SizedBox(
              height: size.height / 12,
              width: size.width / 1.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height / 17,
                    width: size.width / 1.3,
                    child: TextField(
                      controller: _message,
                      decoration: InputDecoration(
                          hintText: "Send Message",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: onSendMessage,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
