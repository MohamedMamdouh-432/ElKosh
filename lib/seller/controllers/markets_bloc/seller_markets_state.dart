part of 'seller_markets_bloc.dart';

class SellerMarketsState extends Equatable {
  final List<Market> markets;
  final Market curMarket;
  final String errMsg;
  final LoadingStatus status;

  const SellerMarketsState({
    required this.markets,
    required this.curMarket,
    required this.errMsg,
    required this.status,
  });

  static SellerMarketsState initial = SellerMarketsState(
    markets: const [],
    curMarket: Market.empty,
    errMsg: '',
    status: LoadingStatus.initial,
  );

  SellerMarketsState copyWith({
    List<Market>? markets,
    Market? curMarket,
    String? errMsg,
    LoadingStatus? status,
  }) {
    return SellerMarketsState(
      markets: markets ?? this.markets,
      curMarket: curMarket ?? this.curMarket,
      errMsg: errMsg ?? this.errMsg,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'Seller Markets State ::\nCurrent Market: $curMarket\nStatus: $status\nError: $errMsg\nMarkets: ${markets.length}\n';
  }

  @override
  List<Object?> get props => [
        markets,
        curMarket,
        errMsg,
        status,
      ];
}
