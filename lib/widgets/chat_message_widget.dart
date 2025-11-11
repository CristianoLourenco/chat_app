import 'package:chat/widgets/message_bubble_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final app = FirebaseAuth.instance.app;
    final currentUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream:
          FirebaseFirestore.instanceFor(app: app)
              .collection('chat')
              .orderBy('createdAt', descending: true)
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
          padding: EdgeInsets.only(bottom: 40, left: 16, right: 16),
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final chatMessage = messages[index].data();
            final nextMessage =
                index + 1 < messages.length ? messages[index + 1].data() : null;

            final String? currentMessageUserId = chatMessage['userId'];
            final String? nextCurrentMessageUserId =
                nextMessage != null ? nextMessage['userId'] : null;

            final nextUserIsSame =
                nextCurrentMessageUserId == currentMessageUserId;

            final isMe = currentMessageUserId == currentUser.uid;
            if (nextUserIsSame) {
              return MessageBubbleWidget.next(
                message: chatMessage['text'],
                isMe: isMe,
              );
            }
            return MessageBubbleWidget.first(
              userImage:
                  isMe
                      ? 'https://avatar.iran.liara.run/public/36'
                      : 'https://avatar.iran.liara.run/public/47',
              username: chatMessage['username'],
              message: chatMessage['text'],
              isMe: isMe,
            );
          },
        );
      },
    );
  }
}
