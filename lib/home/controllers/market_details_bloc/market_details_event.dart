part of 'market_details_bloc.dart';

sealed class MarketDetailsEvent extends Equatable {
  const MarketDetailsEvent();

  @override
  List<Object> get props => [];
}

class MarketDetailsLoadingEvent extends MarketDetailsEvent {}

class MarketDetailsUpdatingEvent extends MarketDetailsEvent {
  final Market market;

  const MarketDetailsUpdatingEvent(this.market);

  @override
  List<Object> get props => [market];
}
