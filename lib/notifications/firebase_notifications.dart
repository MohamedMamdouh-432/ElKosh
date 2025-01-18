import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'local_notifications_service.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    // Request permissions for iOS
    await messaging.requestPermission();
    String? token = await messaging.getToken();
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    handleForegroundMessage();
  }

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    log(message.notification?.title ?? '');
  }

  static void handleForegroundMessage() {
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        LocalNotificationService.showBasicNotification();
      },
    );
  }
}













  //cK_U2lfWQyGM-dvQZwe-nF:APA91bFfpF0wvhRgrPdtZCGl-o5ENdKYQKNqk5VPrwQmzhNMB6Vq0Xp6IOM9dkEc_iHgf9CbThgwxEFS0hNT7sbsw1QsPm3wRWkW0hBMwpKFb3v9GuuPqbU
  // Configure local notifications
  // const AndroidInitializationSettings androidInitializationSettings =
  //     AndroidInitializationSettings('@mipmap/ic_launcher');

  // const InitializationSettings initializationSettings =
  //     InitializationSettings(android: androidInitializationSettings);

  // await _localNotificationsPlugin.initialize(initializationSettings);

  // Handle foreground notifications
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   _showNotification(
  //     message.notification?.title,
  //     message.notification?.body,
  //   );
  // });

  // Handle background notifications

  // static Future<void> _firebaseMessagingBackgroundHandler(
  //     RemoteMessage message) async {
  //   await Firebase.initializeApp();
  //   _showNotification(message.notification?.title, message.notification?.body);
  // }

  // static Future<void> _showNotification(String? title, String? body) async {
  //   const AndroidNotificationDetails androidDetails =
  //       AndroidNotificationDetails(
  //     'order_channel',
  //     'Order Notifications',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );
  //   const NotificationDetails notificationDetails =
  //       NotificationDetails(android: androidDetails);

  //   await _localNotificationsPlugin.show(0, title, body, notificationDetails);
  // }