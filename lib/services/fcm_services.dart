import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FCMService {
  static FCMService instance = FCMService();

  final _firebaseMessaging = FirebaseMessaging.instance;

  void notificationConfig() {
    _firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("message: $message");
    });
  }
}
