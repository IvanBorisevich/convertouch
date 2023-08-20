import 'package:convertouch/presentation/pages/style/colors.dart';
import 'package:convertouch/presentation/pages/style/model/item_colors.dart';
import 'package:convertouch/presentation/pages/style/model/textbox_colors.dart';
import 'package:flutter/material.dart';

class ConvertouchConversionItemColors extends ConvertouchItemColors {
  const ConvertouchConversionItemColors({
    required this.textBoxColors,
    this.unitButtonBackgroundColor = noColor,
    this.unitButtonBackgroundColorSelected = noColor,
    this.unitButtonTextColor = noColor,
    this.unitButtonTextColorSelected = noColor,
  });

  final ConvertouchTextBoxColors textBoxColors;
  final Color unitButtonBackgroundColor;
  final Color unitButtonBackgroundColorSelected;
  final Color unitButtonTextColor;
  final Color unitButtonTextColorSelected;
}
