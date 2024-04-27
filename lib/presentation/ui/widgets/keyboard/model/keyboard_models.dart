import 'package:convertouch/domain/constants/constants.dart';
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

const String backspaceKey = "backspace";
const String okKey = "OK";

const Map<ConvertouchValueType, TextInputType> inputValueTypeToKeyboardTypeMap = {
  ConvertouchValueType.text: TextInputType.text,
  ConvertouchValueType.integer: TextInputType.numberWithOptions(
    signed: true,
    decimal: false,
  ),
  ConvertouchValueType.integerPositive: TextInputType.numberWithOptions(
    signed: false,
    decimal: false,
  ),
  ConvertouchValueType.decimal: TextInputType.numberWithOptions(
    signed: true,
    decimal: true,
  ),
  ConvertouchValueType.decimalPositive: TextInputType.numberWithOptions(
    signed: false,
    decimal: true,
  ),
  ConvertouchValueType.hexadecimal: TextInputType.text,
};

const Map<ConvertouchValueType, List<List<KeyboardButton>>> keyboardMaps = {
  ConvertouchValueType.decimal: decimalSignedKeyboardMap,
};

final Map<ConvertouchValueType, RegExp> inputValueTypeToRegExpMap = {
  ConvertouchValueType.text: RegExp(r'(^[a-zA-Z\d ]+$)'),
  ConvertouchValueType.integer: RegExp(r'(^[.-]?$)|(^-?\d+$)'),
  ConvertouchValueType.integerPositive: RegExp(r'(^\d+$)'),
  ConvertouchValueType.decimal: RegExp(r'(^[.-]?$)|(^-?\d+\.?\d*$)'),
  ConvertouchValueType.decimalPositive: RegExp(r'(^\d+\.?\d*$)'),
  ConvertouchValueType.hexadecimal: RegExp(r'^0[xX][\da-fA-F]+$'),
};
