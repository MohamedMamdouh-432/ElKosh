part of 'admin_markets_bloc.dart';

sealed class AdminMarketsEvent extends Equatable {
  const AdminMarketsEvent();

  @override
  List<Object> get props => [];
}

class AdminMarketsLoadingEvent extends AdminMarketsEvent {}

class AdminMarketSelectedEvent extends AdminMarketsEvent {
  final Market market;
  const AdminMarketSelectedEvent(this.market);

  @override
  List<Object> get props => [market];
}

class AdminMarketAddingEvent extends AdminMarketsEvent {}

class AdminMarketBlockingEvent extends AdminMarketsEvent {
  final String marketId;
  const AdminMarketBlockingEvent(this.marketId);

  @override
  List<Object> get props => [marketId];
}

class AdminMarketUnBlockingEvent extends AdminMarketsEvent {
  final String marketId;
  const AdminMarketUnBlockingEvent(this.marketId);

  @override
  List<Object> get props => [marketId];
}

class AdminMarketDeletingEvent extends AdminMarketsEvent {
  final String marketId;
  const AdminMarketDeletingEvent(this.marketId);

  @override
  List<Object> get props => [marketId];
}
