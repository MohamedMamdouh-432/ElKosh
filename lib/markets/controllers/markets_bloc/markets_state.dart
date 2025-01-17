part of 'markets_bloc.dart';

class MarketsState extends Equatable {
  final List<Market> markets;
  final Market curMarket;
  final String errMsg;
  final LoadStatus status;

  const MarketsState({
    required this.markets,
    required this.curMarket,
    required this.errMsg,
    required this.status,
  });

  static MarketsState initial = MarketsState(
    markets: const [],
    curMarket: Market.empty,
    errMsg: '',
    status: LoadStatus.initial,
  );

  MarketsState copyWith({
    List<Market>? markets,
    Market? curMarket,
    String? errMsg,
    LoadStatus? status,
  }) {
    return MarketsState(
      markets: markets ?? this.markets,
      curMarket: curMarket ?? this.curMarket,
      errMsg: errMsg ?? this.errMsg,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return '''Markets State ::
      Current Market: ${curMarket.name}
      Status: ${status.name}
      Error: $errMsg
      Markets: ${markets.length}
    ''';
  }

  @override
  List<Object?> get props => [
        markets,
        curMarket,
        errMsg,
        status,
      ];
}
