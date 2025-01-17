part of 'product_details_bloc.dart';

class ProductDetailsState extends Equatable {
  final Product product;
  final LoadStatus status;
  final String errMsg;

  const ProductDetailsState({
    required this.product,
    required this.status,
    required this.errMsg,
  });

  static ProductDetailsState initial = ProductDetailsState(
    product: Product.empty,
    errMsg: '',
    status: LoadStatus.initial,
  );

  ProductDetailsState copyWith({
    Product? product,
    LoadStatus? status,
    String? errMsg,
  }) {
    return ProductDetailsState(
      product: product ?? this.product,
      status: status ?? this.status,
      errMsg: errMsg ?? this.errMsg,
    );
  }

  @override
  String toString() => '''Product Details State :: 
    Name: ${product.name}
    Status: ${status.name}
    Error: $errMsg
  ''';

  @override
  List<Object> get props => [product, status, errMsg];
}
