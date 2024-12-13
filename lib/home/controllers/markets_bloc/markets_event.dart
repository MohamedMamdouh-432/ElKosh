part of 'markets_bloc.dart';

sealed class MarketsEvent extends Equatable {
  const MarketsEvent();

  @override
  List<Object> get props => [];
}

class MarketsLoadingEvent extends MarketsEvent {}

class MarketSelectedEvent extends MarketsEvent {
  final Market market;
  const MarketSelectedEvent(this.market);

  @override
  List<Object> get props => [market];
}
