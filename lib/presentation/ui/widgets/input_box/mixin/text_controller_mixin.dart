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
    String newValue = value ?? '';

    if (controller.text == newValue) {
      return;
    }

    int offset = controller.selection.baseOffset;

    if (offset > newValue.length) {
      offset = newValue.length;
    }

    controller.value = controller.value.copyWith(
      text: newValue,
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
