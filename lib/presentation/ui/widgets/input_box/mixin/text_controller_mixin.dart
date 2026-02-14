import 'package:flutter/material.dart';

mixin TextControllerMixin {
  TextEditingController initOrGetController(
    TextEditingController? controller, {
    String? initialValue,
  }) {
    var resultController = controller ?? TextEditingController();

    if (initialValue != null && initialValue.isNotEmpty) {
      updateTextControllerValue(resultController, newValue: initialValue);
    }

    return resultController;
  }

  void Function() addTextValueListener({
    required TextEditingController controller,
    required void Function(String?)? onValueChange,
  }) {
    textValueListener() {
      onValueChange?.call(controller.text);
    }

    controller.addListener(textValueListener);
    return textValueListener;
  }

  void updateTextControllerValue(
    TextEditingController controller, {
    String? newValue,
  }) {
    String newVal = newValue ?? '';

    if (controller.text == newVal) {
      return;
    }

    int offset = controller.selection.baseOffset;

    if (offset > newVal.length) {
      offset = newVal.length;
    }

    controller.value = controller.value.copyWith(
      text: newVal,
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
