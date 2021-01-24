import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gtisma/helpers/push_notifications.dart';
import 'package:gtisma/models/message.dart';

class FirebaseMessager extends StatefulWidget {
  @override
  _FirebaseMessagerState createState() => _FirebaseMessagerState();
}

class _FirebaseMessagerState extends State<FirebaseMessager> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final List<Message> messages = [];
  Future<void> initFirebase() async {
    String token = await _firebaseMessaging.getToken();
    print('FirebaseMessaging token: $token');
  }

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    initFirebase();
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
      final notification = message['notification'];
      setState(() {
        messages.add(
            Message(title: notification['title'], body: notification['body']));
      });
    }, onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
      final notification = message['data'];
      setState(() {
        messages.add(Message(title: '$message', body: 'onLaunch'));
        messages.add(Message(
            title: 'onLaunch ${notification['title']}',
            body: 'onLaunch: ${notification['body']}'));
      });
    }, onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
    });
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: messages.map(buildMessage).toList(),
        ),
      );
  Widget buildMessage(Message message) => ListTile(
        title: Text(message.title),
        subtitle: Text(message.body),
      );
}
