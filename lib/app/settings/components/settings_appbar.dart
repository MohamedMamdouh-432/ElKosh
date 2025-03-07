import 'package:elkosh/app/settings/controllers/profile_provider.dart';
import 'package:elkosh/core/services/context_media.dart';
import 'package:elkosh/core/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class SettingsAppBar extends StatelessWidget {
  const SettingsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (ctx, pp, child) {
        return Container(
          width: ctx.width,
          height: 150,
          decoration: BoxDecoration(
            color: ColorManager.primary.withValues(alpha: 0.9),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(40),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  child: Center(
                    child: Text(
                      pp.user.name[0],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Gap(30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pp.user.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        wordSpacing: 3,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          child: Center(
                            child: Icon(
                              Icons.phone_enabled_rounded,
                              color: Colors.green,
                              size: 25,
                            ),
                          ),
                        ),
                        const Gap(10),
                        Text(
                          pp.user.phone,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Gap(5),
                    const Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          child: Center(
                            child: Icon(
                              Icons.location_on_rounded,
                              color: Colors.red,
                              size: 25,
                            ),
                          ),
                        ),
                        Gap(10),
                        Text(
                          'مصر',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
