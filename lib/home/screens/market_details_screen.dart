import 'package:elkosh/home/controllers/markets_bloc/markets_bloc.dart';
import 'package:elkosh/home/widgets/image_section.dart';
import 'package:elkosh/home/widgets/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MarkettDetailsScreen extends StatelessWidget {
  const MarkettDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<MarketsBloc, MarketsState>(
          builder: (context, state) {
            return CustomScrollView(
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
                SliverImageSection(imageUrl: state.curMarket.imgUrl),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              state.curMarket.name,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              state.curMarket.hotline,
                              style: const TextStyle(
                                fontSize: 22,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          state.curMarket.scope,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
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
                          state.curMarket.desc,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const Gap(10),
                        const Divider(),
                        const Gap(10),
                        const Text(
                          "منتجات المتجر",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Gap(10),
                        Skeletonizer(
                          enabled: state.status == LoadingStatus.inProgress,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              crossAxisSpacing: 5,
                              maxCrossAxisExtent: 110,
                              childAspectRatio: 2 / 2.3,
                            ),
                            itemCount: state.relProducts.length,
                            itemBuilder: (context, index) =>
                                ProductCard(product: state.relProducts[index]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
