import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';
import 'package:flutter/material.dart';

class AppState extends ConvertouchState {
  final ConvertouchUITheme theme;
  final ValueNotifier<bool>? focusNotifier;
  final FocusNode? focusNode;

  const AppState({
    this.theme = ConvertouchUITheme.light,
    this.focusNotifier,
    this.focusNode,
  });

  @override
  List<Object?> get props => [
    theme,
    focusNotifier,
    focusNode,
  ];

  @override
  String toString() {
    return 'AppState{'
        'theme: $theme}';
  }
}
