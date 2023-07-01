import 'package:flutter/material.dart';

class ConvertouchItemsMenuAnimation {
  static const int _menuViewModeButtonAnimationDuration = 150;

  static Widget wrapIntoAnimation(Widget menuViewModeButton) {
    return AnimatedSwitcher(
        duration:
            const Duration(milliseconds: _menuViewModeButtonAnimationDuration),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(
              scale: animation,
              child: FadeTransition(opacity: animation, child: child));
        },
        child: menuViewModeButton);
  }
}
