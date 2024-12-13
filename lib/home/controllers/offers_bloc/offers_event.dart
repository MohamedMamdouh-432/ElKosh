part of 'offers_bloc.dart';

sealed class OffersEvent extends Equatable {
  const OffersEvent();

  @override
  List<Object> get props => [];
}

class OffersLoadingEvent extends OffersEvent {}

class OfferSelectedEvent extends OffersEvent {
  final Offer offer;
  const OfferSelectedEvent(this.offer);

  @override
  List<Object> get props => [offer];
}