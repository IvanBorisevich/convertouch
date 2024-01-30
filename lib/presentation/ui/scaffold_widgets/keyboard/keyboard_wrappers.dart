import 'package:convertouch/presentation/ui/scaffold_widgets/keyboard/keyboard.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/keyboard/model/keyboard_models.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class KeyboardActionsWrapper extends StatelessWidget {
  final KeyboardType keyboardType;
  final RegExp? inputFormatter;
  final FocusNode focusNode;
  final TextEditingController controller;
  final ValueNotifier<String?> notifier;
  final Widget child;

  const KeyboardActionsWrapper({
    required this.keyboardType,
    this.inputFormatter,
    required this.focusNode,
    required this.controller,
    required this.notifier,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
      tapOutsideBehavior: TapOutsideBehavior.opaqueDismiss,
      config: KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        nextFocus: false,
        keyboardBarElevation: 2,
        actions: [
          KeyboardActionsItem(
            focusNode: focusNode,
            displayArrows: false,
            displayActionBar: false,
            displayDoneButton: false,
            footerBuilder: (_) => ConvertouchKeyboard(
              keyboardType: keyboardType,
              notifier: notifier,
              inputFormatter: inputFormatter,
              onDoneClick: () {
                focusNode.unfocus();
              },
            ),
          ),
        ],
      ),
      child: KeyboardCustomInput<String?>(
        focusNode: focusNode,
        notifier: notifier,
        builder: (context, val, hasFocus) {
          controller.text = val ?? "";
          return child;
        },
      ),
    );
  }
}
