import 'package:flutter/material.dart';

class AuthFormField extends StatelessWidget {
  final String? labelText, errorText;
  final bool obsecured;
  final TextInputType inputType;
  final Function(String)? onChange;

  const AuthFormField({
    super.key,
    this.labelText,
    this.onChange,
    this.errorText,
    this.obsecured = false,
    this.inputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChange,
      obscureText: obsecured,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black54),
        errorText: errorText,
      ),
    );
  }
}
