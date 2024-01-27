import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:flutter/cupertino.dart';

abstract class AppEvent extends ConvertouchEvent {
  const AppEvent();
}

class ChangeUITheme extends AppEvent {
  final ConvertouchUITheme newTheme;

  const ChangeUITheme({
    required this.newTheme,
  });

  @override
  String toString() {
    return 'ChangeUITheme{newTheme: $newTheme}';
  }
}

class ShowKeyboard extends AppEvent {
  final ValueNotifier<bool> focusNotifier;
  final FocusNode focusNode;

  const ShowKeyboard({
    required this.focusNotifier,
    required this.focusNode,
  });
}
