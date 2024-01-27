import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/app/app_event.dart';
import 'package:convertouch/presentation/bloc/app/app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends ConvertouchBloc<AppEvent, AppState> {
  AppBloc() : super(const AppState()) {
    on<ChangeUITheme>(_onThemeChange);
    on<ShowKeyboard>(
      (event, emit) => emit(
        AppState(
          theme: state.theme,
          focusNotifier: event.focusNotifier,
          focusNode: event.focusNode,
        ),
      ),
    );
  }

  _onThemeChange(
    ChangeUITheme event,
    Emitter<AppState> emit,
  ) async {
    emit(
      AppState(
        theme: event.newTheme,
        focusNotifier: state.focusNotifier,
        focusNode: state.focusNode,
      ),
    );
  }
}
