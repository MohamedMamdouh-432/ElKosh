import 'package:elkosh/app/home/products/widgets/product_card.dart';
import 'package:elkosh/app/home/search/controllers/search_provider.dart';
import 'package:elkosh/repos/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
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
          body: Consumer<SearchProvider>(
            builder: (context, state, _) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const Gap(20),
                    SearchBar(
                      hintText: 'ابحث من هنا',
                      autoFocus: true,
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
                      onSubmitted: (value) =>
                          context.read<SearchProvider>().submitQuery(value),
                    ),
                    const Gap(10),
                    Skeletonizer(
                      enabled: state.status == LoadStatus.inProgress,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 120,
                          crossAxisSpacing: 10.sp,
                          mainAxisSpacing: 10.sp,
                          childAspectRatio: 2.sp / 3.5.sp,
                        ),
                        itemCount: state.products.length,
                        itemBuilder: (context, index) => ProductCard(
                          product: state.products[index],
                          steps: 2,
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
