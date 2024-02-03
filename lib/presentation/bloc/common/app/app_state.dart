import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class AppState extends ConvertouchState {
  const AppState();
}

class AppStateInProgress extends AppState {
  const AppStateInProgress();

  @override
  String toString() {
    return 'AppStateInProgress{}';
  }
}

class AppStateReady extends AppState {
  final ConvertouchUITheme theme;

  const AppStateReady({
    this.theme = ConvertouchUITheme.light,
  });

  @override
  List<Object?> get props => [
    theme,
  ];

  @override
  String toString() {
    return 'AppStateReady{'
        'theme: $theme}';
  }
}

class AppErrorState extends ConvertouchErrorState implements AppState {
  const AppErrorState({
    required super.exception,
    required super.lastSuccessfulState,
  });

  @override
  String toString() {
    return 'AppErrorState{'
        'exception: $exception, '
        'lastSuccessfulState: $lastSuccessfulState}';
  }
}
