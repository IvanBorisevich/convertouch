import 'package:convertouch/presentation/bloc/abstract_state.dart';

class RefreshButtonState extends ConvertouchState {
  final bool visible;
  final bool disabled;

  const RefreshButtonState({
    this.visible = false,
    this.disabled = false,
  });

  @override
  List<Object?> get props => [
        visible,
        disabled,
      ];

  @override
  String toString() {
    return 'RefreshButtonState{visible: $visible, disabled: $disabled}';
  }
}
