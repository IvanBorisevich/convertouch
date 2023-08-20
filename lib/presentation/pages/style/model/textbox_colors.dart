import 'package:convertouch/presentation/pages/style/colors.dart';
import 'package:flutter/material.dart';

class ConvertouchTextBoxColors {
  const ConvertouchTextBoxColors({
    this.borderColor = noColor,
    this.borderColorFocused = noColor,
    this.textColor = noColor,
    this.labelColor = noColor,
  });

  final Color borderColor;
  final Color borderColorFocused;
  final Color textColor;
  final Color labelColor;
}
