part of 'ads_bloc.dart';

sealed class AdsEvent extends Equatable {
  const AdsEvent();

  @override
  List<Object> get props => [];
}

class AdsLoadingEvent extends AdsEvent {}

class AdSelectedEvent extends AdsEvent {
  final Advertisment ad;
  const AdSelectedEvent(this.ad);

  @override
  List<Object> get props => [ad];
}

class AdsUpdatedEvent extends AdsEvent {
  final List<Advertisment> ads;
  const AdsUpdatedEvent(this.ads);

  @override
  List<Object> get props => [ads];
}
