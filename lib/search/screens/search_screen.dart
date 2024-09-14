import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
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
                // todo: will be linked with SearchBloc Later
                onChanged: (value) {},
                onSubmitted: (value) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
