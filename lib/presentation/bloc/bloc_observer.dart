import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchBlocObserver extends BlocObserver {

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log("Convertouch event: $event");
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log(transition.toString());
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log(error.toString());
    super.onError(bloc, error, stackTrace);
  }
}