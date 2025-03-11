import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class Constants {
  static const String orderSerialDoc = 'efmfqPzxqDAmI56WC8BX';
  static const String categorySerialDoc = 'wifUANX0ao4heuROaHd0';
  static const String marketsCol = 'markets';
  static const String categorysCol = 'categories';
  static const String productsCol = 'products';
  static const String adsCol = 'ads';
  static const String ordersCol = 'norders'; // todo: change to orders when updating
  static const String userCol = 'users';
  static const mapboxkey =
      'pk.eyJ1IjoibW9oYW5hZDUxNSIsImEiOiJjbTZqeDJ4NDgwNmhhMmpzaG15Y3Q0eGZwIn0.cS1JfP8F6PIfbmEZVBP8ew';
  static final defaultPinTheme = PinTheme(
    width: 60,
    height: 60,
    textStyle: const TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(30, 60, 87, 1),
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border.all(
        width: 2,
        color: Colors.grey.shade300,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
  );    
  
}
