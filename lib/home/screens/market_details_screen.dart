import 'package:elkosh/home/controllers/categorys_bloc/categorys_bloc.dart';
import 'package:elkosh/home/controllers/markets_bloc/markets_bloc.dart';
import 'package:elkosh/home/widgets/category_item.dart';
import 'package:elkosh/home/widgets/image_section.dart';
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
    return BlocProvider(
      create: (context) => CategorysBloc(),
      child: SafeArea(
        child: Scaffold(
          body: BlocBuilder<MarketsBloc, MarketsState>(
            builder: (context, state) {
              return Skeletonizer(
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
                              "اصناف المتجر",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Gap(10),
                            BlocBuilder<CategorysBloc, CategorysState>(
                              builder: (context, categorysState) {
                                return Skeletonizer(
                                  enabled: categorysState.status ==
                                      LoadingStatus.inProgress,
                                  child: GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                        crossAxisSpacing: 5,
                                        maxCrossAxisExtent: 120,
                                        childAspectRatio: 2 / 3,
                                      ),
                                      itemCount:
                                          categorysState.categorys.length,
                                      itemBuilder: (context, index) =>
                                          CategoryItem(
                                            categorysState.categorys[index],
                                          )),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
