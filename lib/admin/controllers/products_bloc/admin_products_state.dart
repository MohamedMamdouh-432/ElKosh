part of 'admin_products_bloc.dart';

class AdminProductsState extends Equatable {
  final List<Product> products;
  final Product curProduct;
  final String errMsg;
  final LoadingStatus status;

  const AdminProductsState({
    required this.products,
    required this.curProduct,
    required this.errMsg,
    required this.status,
  });

  static AdminProductsState initial = AdminProductsState(
    products: const [],
    curProduct: Product.empty,
    errMsg: '',
    status: LoadingStatus.initial,
  );

  AdminProductsState copyWith({
    List<Product>? products,
    Product? curProduct,
    String? errMsg,
    LoadingStatus? status,
  }) {
    return AdminProductsState(
      products: products ?? this.products,
      curProduct: curProduct ?? this.curProduct,
      errMsg: errMsg ?? this.errMsg,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'Admin Products State ::\nCurrent Product: $curProduct\nStatus: ${status.name}\nError: $errMsg\nProducts: ${products.length}\n';
  }

  @override
  List<Object> get props => [products, curProduct, errMsg, status];
}
