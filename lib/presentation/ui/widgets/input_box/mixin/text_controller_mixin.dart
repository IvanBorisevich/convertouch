import 'package:flutter/material.dart';

mixin TextControllerMixin {
  TextEditingController initOrGetController({
    TextEditingController? initial,
    String? initialValue,
  }) {
    var resultController = initial ?? TextEditingController();
    initControllerValue(resultController, initialValue);
    return resultController;
  }

  void Function() addTextListener({
    required TextEditingController controller,
    void Function()? onValueChanged,
  }) {
    textListener() {
      onValueChanged?.call();
    }

    controller.addListener(textListener);
    return textListener;
  }

  void initControllerValue(
    TextEditingController controller,
    String? initialValue,
  ) {
    if (initialValue != null && initialValue.isNotEmpty) {
      updateTextControllerValue(controller, value: initialValue);
    }
  }

  void updateTextControllerValue(
    TextEditingController controller, {
    String? value,
  }) {
    if (value == null) {
      return;
    }

    if (controller.text == value) {
      return;
    }

    int offset = controller.selection.baseOffset;

    if (offset > value.length) {
      offset = value.length;
    }

    controller.value = controller.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: offset),
    );
  }

  void disposeTextController({
    required TextEditingController controller,
    void Function()? listener,
  }) {
    if (listener != null) {
      controller.removeListener(listener);
    }
    controller.dispose();
  }
}
