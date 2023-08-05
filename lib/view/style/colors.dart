import 'package:convertouch/model/constant.dart';
import 'package:convertouch/view/style/model/conversion_item_colors.dart';
import 'package:convertouch/view/style/model/item_colors.dart';
import 'package:convertouch/view/style/model/menu_item_colors.dart';
import 'package:flutter/material.dart';

const Color noColor = Color(0x00000000);
const ConvertouchItemColors defaultItemColors = ConvertouchItemColors();

var unitGroupItemColors = {
  ConvertouchUITheme.light: const ConvertouchMenuItemColors(
    borderColor: Color(0xFFC2CCFF),
    borderColorSelected: Color(0xFFA5B2FF),
    backgroundColor: Color(0xFFECF0FF),
    backgroundColorSelected: Color(0xFFD6DCFF),
    contentColor: Color(0xFF504EB6),
    contentColorSelected: Color(0xFF2E2C8A),
  ),
};

var unitGroupItemColorsInAppBar = {
  ConvertouchUITheme.light: const ConvertouchMenuItemColors(
    borderColor: Color(0xFF426F99),
    borderColorSelected: Color(0xFF426F99),
    backgroundColor: Color(0x00000000),
    backgroundColorSelected: Color(0x00000000),
    contentColor: Color(0xFF426F99),
    contentColorSelected: Color(0xFF426F99),
  ),
};

var unitItemColors = {
  ConvertouchUITheme.light: const ConvertouchMenuItemColors(
    borderColor: Color(0xFFB5DBFF),
    borderColorMarked: Color(0xFF509CE0),
    borderColorSelected: Color(0xFF2F7DC2),
    backgroundColor: Color(0xFFDFEDFF),
    backgroundColorMarked: Color(0xFFCCE1FF),
    backgroundColorSelected: Color(0xFF95BBF3),
    contentColor: Color(0xFF366C9F),
    contentColorMarked: Color(0xFF366C9F),
    contentColorSelected: Color(0xFF0A4175),
  ),
};

var conversionItemColors = {
  ConvertouchUITheme.light: const ConvertouchConversionItemColors(
    borderColor: Color(0xFF7FA0BE),
    borderColorSelected: Color(0xFF375067),
    unitButtonBackgroundColor: Color(0xFFE2EEF8),
    unitButtonBackgroundColorSelected: Color(0xFFB9D7F1),
    unitButtonTextColor: Color(0xFF426F99),
    unitButtonTextColorSelected: Color(0xFF2D4B67),
    unitValueTextColor: Color(0xFF426F99),
  ),
};
