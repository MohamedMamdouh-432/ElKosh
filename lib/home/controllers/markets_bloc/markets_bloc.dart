import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'markets_event.dart';
part 'markets_state.dart';

class MarketsBloc extends Bloc<MarketsEvent, MarketsState> {
  MarketsBloc() : super(MarketsInitial()) {
    on<MarketsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
