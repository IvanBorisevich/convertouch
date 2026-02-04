import 'package:flutter/material.dart';

mixin TextControllerMixin {
  TextEditingController initOrGetController(
    TextEditingController? controller, {
    String initialValue = '',
  }) {
    var resultController = controller ?? TextEditingController();

    if (initialValue.isNotEmpty) {
      updateTextControllerValue(resultController, initialValue);
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
    TextEditingController controller,
    String newValue,
  ) {
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
