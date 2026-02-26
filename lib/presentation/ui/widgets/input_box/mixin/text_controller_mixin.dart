import 'package:flutter/material.dart';

mixin TextControllerMixin {
  TextEditingController initOrGetController(
    TextEditingController? controller, {
    String? initialValue,
  }) {
    var resultController = controller ?? TextEditingController();

    if (initialValue != null && initialValue.isNotEmpty) {
      updateTextControllerValue(resultController, value: initialValue);
    }

    return resultController;
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
