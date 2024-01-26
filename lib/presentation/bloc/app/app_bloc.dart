import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/app/app_event.dart';
import 'package:convertouch/presentation/bloc/app/app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends ConvertouchBloc<AppEvent, AppState> {
  AppBloc() : super(const AppStateBuilt()) {
    on<ChangeUITheme>(_onThemeChange);
  }

  _onThemeChange(
    ChangeUITheme event,
    Emitter<AppState> emit,
  ) async {
    emit(const AppStateInBuilding());
    emit(
      AppStateBuilt(
        theme: event.newTheme,
      ),
    );
  }
}
