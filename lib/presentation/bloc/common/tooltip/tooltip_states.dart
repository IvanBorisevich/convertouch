import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class ConvertouchTooltipState extends ConvertouchState {
  const ConvertouchTooltipState();
}

class TooltipVisible extends ConvertouchTooltipState {
  const TooltipVisible();

  @override
  String toString() {
    return 'TooltipVisible{}';
  }
}

class TooltipHidden extends ConvertouchTooltipState {
  const TooltipHidden();

  @override
  String toString() {
    return 'TooltipHidden{}';
  }
}