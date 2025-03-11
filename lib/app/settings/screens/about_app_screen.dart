import 'package:elkosh/core/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 247, 234, 250),
              Color.fromARGB(255, 250, 240, 236),
              Color.fromARGB(255, 235, 244, 251),
              Color.fromARGB(255, 246, 237, 233),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('عن التطبيق'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.info_outline,
                    size: 35,
                    color: Colors.teal,
                  ),
                  title: const Text(
                    'تعرف على التطبيق',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    context.push(Routes.privacyPolicyRoute2);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.policy_outlined,
                    size: 35,
                    color: Colors.purple,
                  ),
                  title: const Text(
                    'سياسة الخصوصية',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () => context.push(Routes.privacyPolicyRoute),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
