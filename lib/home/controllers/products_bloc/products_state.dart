part of 'products_bloc.dart';

class ProductsState extends Equatable {
  final List<Product> products;
  final Product curProduct;
  final String errMsg;
  final LoadStatus status;

  const ProductsState({
    required this.products,
    required this.curProduct,
    required this.errMsg,
    required this.status,
  });

  static ProductsState initial = ProductsState(
    products: const [],
    curProduct: Product.empty,
    errMsg: '',
    status: LoadStatus.initial,
  );

  ProductsState copyWith({
    List<Product>? products,
    Product? curProduct,
    String? errMsg,
    LoadStatus? status,
  }) {
    return ProductsState(
      products: products ?? this.products,
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
    ''';
  }

  @override
  List<Object?> get props => [
        products,
        curProduct,
        errMsg,
        status,
      ];
}
