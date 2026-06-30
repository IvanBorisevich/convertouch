import 'package:convertouch/presentation/bloc/abstract_state.dart';

class RefreshButtonState extends ConvertouchState {
  final int unitGroupId;
  final bool visible;
  final bool disabled;

  const RefreshButtonState({
    required this.unitGroupId,
    this.visible = false,
    this.disabled = false,
  });

  @override
  List<Object?> get props => [
        unitGroupId,
        visible,
        disabled,
      ];

  @override
  String toString() {
    return 'RefreshButtonState{'
        'unitGroupId: $unitGroupId, '
        'visible: $visible, '
        'disabled: $disabled}';
  }
}
