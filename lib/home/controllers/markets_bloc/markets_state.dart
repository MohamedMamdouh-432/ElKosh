part of 'markets_bloc.dart';

class MarketsState extends Equatable {
  final List<Market> markets;
  final List<Product> relProducts;
  final Market curMarket;
  final String errMsg;
  final LoadingStatus status;

  const MarketsState({
    required this.markets,
    required this.relProducts,
    required this.curMarket,
    required this.errMsg,
    required this.status,
  });

  static MarketsState initial = MarketsState(
    markets: const [],
    relProducts: const [],
    curMarket: Market.empty,
    errMsg: '',
    status: LoadingStatus.initial,
  );

  MarketsState copyWith({
    List<Market>? markets,
    List<Product>? relProducts,
    Market? curMarket,
    String? errMsg,
    LoadingStatus? status,
  }) {
    return MarketsState(
      markets: markets ?? this.markets,
      relProducts: relProducts ?? this.relProducts,
      curMarket: curMarket ?? this.curMarket,
      errMsg: errMsg ?? this.errMsg,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'Products State ::\nCurrent Market: $curMarket\nStatus: $status\nError: $errMsg\nMarkets: $markets\nRelated Products: $relProducts\n';
  }

  @override
  List<Object?> get props => [
        markets,
        relProducts,
        curMarket,
        errMsg,
        status,
      ];
}
