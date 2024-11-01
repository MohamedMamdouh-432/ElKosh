part of 'admin_markets_bloc.dart';

sealed class AdminMarketsEvent extends Equatable {
  const AdminMarketsEvent();

  @override
  List<Object> get props => [];
}

class AdminMarketsLoadingEvent extends AdminMarketsEvent {
  final int? limit;
  const AdminMarketsLoadingEvent([this.limit]);

  @override
  List<Object> get props => [limit ?? 0];
}

class AdminMarketSelectedEvent extends AdminMarketsEvent {
  final Market market;
  const AdminMarketSelectedEvent(this.market);

  @override
  List<Object> get props => [market];
}

class AdminMarketAddingEvent extends AdminMarketsEvent {}

class AdminMarketDeletingEvent extends AdminMarketsEvent {
  final String marketId;
  const AdminMarketDeletingEvent(this.marketId);

  @override
  List<Object> get props => [marketId];
}
