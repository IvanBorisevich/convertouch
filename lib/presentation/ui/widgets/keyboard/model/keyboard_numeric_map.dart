import 'package:convertouch/presentation/ui/widgets/keyboard/model/keyboard_models.dart';
import 'package:flutter/material.dart';

const decimalSignedKeyboardMap = [
  [
    KeyboardButton(key: '1'),
    KeyboardButton(key: '2'),
    KeyboardButton(key: '3'),
    KeyboardButton(key: backspaceKey, logo: Icons.backspace_outlined),
  ],
  [
    KeyboardButton(key: '4'),
    KeyboardButton(key: '5'),
    KeyboardButton(key: '6'),
    KeyboardButton.empty(),
  ],
  [
    KeyboardButton(key: '7'),
    KeyboardButton(key: '8'),
    KeyboardButton(key: '9'),
    KeyboardButton.empty(),
  ],
  [
    KeyboardButton(key: '.'),
    KeyboardButton(key: '0'),
    KeyboardButton(key: '-'),
    KeyboardButton(key: okKey),
  ],

];