import 'package:convertouch/model/app_bar_action.dart';
import 'package:convertouch/model/app_bar_button_side.dart';
import 'package:convertouch/presenter/events/app_bar_button_event.dart';
import 'package:convertouch/presenter/states/app_bar_button_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBarButtonsBloc
    extends Bloc<AppBarButtonEvent, AppBarButtonState> {
  AppBarButtonsBloc()
      : super(const AppBarButtonState(
            buttonAction: ConvertouchAction.menu,
            buttonSide: AppBarButtonSide.left,
            isButtonVisible: true,
            isButtonEnabled: true));

  @override
  Stream<AppBarButtonState> mapEventToState(
      AppBarButtonEvent event) async* {
    yield AppBarButtonState(
        buttonAction: event.buttonAction,
        buttonSide: event.buttonSide,
        isButtonVisible: event.buttonAction != ConvertouchAction.none,
        isButtonEnabled: event.isButtonEnabled);
  }
}
