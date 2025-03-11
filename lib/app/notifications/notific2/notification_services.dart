import 'dart:developer';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elkosh/repos/enums/enums.dart';
import 'package:elkosh/repos/models/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: true,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      const SnackBar(
        content: Text('من فضلك افتح الاشعارات عشان يصلك عروضنا'),
      );

      Future.delayed(
        const Duration(seconds: 3),
        () {
          AppSettings.openAppSettings(type: AppSettingsType.notification);
        },
      );
    }
  }

//  final user = FirebaseAuth.instance.currentUser
  User? user = const User(
      active: false,
      email: 'Mok@gmail.com',
      id: '312312312',
      name: 'مهند اسامه',
      phone: '01065367684',
      token: '',
      userType: UserType.consumer);
  // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  Future<void> saveUserTokenToFirebase() async {
    try {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user!.phone);
      String? token = await messaging.getToken();
      // Update or set the token in the user's document
      await userRef.set(
        {'token': token},
        SetOptions(merge: true),
      );

      print("User token successfully saved.");
    } catch (e) {
      print("Failed to save user token: $e");
    }
  }
  //get admin tokens

  Future<List<String>> getAdminTokens() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userType', isEqualTo: 'admin')
        .get();

    List<String> adminTokens = [];
    for (var doc in querySnapshot.docs) {
      String? token = doc['token'];
      if (token != null) {
        adminTokens.add(token);
      }
    }

    return adminTokens;
  }

//get token

  Future<String?> getDeviceToken() async {
    // NotificationSettings settings = await messaging.requestPermission(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );

    String? token = await messaging.getToken();
    log('token is $token');
    return token;
  }

  //init local notification
  void initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    var androidInitSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitSettings = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        handleMessage(context, message);
      },
    );
  }

  //init firebase notification
  void initFirebaseNotification(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // if (notification != null && android != null) {
      //   initLocalNotification(context, message);
      // }
      if (kDebugMode) {
        log(' Title is ${message.notification!.title}');
        log(' Body is ${message.notification!.body}');
      }
      if (Platform.isIOS) {
        iosForgroundMessage();
      }

      //android
      if (Platform.isAndroid) {
        initLocalNotification(context, message);
        //handleMessage(context, message);
        showNotification(message);
      }
    });
  }

  //func to show notification
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
      showBadge: true,
      playSound: true,
    );
    //android setting
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.high,
      color: Colors.blue,
      playSound: channel.playSound,
    );

    //IOS setting
    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    Future.delayed(
      Duration.zero,
      () {
        _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails,
          payload: "my data",
        );
      },
    );
  }

  //background and terminated state

  Future<void> setupInteractedMessage(BuildContext context) async {
    //background state
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        handleMessage(context, message);
      },
    );
    //terminated state
    FirebaseMessaging.instance.getInitialMessage().then(
      (RemoteMessage? message) {
        if (message != null && message.data.isNotEmpty) {
          handleMessage(context, message);
        }
      },
    );
  }
  //handle message

  Future<void> handleMessage(
      BuildContext context, RemoteMessage message) async {
    //context.go(RouteManager.notificationsRoute);
  }

  //ios forground message
  void iosForgroundMessage() {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
