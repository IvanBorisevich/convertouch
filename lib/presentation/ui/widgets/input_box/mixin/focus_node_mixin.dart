import 'package:flutter/material.dart';

mixin FocusNodeMixin {
  FocusNode initOrGetFocusNode({FocusNode? initial}) {
    return initial ?? FocusNode();
  }

  void Function() addFocusListener({
    required FocusNode focusNode,
    void Function()? onFocusSelected,
    void Function()? onFocusLeft,
  }) {
    focusListener() {
      if (focusNode.hasFocus) {
        onFocusSelected?.call();
      } else {
        onFocusLeft?.call();
      }
    }

    focusNode.addListener(focusListener);
    return focusListener;
  }

  void disposeFocusNode({
    required FocusNode? focusNode,
    void Function()? listener,
  }) {
    if (listener != null) {
      focusNode?.removeListener(listener);
    }
    focusNode?.dispose();
  }
}
