part of 'admin_markets_bloc.dart';

class AdminMarketsState extends Equatable {
  final List<Market> markets;
  final Market curMarket;
  final String errMsg;
  final LoadingStatus status;

  const AdminMarketsState({
    required this.markets,
    required this.curMarket,
    required this.errMsg,
    required this.status,
  });

  static AdminMarketsState initial = AdminMarketsState(
    markets: const [],
    curMarket: Market.empty,
    errMsg: '',
    status: LoadingStatus.initial,
  );

  AdminMarketsState copyWith({
    List<Market>? markets,
    Market? curMarket,
    String? errMsg,
    LoadingStatus? status,
  }) {
    return AdminMarketsState(
      markets: markets ?? this.markets,
      curMarket: curMarket ?? this.curMarket,
      errMsg: errMsg ?? this.errMsg,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'Admin Markets State ::\nCurrent Market: $curMarket\nStatus: ${status.name}\nError: $errMsg\nMarkets: ${markets.length}\n';
  }

  @override
  List<Object?> get props => [
        markets,
        curMarket,
        errMsg,
        status,
      ];
}
