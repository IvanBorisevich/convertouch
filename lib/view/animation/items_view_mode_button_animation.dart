import 'package:flutter/material.dart';

class ConvertouchItemsViewModeButtonAnimation {
  static const int _itemsViewModeButtonAnimationDuration = 150;

  static Widget wrapIntoAnimation(Widget menuViewModeButton) {
    return AnimatedSwitcher(
        duration:
            const Duration(milliseconds: _itemsViewModeButtonAnimationDuration),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(
              scale: animation,
              child: FadeTransition(opacity: animation, child: child));
        },
        child: menuViewModeButton);
  }
}
