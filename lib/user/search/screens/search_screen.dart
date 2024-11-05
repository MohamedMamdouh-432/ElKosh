import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elkosh/user/search/bloc/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductSearchDelegate extends SearchDelegate {
  final SearchBloc searchBloc;
  ProductSearchDelegate({required this.searchBloc});

  Future<List<String>> _getPreviousSearches() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('previousSearches') ?? [];
  }

  Future<void> _saveSearchQuery(String query) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> searches = await _getPreviousSearches();

    //to avoid duplicates.
    searches.remove(query);
    //  start of the list.
    searches.insert(1, query);

    //
    if (searches.length > 5) {
      searches = searches.sublist(0, 5);
    }

    await prefs.setStringList('previousSearches', searches);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _saveSearchQuery(query);
    searchBloc.add(SearchQueryChanged(query));

    return BlocBuilder<SearchBloc, SearchState>(
      bloc: searchBloc,
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SearchLoaded) {
          if (state.products.isEmpty) {
            return const Center(child: Text('بتدور علي ايه ؟؟'));
          }
          return ListView.builder(
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final data = state.products[index];
              return ListTile(
                onTap: () {},
                subtitle: Text(data['desc']),
                trailing: Text(data['price'].toString()),
                title: Text(data['name']),
                leading: CachedNetworkImage(
                  imageUrl: data['imgUrl'],
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              );
            },
          );
        } else if (state is SearchError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(
            child: Text('ملقيناش حاجه من اللي بتدور عليها!\n  جرب تاني'));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _getPreviousSearches(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('لسه معملتش بحث'));
        }

        final suggestions = snapshot.data!
            .where((search) =>
                search.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(suggestions[index]),
              leading: const Icon(Icons.history),
              onTap: () {
                query = suggestions[index];
                showResults(context);
              },
            );
          },
        );
      },
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(firestore: FirebaseFirestore.instance),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('البحث عن منتجات'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: ProductSearchDelegate(
                    searchBloc: context.read<SearchBloc>(),
                  ),
                );
              },
            ),
          ],
        ),
        body: const Center(
          child: Text('اضغط علي ايقونه البحث عشان تدور علي منتجاتك',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
