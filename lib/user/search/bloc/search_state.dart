part of 'search_bloc.dart';

class SearchState extends Equatable {
  final String query;
  final List<Product> products;
  final LoadingStatus status;
  final String errMsg;

  const SearchState({
    required this.query,
    required this.products,
    required this.status,
    required this.errMsg,
  });

  static const SearchState initial = SearchState(
    query: '',
    products: [],
    status: LoadingStatus.initial,
    errMsg: '',
  );

  SearchState copyWith({
    String? query,
    List<Product>? products,
    LoadingStatus? status,
    String? errMsg,
  }) {
    return SearchState(
      query: query ?? this.query,
      products: products ?? this.products,
      status: status ?? this.status,
      errMsg: errMsg ?? this.errMsg,
    );
  }

  @override
  String toString() {
    return 'SearchState ::\nQuery: $query\nProducts: ${products.length}\nLoading Status: ${status.name}\nError: $errMsg';
  }

  @override
  List<Object> get props => [query, products, status, errMsg];
}
