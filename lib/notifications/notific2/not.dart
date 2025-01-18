import 'dart:convert'; // علشان نحول البيانات JSON

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  // Firebase Server Key - هتلاقيها في Firebase Console تحت Cloud Messaging
  static const String _serverKey = "YOUR_FIREBASE_SERVER_KEY_HERE";

  // دالة علشان تبعت الإشعار
  static Future<void> sendNotification({
    required String title,
    required String body,
    required String adminToken,
  }) async {
    try {
      // URL بتاع Firebase Cloud Messaging
      const String url = 'https://fcm.googleapis.com/fcm/send';

      // بيانات الإشعار
      final Map<String, dynamic> notificationData = {
        "to": adminToken, // توكن الأدمن
        "notification": {
          "title": title, // عنوان الإشعار
          "body": body, // نص الإشعار
          "sound": "default"
        },
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK", // لما يدوس على الإشعار
          "order_id": "12345" // مثال لو عاوز تبعت ID الطلب
        }
      };

      // إرسال الطلب لـ Firebase
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$_serverKey',
        },
        body: json.encode(notificationData),
      );

      // لو في مشكلة
      if (response.statusCode != 200) {
        print("Error sending notification: ${response.body}");
      } else {
        print("Notification sent successfully!");
      }
    } catch (e) {
      print("Exception while sending notification: $e");
    }
  }
}

class OrderPage extends StatelessWidget {
  final String adminToken = "ADMIN_DEVICE_TOKEN_HERE";

  const OrderPage({super.key}); // توكن الأدمن

  void placeOrder() {
    NotificationService.sendNotification(
      title: "New Order Request",
      body: "A user has placed a new order.",
      adminToken: adminToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Place Order")),
      body: Center(
        child: ElevatedButton(
          onPressed: placeOrder,
          child: const Text("Place Order"),
        ),
      ),
    );
  }
}
