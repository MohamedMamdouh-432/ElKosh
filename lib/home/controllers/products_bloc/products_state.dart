part of 'products_bloc.dart';

class ProductsState extends Equatable {
  final List<Product> products, relProducts;
  final Product curProduct;
  final String errMsg;
  final LoadStatus status;

  const ProductsState({
    required this.products,
    required this.relProducts,
    required this.curProduct,
    required this.errMsg,
    required this.status,
  });

  static ProductsState initial = ProductsState(
    products: const [],
    relProducts: const [],
    curProduct: Product.empty,
    errMsg: '',
    status: LoadStatus.initial,
  );

  ProductsState copyWith({
    List<Product>? products,
    List<Product>? relProducts,
    Product? curProduct,
    String? errMsg,
    LoadStatus? status,
  }) {
    return ProductsState(
      products: products ?? this.products,
      relProducts: relProducts ?? this.relProducts,
      curProduct: curProduct ?? this.curProduct,
      errMsg: errMsg ?? this.errMsg,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return '''Products State ::
      Current Product: ${curProduct.name}
      Status: ${status.name}
      Error: $errMsg
      products: ${products.length}
      Related Products: ${relProducts.length}
    ''';
  }

  @override
  List<Object?> get props => [
        products,
        relProducts,
        curProduct,
        errMsg,
        status,
      ];
}
