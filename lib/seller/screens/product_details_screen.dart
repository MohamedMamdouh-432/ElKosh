import 'package:elkosh/seller/controllers/products_bloc/seller_products_bloc.dart';
import 'package:elkosh/seller/widgets/image_section.dart';
import 'package:elkosh/shared/services/context_media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SellerProductDetailsScreen extends StatelessWidget {
  const SellerProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SellerProductsBloc, SellerProductsState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Skeletonizer(
              enabled: state.status == LoadingStatus.inProgress,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: const Color(0xffF2F3F2),
                    leading: IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        CupertinoIcons.back,
                        size: 35,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SliverImageSection(imageUrl: state.curProduct.imgUrl),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.curProduct.name,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${state.curProduct.unitVal} ${state.curProduct.unit}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                          const Gap(10),
                          Text(
                            '${state.curProduct.price} جنيه',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Gap(10),
                          const Divider(),
                          const Gap(10),
                          const Text(
                            "الوصف",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Gap(5),
                          Text(
                            state.curProduct.desc,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const Gap(10),
                          const Divider(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
              width: context.width * 0.8,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  "أضف خصم",
                  textScaler: TextScaler.linear(1.6),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
