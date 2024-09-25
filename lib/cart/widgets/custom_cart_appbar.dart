import 'package:flutter/material.dart';

class CustomCartAppbar extends StatelessWidget {
  const CustomCartAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: const Text("سلة التسوق"),
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back_ios_new_outlined)));
  }
}
