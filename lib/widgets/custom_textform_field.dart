import 'package:flutter/material.dart';

class CustomTextformField extends StatelessWidget {
  CustomTextformField(
      {super.key, this.hintText, this.onChange, this.obsecured = false});
  String? hintText;
  Function(String)? onChange;
  bool obsecured;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (data) {
        if (data!.isEmpty) {
          return 'value is wrong';
        }
        return null;
      },
      onChanged: onChange,
      obscureText: obsecured,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
