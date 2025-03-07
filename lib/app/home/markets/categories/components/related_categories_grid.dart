import 'package:elkosh/app/home/markets/categories/controllers/categorys_bloc/categorys_bloc.dart';
import 'package:elkosh/app/home/markets/categories/widgets/category_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:models_repository/models_repository.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RelatedCategorysGrid extends StatelessWidget {
  const RelatedCategorysGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategorysBloc, CategorysState>(
      buildWhen: (p, c) => p != c,
      builder: (context, categorysState) {
        return Skeletonizer(
          enabled: categorysState.status == LoadStatus.inProgress,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 120,
              crossAxisSpacing: 5.sp,
              mainAxisSpacing: 5.sp,
              childAspectRatio: 6.8.sp / 10.5.sp,
            ),
            itemCount: categorysState.categorys.length,
            itemBuilder: (_, i) => CategoryItem(categorysState.categorys[i]),
          ),
        );
      },
    );
  }
}
