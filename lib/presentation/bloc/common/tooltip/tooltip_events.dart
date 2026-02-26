import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:flutter/foundation.dart';

abstract class ConvertouchTooltipEvent extends ConvertouchEvent {
  final Key? key;

  const ConvertouchTooltipEvent({
    this.key,
  });

  @override
  List<Object?> get props => [key];
}

class ShowTooltip extends ConvertouchTooltipEvent {
  const ShowTooltip({
    super.key,
  });

  @override
  String toString() {
    return 'ShowTooltip{key: $key}';
  }
}

class HideTooltip extends ConvertouchTooltipEvent {
  const HideTooltip({
    super.key,
  });

  @override
  String toString() {
    return 'HideTooltip{key: $key}';
  }
}
