import 'package:elkosh/search/controllers/search_provider.dart';
import 'package:elkosh/shared/services/context_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AnimatedSearchBar extends StatelessWidget {
  const AnimatedSearchBar({
    super.key,
    required this.appBarAnimation,
  });

  final Animation appBarAnimation;

  @override
  Widget build(BuildContext ctx) {
    return AnimatedCrossFade(
      firstChild: Column(
        children: [
          SearchBar(
            hintText: 'ابحث من هنا',
            leading: const Icon(Icons.search, size: 26),
            elevation: const WidgetStatePropertyAll(0),
            hintStyle: WidgetStatePropertyAll(
              TextStyle(
                color: Colors.black54,
                fontSize: 10.sp,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
            padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 10)),
            onSubmitted: (value) => ctx.read<SearchProvider>().submitQuery(),
          ),
          const Gap(16),
        ],
      ),
      secondChild: SizedBox(width: ctx.width),
      crossFadeState: appBarAnimation.value < 150
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 200),
    );
  }
}
