part of 'search_bloc.dart';

class SearchState extends Equatable {
  final String query;
  final List<Product> products;
  final LoadStatus status;
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
    status: LoadStatus.initial,
    errMsg: '',
  );

  SearchState copyWith({
    String? query,
    List<Product>? products,
    LoadStatus? status,
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
    return '''SearchState ::
      Query: $query
      Products: ${products.length}
      Load Status: ${status.name}
      Error: $errMsg
    ''';
  }

  @override
  List<Object> get props => [query, products, status, errMsg];
}
