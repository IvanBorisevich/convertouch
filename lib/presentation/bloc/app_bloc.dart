import 'package:convertouch/domain/model/input/app_event.dart';
import 'package:convertouch/domain/model/output/app_state.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';

class AppBloc extends ConvertouchBloc<AppEvent, AppState> {
  AppBloc() : super(const AppStateBuilt());

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    yield const AppStateInBuilding();

    if (event is ChangeUITheme) {
      yield AppStateBuilt(
        theme: event.newTheme,
      );
    }
  }
}
