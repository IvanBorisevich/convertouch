import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class RefreshButtonEvent extends ConvertouchEvent {
  final int unitGroupId;

  const RefreshButtonEvent({
    required this.unitGroupId,
  });

  @override
  List<Object?> get props => [
        unitGroupId,
      ];
}

class ShowRefreshButton extends RefreshButtonEvent {
  final bool disabled;

  const ShowRefreshButton({
    required super.unitGroupId,
    this.disabled = false,
  });

  @override
  List<Object?> get props => [
        unitGroupId,
        disabled,
      ];

  @override
  String toString() {
    return 'ShowRefreshButton{disabled: $disabled}';
  }
}

class HideRefreshButton extends RefreshButtonEvent {
  const HideRefreshButton({
    required super.unitGroupId,
  });

  @override
  String toString() {
    return 'HideRefreshButton{}';
  }
}
