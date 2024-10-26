part of 'seller_products_bloc.dart';

class SellerProductsState extends Equatable {
  final List<Product> products;
  final Product curProduct;
  final String errMsg;
  final LoadingStatus status;
  
  const SellerProductsState({
    required this.products,
    required this.curProduct,
    required this.errMsg,
    required this.status,
  });
  
  static SellerProductsState initial = SellerProductsState(
    products: const [],
    curProduct: Product.empty,
    errMsg: '',
    status: LoadingStatus.initial,
  );

  SellerProductsState copyWith({
    List<Product>? products,
    Product? curProduct,
    String? errMsg,
    LoadingStatus? status,
  }) {
    return SellerProductsState(
      products: products ?? this.products,
      curProduct: curProduct ?? this.curProduct,
      errMsg: errMsg ?? this.errMsg,
      status: status ?? this.status,
    );
  }
  
  @override
  String toString() {
    return 'Seller Products State ::\nCurrent Product: $curProduct\nStatus: ${status.name}\nError: $errMsg\nProducts: ${products.length}\n';
  }

  @override
  List<Object> get props => [products, curProduct, errMsg, status];
}
