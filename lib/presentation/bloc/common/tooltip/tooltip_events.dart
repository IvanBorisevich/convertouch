import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class ConvertouchTooltipEvent extends ConvertouchEvent {
  const ConvertouchTooltipEvent();
}

class ShowTooltip extends ConvertouchTooltipEvent {
  const ShowTooltip();

  @override
  String toString() {
    return 'ShowTooltip{}';
  }
}

class HideTooltip extends ConvertouchTooltipEvent {
  const HideTooltip();

  @override
  String toString() {
    return 'HideTooltip{}';
  }
}