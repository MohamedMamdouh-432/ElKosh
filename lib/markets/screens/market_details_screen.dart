import 'package:elkosh/categories/components/related_categories_grid.dart';
import 'package:elkosh/categories/controllers/categorys_bloc/categorys_bloc.dart';
import 'package:elkosh/markets/controllers/market_details_bloc/market_details_bloc.dart';
import 'package:elkosh/shared/functions.dart';
import 'package:elkosh/shared/services/time_service.dart';
import 'package:elkosh/shared/widgets/image_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:models_repository/models_repository.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkettDetailsScreen extends StatelessWidget {
  const MarkettDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final timeService = TimeService();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CategorysBloc()),
        BlocProvider(create: (context) => MarketDetailsBloc()),
      ],
      child: SafeArea(
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
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(
                  CupertinoIcons.back,
                  size: 35,
                  color: Colors.black,
                ),
              ),
            ),
            body: BlocBuilder<MarketDetailsBloc, MarketDetailsState>(
              builder: (context, state) {
                return Skeletonizer(
                  enabled: state.status == LoadStatus.inProgress,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        ImageSection(
                          isReady: state.status != LoadStatus.inProgress,
                          imageUrl: state.market.imgUrl,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                StreamBuilder<DateTime>(
                                  stream: timeService.curTimeStream,
                                  builder: (_, timeValue) {
                                    if (!timeValue.hasData)
                                      return const SizedBox.shrink();
                                    bool isOpened = isMarketOpen(
                                        state.market, timeValue.data!);
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isOpened
                                            ? Colors.green
                                            : Colors.blueGrey,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        isOpened ? 'مفتوح' : 'مغلق',
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Card(
                                      elevation: 5,
                                      shape: const CircleBorder(),
                                      child: IconButton(
                                        onPressed: () async {
                                          String phoneNumber =
                                              "+2${state.market.hotline}";
                                          final Uri whatsappUri = Uri.parse(
                                              'https://wa.me/$phoneNumber');
                                          try {
                                            await launchUrl(whatsappUri);
                                          } catch (e) {
                                            AppLogs.error(e.toString());
                                          }
                                        },
                                        iconSize: 30,
                                        color: Colors.green,
                                        icon: const Icon(
                                            FontAwesomeIcons.whatsapp),
                                      ),
                                    ),
                                    Card(
                                      elevation: 5,
                                      shape: const CircleBorder(),
                                      child: IconButton(
                                        onPressed: () async {
                                          final Uri phoneUri = Uri(
                                            scheme: 'tel',
                                            path: state.market.hotline,
                                          );
                                          try {
                                            await launchUrl(phoneUri);
                                          } catch (e) {
                                            AppLogs.error(e.toString());
                                          }
                                        },
                                        iconSize: 30,
                                        color: Colors.green,
                                        icon: const Icon(CupertinoIcons.phone),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              state.market.name,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w800,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 2,
                              softWrap: true,
                            ),
                            Text(
                              state.market.desc,
                              style: TextStyle(
                                fontSize: 14.sp,
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
                            const RelatedCategorysGrid(),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
