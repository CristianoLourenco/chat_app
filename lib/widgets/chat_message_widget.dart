import 'package:chat/screens/chat_screen.dart';
import 'package:chat/widgets/new_message_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final app = FirebaseAuth.instance.app;
    return StreamBuilder(
      stream:
          FirebaseFirestore.instanceFor(app: app)
              .collection('chat')
              .orderBy('createdAt', descending: false)
              .snapshots(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text("No messages found.");
        }

        final messages = snapshot.data!.docs;
        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) => Text(messages[index].data()['text']),
        );
      },
    );
  }
}
