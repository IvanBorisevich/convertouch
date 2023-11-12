import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/pages/style/model/color.dart';
import 'package:convertouch/presentation/pages/style/model/color_variation.dart';
import 'package:flutter/material.dart';

const Color noColor = Colors.transparent;

const unitsPageFloatingButtonColor = {
  ConvertouchUITheme.light: Color(0xFF5499DA),
};

const unitGroupsPageFloatingButtonColor = {
  ConvertouchUITheme.light: Color(0xFF7473FA),
};

const conversionPageFloatingButtonColor = {
  ConvertouchUITheme.light: Color(0xFF6793BE),
};

const removalFloatingButtonColor = {
  ConvertouchUITheme.light: Color(0xFFB04731),
};

const dividerWithTextColor = {
  ConvertouchUITheme.light: Color(0xFF426F99),
};

const scaffoldColor = {
  ConvertouchUITheme.light: ConvertouchScaffoldColor(
    regular: ScaffoldColorVariation(
      backgroundColor: Color(0xFFFCFEFF),
      appBarColor: Color(0xFFDEE9FF),
      appBarFontColor: Color(0xFF426F99),
      appBarIconColor: Color(0xFF426F99),
      appBarIconColorDisabled: Color(0xFFA0C4F5),
    ),
  ),
};

const sideMenuColor = {
  ConvertouchUITheme.light: ConvertouchSideMenuColor(
    regular: SideMenuColorVariation(
      backgroundColor: Color(0xFFDEEBFC),
      headerColor: Color(0xFFB0D7FC),
      contentColor: Color(0xFF134B80),
      activeSwitcherColor: Color(0xFF3E8DD7),
      footerDividerColor: Color(0xFF84ADD7),
    ),
  ),
};

const searchBarColor = {
  ConvertouchUITheme.light: ConvertouchSearchBarColor(
    regular: SearchBarColorVariation(
      searchBoxIconColor: Color(0xFF7BA2D3),
      searchBoxFillColor: Color(0xFFF6F9FF),
      hintColor: Color(0xFF7BA2D3),
      textColor: Color(0xFF426F99),
      viewModeButtonColor: Color(0xFFF6F9FF),
      viewModeIconColor: Color(0xFF426F99),
    ),
  ),
};

const textBoxColor = {
  ConvertouchUITheme.light: ConvertouchTextBoxColor(
    regular: TextBoxColorVariation(
      border: Color(0xFF426F99),
      content: Color(0xFF426F99),
      label: Color(0xFF426F99),
    ),
    focused: TextBoxColorVariation(
      border: Color(0xFF426F99),
      content: Color(0xFF426F99),
      label: Color(0xFF426F99),
    ),
  ),
};

const unitGroupItemColor = {
  ConvertouchUITheme.light: ConvertouchMenuItemColor(
    regular: MenuItemColorVariation(
      border: Color(0xFFC2CCFF),
      background: Color(0xFFECF0FF),
      content: Color(0xFF504EB6),
    ),
    selected: MenuItemColorVariation(
      border: Color(0xFFA5B2FF),
      background: Color(0xFFD6DCFF),
      content: Color(0xFF2E2C8A),
    ),
  ),
};

const appBarUnitGroupItemColor = {
  ConvertouchUITheme.light: ConvertouchMenuItemColor(
    regular: MenuItemColorVariation(
      border: Color(0xFF426F99),
      content: Color(0xFF426F99),
    ),
    selected: MenuItemColorVariation(
      border: Color(0xFF426F99),
      content: Color(0xFF426F99),
    ),
  ),
};

const unitItemColor = {
  ConvertouchUITheme.light: ConvertouchMenuItemColor(
    regular: MenuItemColorVariation(
      border: Color(0xFFB5DBFF),
      background: Color(0xFFDFEDFF),
      content: Color(0xFF366C9F),
    ),
    marked: MenuItemColorVariation(
      border: Color(0xFF509CE0),
      background: Color(0xFFCCE1FF),
      content: Color(0xFF366C9F),
    ),
    selected: MenuItemColorVariation(
      border: Color(0xFF2F7DC2),
      background: Color(0xFF95BBF3),
      content: Color(0xFF0A4175),
    ),
  ),
};

const conversionItemColor = {
  ConvertouchUITheme.light: ConvertouchConversionItemColor(
    textBox: ConvertouchTextBoxColor(
      regular: TextBoxColorVariation(
        border: Color(0xFF7FA0BE),
        content: Color(0xFF426F99),
        label: Color(0xFF7FA0BE),
      ),
      focused: TextBoxColorVariation(
        border: Color(0xFF375067),
        content: Color(0xFF426F99),
        label: Color(0xFF7FA0BE),
      ),
    ),
    unitButton: ConvertouchMenuItemColor(
      regular: MenuItemColorVariation(
        border: Color(0xFF7FA0BE),
        background: Color(0xFFE2EEF8),
        content: Color(0xFF426F99),
      ),
      focused: MenuItemColorVariation(
        border: Color(0xFF375067),
        background: Color(0xFFB9D7F1),
        content: Color(0xFF2D4B67),
      ),
    ),
  ),
};
