import 'package:flutter/material.dart';

class ConvertouchItemsViewModeButtonAnimation {
  static Widget wrapIntoAnimation(
    Widget menuViewModeButton, {
    Duration duration = const Duration(milliseconds: 150),
  }) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: menuViewModeButton,
    );
  }
}
