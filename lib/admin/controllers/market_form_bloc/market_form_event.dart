part of 'market_form_bloc.dart';

sealed class MarketFormEvent extends Equatable {
  const MarketFormEvent();

  @override
  List<Object> get props => [];
}

class MarketFormPrepared extends MarketFormEvent {
  final Market market;
  const MarketFormPrepared(this.market);
  
  @override
  List<Object> get props => [market];
}

class MarketFormNameChanged extends MarketFormEvent {
  final String name;
  const MarketFormNameChanged(this.name);

  @override
  List<Object> get props => [name];
}

class MarketFormHotlineChanged extends MarketFormEvent {
  final String hotline;
  const MarketFormHotlineChanged(this.hotline);

  @override
  List<Object> get props => [hotline];
}

class MarketFormDescChanged extends MarketFormEvent {
  final String desc;
  const MarketFormDescChanged(this.desc);

  @override
  List<Object> get props => [desc];
}

class MarketFormImgChanged extends MarketFormEvent {}

class MarketFormBeginTimeChanged extends MarketFormEvent {
  final TimeOfDay beginTime;
  const MarketFormBeginTimeChanged(this.beginTime);

  @override
  List<Object> get props => [beginTime];
}

class MarketFormEndTimeChanged extends MarketFormEvent {
  final TimeOfDay endTime;
  const MarketFormEndTimeChanged(this.endTime);

  @override
  List<Object> get props => [endTime];
}

class MarketFormLocationChanged extends MarketFormEvent {
  final Location location;
  const MarketFormLocationChanged(this.location);

  @override
  List<Object> get props => [location];
}

class MarketAddFormSubmitted extends MarketFormEvent {}

class MarketEditFormSubmitted extends MarketFormEvent {}

class MarketFormResetRequested extends MarketFormEvent {}

class MarketFormStatusResetRequested extends MarketFormEvent {}
