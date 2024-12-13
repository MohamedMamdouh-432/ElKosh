part of 'cart_bloc.dart';

class CartState extends Equatable {
  final double price;
  final String errorMessage;
  final CartStatus status;
  final String marketId;
  final String marketName;
  final Map<Product, int> shopping;

  const CartState({
    required this.shopping,
    required this.price,
    required this.errorMessage,
    required this.status,
    required this.marketId,
    required this.marketName,
  });

  static CartState initial = const CartState(
    price: 0,
    shopping: {},
    errorMessage: '',
    status: CartStatus.initial,
    marketId: '',
    marketName: '',
  );

  CartState copyWith({
    double? price,
    Map<Product, int>? shopping,
    String? errorMessage,
    CartStatus? status,
    String? marketId,
    String? marketName,
  }) =>
      CartState(
        price: price ?? this.price,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        shopping: shopping != null ? Map.of(shopping) : this.shopping,
        marketId: marketId ?? this.marketId,
        marketName: marketName ?? this.marketName,
      );

  @override
  String toString() =>
      "CartState ::\nMarketId: $marketId\nMarketName: $marketName\nPrice: $price\nStatus: ${status.name}\nShopping: ${shopping.length}\nErrorMessage: $errorMessage";

  @override
  List<Object> get props => [
        price,
        shopping,
        errorMessage,
        status,
        marketId,
        marketName,
      ];
}
