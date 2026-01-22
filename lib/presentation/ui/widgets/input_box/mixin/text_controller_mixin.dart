import 'package:flutter/material.dart';

mixin TextControllerMixin {
  TextEditingController initOrGetController(
    TextEditingController? controller, {
    String? initialValue,
  }) {
    var resultController = controller ?? TextEditingController();

    if (resultController.text.isEmpty) {
      resultController.text = initialValue ?? '';
    }

    return resultController;
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
}
