import 'package:flutter/material.dart';

class InputFormField extends StatelessWidget {
  final String? labelText, errorText, initialValue;
  final bool obsecured;
  final TextInputType inputType;
  final Function(String)? onChange;

  const InputFormField({
    super.key,
    this.labelText,
    this.onChange,
    this.initialValue,
    this.errorText,
    this.inputType = TextInputType.text,
    this.obsecured = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
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
