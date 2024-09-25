part of 'products_bloc.dart';

class ProductsState extends Equatable {
  final List<Product> products;
  final Product curProduct;
  final String errMsg;
  final LoadingStatus status;

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
    status: LoadingStatus.initial,
  );

  ProductsState copyWith({
    List<Product>? products,
    Product? curProduct,
    String? errMsg,
    LoadingStatus? status,
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
    return 'Products State ::\nCurrent Product: $curProduct\nStatus: $status\nError: $errMsg\nproducts: $products\n';
  }

  @override
  List<Object?> get props => [
        products,
        curProduct,
        errMsg,
        status,
      ];
}
