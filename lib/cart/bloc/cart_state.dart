part of 'cart_bloc.dart';

class CartState extends Equatable {
  final double price;
  final String errorMessage;
  final CartStatus status;
  final Map<Product, int> shopping;

  const CartState({
    required this.shopping,
    required this.price,
    required this.errorMessage,
    required this.status,
  });

  static CartState initial = const CartState(
    price: 0,
    shopping: {},
    errorMessage: '',
    status: CartStatus.initial,
  );

  CartState copyWith({
    double? price,
    Map<Product, int>? shopping,
    String? errorMessage,
    CartStatus? status,
  }) =>
      CartState(
        price: price ?? this.price,
        shopping: shopping ?? this.shopping,
        errorMessage: errorMessage ?? this.errorMessage,
        status: status ?? this.status,
      );

  @override
  String toString() =>
      "CartState ::\nPrice: $price\nStatus: $status\nShopping: $shopping\nErrorMessage: $errorMessage";

  @override
  List<Object> get props => [
        price,
        shopping,
        errorMessage,
        status,
      ];
}
