part of 'markets_bloc.dart';

sealed class MarketsState extends Equatable {
  const MarketsState();
  
  @override
  List<Object> get props => [];
}

final class MarketsInitial extends MarketsState {}
