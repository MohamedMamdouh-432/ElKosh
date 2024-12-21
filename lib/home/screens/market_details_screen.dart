import 'package:elkosh/home/components/related_categories_grid.dart';
import 'package:elkosh/home/controllers/categorys_bloc/categorys_bloc.dart';
import 'package:elkosh/home/controllers/market_details_bloc/market_details_bloc.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CategorysBloc()),
        BlocProvider(create: (context) => MarketDetailsBloc()),
      ],
      child: SafeArea(
        child: Scaffold(
          body: BlocBuilder<MarketDetailsBloc, MarketDetailsState>(
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
                    SliverImageSection(imageUrl: state.market.imgUrl),
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
                                  state.market.name,
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  state.market.hotline,
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
                              state.market.desc,
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
                            const RelatedCategorysGrid(),
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
