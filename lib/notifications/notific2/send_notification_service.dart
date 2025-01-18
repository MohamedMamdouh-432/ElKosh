import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import 'get_services_key.dart';

class SendNotificationService {
  static Future<void> sendNotificationUsingApi(
      {required String? title,
      token,
      body,
      required Map<String, dynamic>? data}) async {
    String serverKey = await GetServerKey().getServerKeyToken();
    String url =
        "https://fcm.googleapis.com/v1/projects/elkoshecommerce/messages:send";

    var headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
    };
    //message
    Map<String, dynamic> message = {
      "message": {
        "token": token,
        "notification": {
          "body": body,
          "title": title,
        },
        "data": data,
      }
    };
    //api
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification: ${response.statusCode}');
    }
  }

  Future<void> sendNotificationToAdmins() async {
    try {
      // Step 1: Get all admin tokens from Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('userType', isEqualTo: 'admin')
          .get();

      // Extract tokens
      List<String> adminTokens = [];
      for (var doc in querySnapshot.docs) {
        String? token = doc['token'];
        if (token != null && token.isNotEmpty) {
          adminTokens.add(token);
        }
      }

      if (adminTokens.isEmpty) {
        log('No admin tokens found.>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
        return;
      }

      // Step 2: Prepare the notification payload
      // Replace with your FCM server key
      final url = Uri.parse('https://fcm.googleapis.com/fcm/send');

      final notificationPayload = {
        'registration_ids': adminTokens,
        'notification': {
          'title': 'New Notification',
          'body': 'A new event has occurred in the system.',
        },
        'priority': 'high',
      };
      String serverKey = await GetServerKey().getServerKeyToken();
      // Step 3: Send the notification via FCM
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: json.encode(notificationPayload),
      );

      if (response.statusCode == 200) {
        log('Notification sent successfully to admins.');
      } else {
        log('Failed to send notification. Response: ${response.body}');
      }
    } catch (e) {
      log('Error sending notification to admins: $e');
    }
  }
}
