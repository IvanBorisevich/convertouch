import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

enum KeyboardType {
  text,
  numeric,
  numericHexadecimal,
}

final RegExp customDecimalNegativeNumbersFormatter =
    RegExp(r'(^-$)|(^-?\d+\.?\d*$)');

final TextInputFormatter decimalNegativeNumbersFormatter =
    FilteringTextInputFormatter.allow(RegExp(r'(^[.-]?$)|(^-?\d+\.?\d*$)'));

const decimalNegativeNumbersType = TextInputType.numberWithOptions(
  signed: true,
  decimal: true,
);

const String backspaceKey = "backspace";
const String okKey = "OK";
