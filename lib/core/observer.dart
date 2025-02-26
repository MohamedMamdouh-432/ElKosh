import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models_repository/models_repository.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    AppLogs.debug(change.nextState.toString());
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    AppLogs.debug(transition.nextState.toString());
  }
}

