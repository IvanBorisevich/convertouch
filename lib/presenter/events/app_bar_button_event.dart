import 'package:convertouch/model/app_bar_action.dart';
import 'package:convertouch/model/app_bar_button_side.dart';
import 'package:convertouch/presenter/events/base_event.dart';

class AppBarButtonEvent extends BlocEvent {
  const AppBarButtonEvent({
    required this.buttonAction,
    required this.buttonSide,
    required this.isButtonEnabled,
  });

  final ConvertouchAction buttonAction;
  final AppBarButtonSide buttonSide;
  final bool isButtonEnabled;

  @override
  List<Object> get props => [
    buttonAction,
    buttonSide,
    isButtonEnabled,
  ];

  @override
  String toString() {
    return 'AppBarButtonEvent{'
        'buttonAction: $buttonAction, '
        'buttonSide: $buttonSide, '
        'isButtonEnabled: $isButtonEnabled}';
  }
}