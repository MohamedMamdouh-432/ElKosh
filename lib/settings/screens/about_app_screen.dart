import 'dart:developer';

import 'package:elkosh/core/utils/route_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

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
                    // Handle "talabat pay" tap
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
                  onTap: () => context.push(RouteManager.aboutAppRoute),
                ),
                const Gap(10),
                const Row(
                  children: [
                    Expanded(
                        child: Divider(height: 32, indent: 20, endIndent: 20)),
                    Text('تواصل معنا', style: TextStyle(fontSize: 18)),
                    Expanded(
                        child: Divider(height: 32, indent: 20, endIndent: 20)),
                  ],
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    Card(
                      elevation: 5,
                      shape: const CircleBorder(),
                      child: IconButton(
                        onPressed: () async {
                          final Uri phoneUri = Uri(
                            scheme: 'tel',
                            path: "01063734753",
                          );
                          try {
                            await launchUrl(phoneUri);
                          } catch (e) {
                            log(e.toString());
                          }
                        },
                        iconSize: 40,
                        color: Colors.green,
                        icon: const Icon(CupertinoIcons.phone),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      shape: const CircleBorder(),
                      child: IconButton(
                        onPressed: () async {
                          const String phoneNumber = "+201063734753";
                          final Uri whatsappUri =
                              Uri.parse('https://wa.me/$phoneNumber');
                          try {
                            await launchUrl(whatsappUri);
                          } catch (e) {
                            log(e.toString());
                          }
                        },
                        iconSize: 40,
                        color: Colors.green,
                        icon: const Icon(FontAwesomeIcons.whatsapp),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      shape: const CircleBorder(),
                      child: IconButton(
                        onPressed: () async {
                          final Uri facebookUri = Uri.parse(
                              "https://www.facebook.com/share/g/1DDTGTQz5R/");
                          try {
                            await launchUrl(facebookUri);
                          } catch (e) {
                            log(e.toString());
                          }
                        },
                        iconSize: 40,
                        color: Colors.indigo,
                        icon: const Icon(FontAwesomeIcons.facebook),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
