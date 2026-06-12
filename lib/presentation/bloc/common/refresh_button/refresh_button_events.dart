import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class RefreshButtonEvent extends ConvertouchEvent {
  const RefreshButtonEvent();
}

class ShowRefreshButton extends RefreshButtonEvent {
  final bool disabled;

  const ShowRefreshButton({
    this.disabled = false,
  });

  @override
  List<Object?> get props => [
        disabled,
      ];

  @override
  String toString() {
    return 'ShowRefreshButton{disabled: $disabled}';
  }
}

class HideRefreshButton extends RefreshButtonEvent {
  const HideRefreshButton();

  @override
  String toString() {
    return 'HideRefreshButton{}';
  }
}
