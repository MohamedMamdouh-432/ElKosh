import 'package:elkosh/products/widgets/product_card.dart';
import 'package:elkosh/search/bloc/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:models_repository/models_repository.dart';
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
          body: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const Gap(20),
                    SearchBar(
                      hintText: 'إبحث عن خضروات و أطعمة و مشروبات',
                      leading: const Icon(Icons.search, size: 26),
                      elevation: const WidgetStatePropertyAll(0),
                      hintStyle: const WidgetStatePropertyAll(
                        TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 20),
                      ),
                      onChanged: (value) => context
                          .read<SearchBloc>()
                          .add(SearchQueryChanged(value)),
                      onSubmitted: (value) => context
                          .read<SearchBloc>()
                          .add(SearchQuerySubmitted()),
                    ),
                    const Gap(10),
                    Skeletonizer(
                      enabled: state.status == LoadStatus.inProgress,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 2.w,
                        ),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          crossAxisSpacing: 5,
                          maxCrossAxisExtent: 110,
                          childAspectRatio: 5.1.w / 10.2.h,
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
