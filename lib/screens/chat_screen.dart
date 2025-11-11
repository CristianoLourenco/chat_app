import 'package:chat/util/firebase_util.dart';
import 'package:chat/widgets/chat_message_widget.dart';
import 'package:chat/widgets/new_message_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void _handlerMessagesNotifications() async {
    await FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        FirebaseUtil.showNotification(value);
      }
    });

    FirebaseMessaging.onMessage.listen(FirebaseUtil.showNotification);

    await FirebaseMessaging.instance.subscribeToTopic("chat");
  }

  @override
  void initState() {
    super.initState();
    _handlerMessagesNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FlutterChat"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: Column(
        children: [Expanded(child: ChatMessageWidget()), NewMessageWidget()],
      ),
    );
  }
}
