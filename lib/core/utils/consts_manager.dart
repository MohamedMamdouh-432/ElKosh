import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class ConstsManager {
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
