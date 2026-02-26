import 'package:convertouch/presentation/bloc/abstract_state.dart';
import 'package:flutter/foundation.dart';

abstract class ConvertouchTooltipState extends ConvertouchState {
  final Key? key;

  const ConvertouchTooltipState({
    required this.key,
  });

  @override
  List<Object?> get props => [key];
}

class TooltipVisible extends ConvertouchTooltipState {
  const TooltipVisible({
    required super.key,
  });

  @override
  String toString() {
    return 'TooltipVisible{key: $key}';
  }
}

class TooltipHidden extends ConvertouchTooltipState {
  const TooltipHidden({
    required super.key,
  });

  @override
  String toString() {
    return 'TooltipHidden{key: $key}';
  }
}
