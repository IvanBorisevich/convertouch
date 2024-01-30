import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/keyboard/model/keyboard_models.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/keyboard/model/keyboard_numeric_map.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

const Map<KeyboardType, List<List<KeyboardButton>>> keyboardMaps = {
  KeyboardType.numeric: numericKeyboardMap,
};

class ConvertouchKeyboard extends StatelessWidget
    with KeyboardCustomPanelMixin<String?>
    implements PreferredSizeWidget {
  static const double _keysPadding = 5;
  static const double _kKeyboardHeight = 230;

  final KeyboardType keyboardType;
  final RegExp? inputFormatter;
  @override
  final ValueNotifier<String?> notifier;
  final void Function()? onDoneClick;

  const ConvertouchKeyboard({
    required this.keyboardType,
    this.inputFormatter,
    required this.notifier,
    this.onDoneClick,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(_kKeyboardHeight);

  @override
  Widget build(BuildContext context) {
    List<List<KeyboardButton>> keyboardMap = keyboardMaps[keyboardType]!;

    double keyboardWidth = MediaQuery.of(context).size.width;
    int rowsNum = keyboardMap.length;
    int columnsNum = keyboardMap.first.length;

    double keyButtonWidth =
        (keyboardWidth - _keysPadding * (columnsNum + 1)) / columnsNum;
    double keyButtonHeight =
        (_kKeyboardHeight - _keysPadding * (rowsNum + 1)) / rowsNum;

    return Container(
      height: preferredSize.height,
      decoration: const BoxDecoration(color: Color(0xFFC5D8FC)),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Column(
            children: [
              for (int i = 0; i < keyboardMap.length; i++)
                Row(
                  children: [
                    for (int j = 0; j < keyboardMap[i].length; j++)
                      _buildButton(
                        keyboardButton: keyboardMap[i][j],
                        last: j == keyboardMap[i].length - 1,
                        width: keyButtonWidth,
                        height: keyButtonHeight,
                      )
                  ],
                )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required KeyboardButton keyboardButton,
    required double width,
    required double height,
    bool last = false,
    void Function()? onPressed,
    void Function()? onLongPress,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: _keysPadding,
        top: _keysPadding,
        right: last ? _keysPadding : 0,
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF5882AB),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: TextButton(
            onPressed: () {
              if (keyboardButton.isEmpty()) {
                return;
              }
              if (onPressed != null) {
                onPressed.call();
                return;
              }
              if (keyboardButton.key == okKey) {
                onDoneClick?.call();
                return;
              }

              String currentValue = notifier.value ?? "";
              String newValue;
              if (keyboardButton.key != backspaceKey) {
                newValue = currentValue + keyboardButton.key;
              } else {
                if (currentValue.isNotEmpty) {
                  newValue = currentValue.substring(0, currentValue.length - 1);
                } else {
                  newValue = currentValue;
                }
              }

              bool matchesFormatter = inputFormatter != null &&
                      inputFormatter!.hasMatch(newValue) ||
                  inputFormatter == null;

              if (newValue.isEmpty || matchesFormatter) {
                updateValue(newValue);
              }
            },
            onLongPress: () {
              if (keyboardButton.isEmpty()) {
                return;
              }
              if (onLongPress != null) {
                onLongPress.call();
                return;
              }
              if (keyboardButton.key == okKey) {
                return;
              }

              if (keyboardButton.key == backspaceKey) {
                updateValue("");
              }
            },
            child: keyboardButton.logo != null
                ? Icon(
                    keyboardButton.logo,
                    color: const Color(0xFFF5F7FF),
                  )
                : Text(
                    keyboardButton.key,
                    style: const TextStyle(
                      color: Color(0xFFF5F7FF),
                      fontSize: 18,
                      fontFamily: quicksandFontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
