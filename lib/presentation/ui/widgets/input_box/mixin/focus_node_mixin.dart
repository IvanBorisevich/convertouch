import 'package:flutter/material.dart';

mixin FocusNodeMixin {
  FocusNode initOrGetFocusNode(FocusNode? focusNode) {
    return focusNode ?? FocusNode();
  }

  void Function() addFocusListener({
    required FocusNode focusNode,
    void Function()? onFocusSelected,
    void Function()? onFocusLeft,
  }) {
    focusListener() async {
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
    required FocusNode focusNode,
    void Function()? focusListener,
  }) {
    if (focusListener != null) {
      focusNode.removeListener(focusListener);
    }
    focusNode.dispose();
  }
}
