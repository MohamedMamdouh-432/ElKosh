import 'package:flutter/material.dart';

class InputFormField extends StatelessWidget {
  final String? labelText, errorText, initialValue;
  final bool obsecured, isEnabled;
  final TextInputType inputType;
  final Function(String)? onChange;
  final ValueNotifier<bool> isObscured; // Manages password visibility state

  const InputFormField({
    super.key,
    this.labelText,
    this.onChange,
    this.initialValue,
    this.errorText,
    this.inputType = TextInputType.text,
    this.obsecured = false,
    this.isEnabled = true,
    required this.isObscured, // Require ValueNotifier for state management
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isObscured,
      builder: (context, value, child) {
        return TextFormField(
          initialValue: initialValue,
          onChanged: onChange,
          obscureText: obsecured
              ? value
              : false, // Apply obscuring only if obsecured is true
          enabled: isEnabled,
          keyboardType: inputType,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(color: Colors.black54),
            errorText: errorText,
            suffixIcon: obsecured
                ? IconButton(
                    icon: Icon(
                      value ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      isObscured.value = !value; // Toggle visibility
                    },
                  )
                : null, // Only show the icon if obsecured is true
          ),
        );
      },
    );
  }
}
