part of 'ad_details_bloc.dart';

sealed class AdDetailsEvent extends Equatable {
  const AdDetailsEvent();

  @override
  List<Object> get props => [];
}

class AdDetailsLoadingEvent extends AdDetailsEvent {}

class AdDetailsUpdatingEvent extends AdDetailsEvent {
  final Ad ad;

  const AdDetailsUpdatingEvent(this.ad);

  @override
  List<Object> get props => [ad];
}
