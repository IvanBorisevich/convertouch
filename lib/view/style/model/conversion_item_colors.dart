import 'package:convertouch/view/style/model/item_colors.dart';
import 'package:flutter/material.dart';

class ConvertouchConversionItemColors extends ConvertouchItemColors {
  const ConvertouchConversionItemColors({
    required Color borderColor,
    required Color borderColorSelected,
    required this.unitButtonBackgroundColor,
    required this.unitButtonBackgroundColorSelected,
    required this.unitButtonTextColor,
    required this.unitButtonTextColorSelected,
    required this.unitValueTextColor,
  }) : super(
    borderColor: borderColor,
    borderColorSelected: borderColorSelected,
  );

  final Color unitButtonBackgroundColor;
  final Color unitButtonBackgroundColorSelected;
  final Color unitButtonTextColor;
  final Color unitButtonTextColorSelected;
  final Color unitValueTextColor;
}
