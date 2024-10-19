part of 'seller_markets_bloc.dart';

sealed class SellerMarketsEvent extends Equatable {
  const SellerMarketsEvent();

  @override
  List<Object> get props => [];
}

class SellerMarketsLoadingEvent extends SellerMarketsEvent {
  final int? limit;
  const SellerMarketsLoadingEvent([this.limit]);

  @override
  List<Object> get props => [limit ?? 0];
}

class SellerMarketSelectedEvent extends SellerMarketsEvent {
  final Market market;
  const SellerMarketSelectedEvent(this.market);

  @override
  List<Object> get props => [market];
}

class SellerMarketAddingEvent extends SellerMarketsEvent {}

class SellerMarketDeletingEvent extends SellerMarketsEvent {
  final String marketId;
  const SellerMarketDeletingEvent(this.marketId);

  @override
  List<Object> get props => [marketId];
}