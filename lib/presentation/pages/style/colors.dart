import 'package:convertouch/domain/constants.dart';
import 'package:convertouch/presentation/pages/style/model/conversion_item_colors.dart';
import 'package:convertouch/presentation/pages/style/model/item_colors.dart';
import 'package:convertouch/presentation/pages/style/model/menu_item_colors.dart';
import 'package:convertouch/presentation/pages/style/model/scaffold_colors.dart';
import 'package:convertouch/presentation/pages/style/model/search_bar_colors.dart';
import 'package:convertouch/presentation/pages/style/model/textbox_colors.dart';
import 'package:flutter/material.dart';

const Color noColor = Color(0x00000000);
const ConvertouchItemColors defaultItemColors = ConvertouchItemColors();

const unitsPageFloatingButtonColor = {
  ConvertouchUITheme.light: Color(0xFF5499DA),
};

const unitGroupsPageFloatingButtonColor = {
  ConvertouchUITheme.light: Color(0xFF7473FA),
};

const conversionPageFloatingButtonColor = {
  ConvertouchUITheme.light: Color(0xFF6793BE),
};

const dividerWithTextColor = {
  ConvertouchUITheme.light: Color(0xFF426F99),
};

const scaffoldColors = {
  ConvertouchUITheme.light: ConvertouchScaffoldColors(
    appBarColor: Color(0xFFDEE9FF),
    appBarFontColor: Color(0xFF426F99),
    appBarIconColor: Color(0xFF426F99),
    appBarIconColorDisabled: Color(0xFFA0C4F5),
  ),
};

const searchBarColors = {
  ConvertouchUITheme.light: ConvertouchSearchBarColors(
    searchBoxIconColor: Color(0xFF7BA2D3),
    searchBoxFillColor: Color(0xFFF6F9FF),
    hintColor: Color(0xFF7BA2D3),
    textColor: Color(0xFF426F99),
    viewModeButtonColor: Color(0xFFF6F9FF),
    viewModeIconColor: Color(0xFF426F99),
  ),
};

const textBoxColors = {
  ConvertouchUITheme.light: ConvertouchTextBoxColors(
    borderColor: Color(0xFF426F99),
    borderColorFocused: Color(0xFF426F99),
    textColor: Color(0xFF426F99),
    labelColor: Color(0xFF426F99),
  ),
};

const unitGroupItemColors = {
  ConvertouchUITheme.light: ConvertouchMenuItemColors(
    borderColor: Color(0xFFC2CCFF),
    borderColorSelected: Color(0xFFA5B2FF),
    backgroundColor: Color(0xFFECF0FF),
    backgroundColorSelected: Color(0xFFD6DCFF),
    contentColor: Color(0xFF504EB6),
    contentColorSelected: Color(0xFF2E2C8A),
  ),
};

const unitGroupItemColorsInAppBar = {
  ConvertouchUITheme.light: ConvertouchMenuItemColors(
    borderColor: Color(0xFF426F99),
    borderColorSelected: Color(0xFF426F99),
    backgroundColor: Color(0x00000000),
    backgroundColorSelected: Color(0x00000000),
    contentColor: Color(0xFF426F99),
    contentColorSelected: Color(0xFF426F99),
  ),
};

const unitItemColors = {
  ConvertouchUITheme.light: ConvertouchMenuItemColors(
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

const conversionItemColors = {
  ConvertouchUITheme.light: ConvertouchConversionItemColors(
    textBoxColors: ConvertouchTextBoxColors(
      borderColor: Color(0xFF7FA0BE),
      borderColorFocused: Color(0xFF375067),
      textColor: Color(0xFF426F99),
      labelColor: Color(0xFF7FA0BE),
    ),
    unitButtonBackgroundColor: Color(0xFFE2EEF8),
    unitButtonBackgroundColorSelected: Color(0xFFB9D7F1),
    unitButtonTextColor: Color(0xFF426F99),
    unitButtonTextColorSelected: Color(0xFF2D4B67),
  ),
};
