import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  static FCMService instance = FCMService();

  final _firebaseMessaging = FirebaseMessaging.instance;

  void notificationConfig() {
    _firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("message: $message");
    });
  }
}
