import 'package:convertouch/presentation/ui/widgets/keyboard/keyboard.dart';
import 'package:convertouch/presentation/ui/widgets/keyboard/model/keyboard_models.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class KeyboardActionsWrapper extends StatelessWidget {
  final InputType inputType;
  final FocusNode focusNode;
  final TextEditingController controller;
  final ValueNotifier<String?> notifier;
  final Widget child;

  const KeyboardActionsWrapper({
    required this.inputType,
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
              inputType: inputType,
              notifier: notifier,
              inputRegExp: inputTypeToRegExpMap[inputType],
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
