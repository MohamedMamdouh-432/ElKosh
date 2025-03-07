part of 'cart_cubit.dart';

class CartState extends Equatable {
  final double price;
  final String errMsg;
  final CartStatus status;
  final Map<Product, int> items;
  final Map<Ad, int> ads;

  const CartState({
    required this.items,
    required this.ads,
    required this.price,
    required this.errMsg,
    required this.status,
  });

  static CartState initial = const CartState(
    price: 0,
    items: {},
    ads: {},
    errMsg: '',
    status: CartStatus.initial,
  );

  CartState copyWith({
    double? price,
    Map<Product, int>? items,
    Map<Ad, int>? ads,
    String? errMsg,
    CartStatus? status,
  }) =>
      CartState(
        price: price ?? this.price,
        status: status ?? this.status,
        errMsg: errMsg ?? this.errMsg,
        items: items != null ? Map.of(items) : this.items,
        ads: ads ?? this.ads,
      );

  @override
  String toString() => '''CartState ::
        Price: $price
        Status: ${status.name}
        Items: ${items.length}
        Ads: ${ads.length}
        Error: $errMsg
      ''';

  @override
  List<Object> get props => [
        price,
        items,
        ads,
        errMsg,
        status,
      ];
}
