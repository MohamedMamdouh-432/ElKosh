import 'package:flutter/material.dart';

class AuthFormField extends StatelessWidget {
  final String? labelText, errorText;
  final bool obsecured;
  final Function(String)? onChange;

  const AuthFormField({
    super.key,
    this.labelText,
    this.onChange,
    this.errorText,
    this.obsecured = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChange,
      obscureText: obsecured,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black54),
        errorText: errorText,
      ),
    );
  }
}
