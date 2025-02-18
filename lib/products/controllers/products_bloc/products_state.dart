part of 'products_bloc.dart';

class ProductsState extends Equatable {
  final List<Product> products, relProducts;
  final Product curProduct;
  final String errMsg;
  final LoadStatus status;
  final bool hasReachedMax;

  const ProductsState({
    required this.products,
    required this.relProducts,
    required this.curProduct,
    required this.errMsg,
    required this.status,
    required this.hasReachedMax,
  });

  static ProductsState initial = ProductsState(
    products: const [],
    relProducts: const [],
    curProduct: Product.empty,
    errMsg: '',
    status: LoadStatus.initial,
    hasReachedMax: false,
  );

  ProductsState copyWith({
    List<Product>? products,
    List<Product>? relProducts,
    Product? curProduct,
    String? errMsg,
    LoadStatus? status,
    bool? hasReachedMax,
  }) {
    return ProductsState(
      products: products ?? this.products,
      relProducts: relProducts ?? this.relProducts,
      curProduct: curProduct ?? this.curProduct,
      errMsg: errMsg ?? this.errMsg,
      status: status ?? this.status,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''Products State ::
      Current Product: ${curProduct.name}
      Status: ${status.name}
      products: ${products.length}
      Reach Max: ${hasReachedMax ? 'Max' : 'Not Yet'}
      Related Products: ${relProducts.length}
      Error: $errMsg
    ''';
  }

  @override
  List<Object?> get props => [
        products,
        relProducts,
        curProduct,
        errMsg,
        status,
        hasReachedMax,
      ];
}
