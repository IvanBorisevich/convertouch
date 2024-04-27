import 'package:convertouch/presentation/ui/widgets/keyboard/model/keyboard_numeric_map.dart';
import 'package:flutter/material.dart';

class KeyboardButton {
  final String key;
  final IconData? logo;

  const KeyboardButton({
    required this.key,
    this.logo,
  });

  const KeyboardButton.empty()
      : this(
          key: '',
        );

  bool isEmpty() {
    return key.isEmpty;
  }
}

enum InputType {
  text,
  integer,
  integerPositive,
  decimal,
  decimalPositive,
  hexadecimal,
}

const String backspaceKey = "backspace";
const String okKey = "OK";

const Map<InputType, TextInputType> inputTypeToKeyboardTypeMap = {
  InputType.text: TextInputType.text,
  InputType.integer: TextInputType.numberWithOptions(
    signed: true,
    decimal: false,
  ),
  InputType.integerPositive: TextInputType.numberWithOptions(
    signed: false,
    decimal: false,
  ),
  InputType.decimal: TextInputType.numberWithOptions(
    signed: true,
    decimal: true,
  ),
  InputType.decimalPositive: TextInputType.numberWithOptions(
    signed: false,
    decimal: true,
  ),
  InputType.hexadecimal: TextInputType.text,
};

const Map<InputType, List<List<KeyboardButton>>> keyboardMaps = {
  InputType.decimal: decimalSignedKeyboardMap,
};

final Map<InputType, RegExp> inputTypeToRegExpMap = {
  InputType.text: RegExp(r'(^[a-zA-Z\d ]+$)'),
  InputType.integer: RegExp(r'(^[.-]?$)|(^-?\d+$)'),
  InputType.integerPositive: RegExp(r'(^\d+$)'),
  InputType.decimal: RegExp(r'(^[.-]?$)|(^-?\d+\.?\d*$)'),
  InputType.decimalPositive: RegExp(r'(^\d+\.?\d*$)'),
  InputType.hexadecimal: RegExp(r'^0[xX][\da-fA-F]+$'),
};
