part of 'market_details_bloc.dart';

class MarketDetailsState extends Equatable {
  final Market market;
  final LoadStatus status;
  final String errMsg;

  const MarketDetailsState({
    required this.market,
    required this.status,
    required this.errMsg,
  });

  static MarketDetailsState initial = MarketDetailsState(
    market: Market.empty,
    errMsg: '',
    status: LoadStatus.initial,
  );

  MarketDetailsState copyWith({
    Market? market,
    LoadStatus? status,
    String? errMsg,
  }) {
    return MarketDetailsState(
      market: market ?? this.market,
      status: status ?? this.status,
      errMsg: errMsg ?? this.errMsg,
    );
  }

  @override
  String toString() => '''Market Details State :: 
    Name: ${market.name}
    Status: ${status.name}
    Error: $errMsg
  ''';

  @override
  List<Object> get props => [market, status, errMsg];
}
