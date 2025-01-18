import 'dart:async';

import 'package:data_repository/data_repository.dart';
import 'package:elkosh/shared/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

part 'ad_details_event.dart';
part 'ad_details_state.dart';

class AdDetailsBloc extends Bloc<AdDetailsEvent, AdDetailsState> {
  StreamSubscription? _subscription;
  AdDetailsBloc() : super(AdDetailsState.initial) {
    on<AdDetailsLoadingEvent>(_onAdDetailsLoaded);
    on<AdDetailsUpdatingEvent>(_onAdDetailsUpdated);

    _subscription = sl.get<DataRepository>().adDetailsStream().listen(
          (result) => result.fold((l) => addError(l.message),
              (r) => add(AdDetailsUpdatingEvent(r))),
        );
  }

  FutureOr<void> _onAdDetailsLoaded(AdDetailsLoadingEvent event, emit) {
    emit(state.copyWith(status: LoadStatus.inProgress));
    emit(state.copyWith(
      status: LoadStatus.success,
      ad: sl.get<DataRepository>().getCurAd(),
    ));
  }

  FutureOr<void> _onAdDetailsUpdated(AdDetailsUpdatingEvent event, emit) {
    emit(state.copyWith(
      ad: event.ad,
      status: LoadStatus.success,
    ));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _subscription = null;
    return super.close();
  }
}
