import 'package:firebase_messaging/firebase_messaging.dart';

import 'UserPreferences.dart';

class PushNotificationManager {
  PushNotificationManager._();
  factory PushNotificationManager() => _instance;
  static final PushNotificationManager _instance = PushNotificationManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;
  dynamic notification;
  Future<void> init() async {
    if (!_initialized) {
      //For testing purposes print the Firebase Messaging token

      //For IOS request permission first
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> message) async {
            print("onMessage: $message");


            //notification = message['notification'];
          },
          onLaunch: (Map<String, dynamic> message) async {
            print("onMessage: $message");
            //notification = message['data'];

          },
          onResume: (Map<String, dynamic> message) async {
            print("onMessage: $message");
            //notification = message['data'];

          });
      _initialized = true;
      // return notification;
    }
  }

  Future<String> getUserToken() async {
    String token = await _firebaseMessaging.getToken();
    //print('FirebaseMessaging token: $token');
    return token;
  }
}
