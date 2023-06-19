import 'package:convertouch/model/app_bar_action.dart';
import 'package:convertouch/model/app_bar_button_side.dart';
import 'package:convertouch/presenter/states/base_state.dart';

class AppBarButtonState extends BlocState {
  const AppBarButtonState({
    required this.buttonAction,
    required this.buttonSide,
    required this.isButtonVisible,
    required this.isButtonEnabled,
  });

  final ConvertouchAction buttonAction;
  final AppBarButtonSide buttonSide;
  final bool isButtonVisible;
  final bool isButtonEnabled;

  @override
  List<Object> get props =>
      [
        buttonAction,
        buttonSide,
        isButtonVisible,
        isButtonEnabled,
      ];

  @override
  String toString() {
    return 'AppBarButtonState{'
        'buttonAction: $buttonAction, '
        'buttonSide: $buttonSide, '
        'isButtonVisible: $isButtonVisible, '
        'isButtonEnabled: $isButtonEnabled}';
  }
}