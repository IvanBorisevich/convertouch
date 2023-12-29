import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/ui/style/model/color.dart';
import 'package:convertouch/presentation/ui/style/model/color_variation.dart';
import 'package:flutter/material.dart';

const Color noColor = Colors.transparent;

const scaffoldColors = {
  ConvertouchUITheme.light: ConvertouchScaffoldColor(
    regular: ScaffoldColorVariation(
      backgroundColor: Color(0xFFFCFEFF),
      appBarColor: Color(0xFFDEE9FF),
      appBarFontColor: Color(0xFF426F99),
      appBarIconColor: Color(0xFF426F99),
      appBarIconColorDisabled: Color(0xFFA0C4F5),
    ),
  ),
  ConvertouchUITheme.dark: ConvertouchScaffoldColor(
    regular: ScaffoldColorVariation(
      backgroundColor: Color(0xFF373F4B),
      appBarColor: Color(0xFF2C323D),
      appBarFontColor: Color(0xFFCCD7E0),
      appBarIconColor: Color(0xFFCCD7E0),
      appBarIconColorDisabled: Color(0xFF8D8D8D),
    ),
  ),
};

const searchBarColors = {
  ConvertouchUITheme.light: ConvertouchSearchBarColor(
    regular: SearchBarColorVariation(
      searchBoxIconColor: Color(0xFF426F99),
      searchBoxFillColor: Color(0xFFF6F9FF),
      hintColor: Color(0xFF5C93C7),
      textColor: Color(0xFF426F99),
      viewModeButtonColor: Color(0xFFF6F9FF),
      viewModeIconColor: Color(0xFF426F99),
    ),
  ),
  ConvertouchUITheme.dark: ConvertouchSearchBarColor(
    regular: SearchBarColorVariation(
      searchBoxIconColor: Color(0xFFCCD7E0),
      searchBoxFillColor: Color(0xFF444C59),
      hintColor: Color(0xFF8791A1),
      textColor: Color(0xFFB2B2B2),
      viewModeButtonColor: Color(0xFF444C59),
      viewModeIconColor: Color(0xFFCCD7E0),
    ),
  ),
};

const unitGroupItemColors = {
  ConvertouchUITheme.light: ConvertouchListItemColor(
    regular: ListItemColorVariation(
      border: Color(0xFFC2CCFF),
      background: Color(0xFFF2F5FF),
      content: Color(0xFF3A3A88),
    ),
    selected: ListItemColorVariation(
      border: Color(0xFF9EADFA),
      background: Color(0xFFE5EAFF),
      content: Color(0xFF303073),
    ),
  ),
  ConvertouchUITheme.dark: ConvertouchListItemColor(
    regular: ListItemColorVariation(
      border: Color(0xFF585A6C),
      background: Color(0xFF3E4754),
      content: Color(0xFFB1B5EA),
    ),
    selected: ListItemColorVariation(
      border: Color(0xFFA5B2FF),
      background: Color(0xFF3E4754),
      content: Color(0xFFB3B6DE),
    ),
  ),
};

const appBarUnitGroupItemColors = {
  ConvertouchUITheme.light: ConvertouchListItemColor(
    regular: ListItemColorVariation(
      border: Color(0xFF426F99),
      content: Color(0xFF426F99),
    ),
  ),
  ConvertouchUITheme.dark: ConvertouchListItemColor(
    regular: ListItemColorVariation(
      border: Color(0xFF60647E),
      content: Color(0xFFA1A4CE),
    ),
  ),
};

const unitItemColors = {
  ConvertouchUITheme.light: ConvertouchListItemColor(
    regular: ListItemColorVariation(
      border: Color(0xFFB5DBFF),
      background: Color(0xFFDFEDFF),
      content: Color(0xFF366C9F),
    ),
    marked: ListItemColorVariation(
      border: Color(0xFF509CE0),
      background: Color(0xFFCCE1FF),
      content: Color(0xFF366C9F),
    ),
    selected: ListItemColorVariation(
      border: Color(0xFF2F7DC2),
      background: Color(0xFFCCE1FF),
      content: Color(0xFF366C9F),
    ),
  ),
  ConvertouchUITheme.dark: ConvertouchListItemColor(
    regular: ListItemColorVariation(
      border: Color(0xFF54616C),
      background: Color(0xFF3E4754),
      content: Color(0xFF7DAAD3),
    ),
    marked: ListItemColorVariation(
      border: Color(0xFF7A9EBE),
      background: Color(0xE4415F7E),
      content: Color(0xFFA0CAF1),
    ),
    selected: ListItemColorVariation(
      border: Color(0xFF7A9EBE),
      background: Color(0xE4415F7E),
      content: Color(0xFFA0CAF1),
    ),
  ),
};

const conversionItemColors = {
  ConvertouchUITheme.light: ConvertouchConversionItemColor(
    handlersColor: Color(0xFF7FA0BE),
    textBox: ConvertouchTextBoxColor(
      regular: TextBoxColorVariation(
        border: Color(0xFF7FA0BE),
        content: Color(0xFF426F99),
        label: Color(0xFF7FA0BE),
        hint: Color(0xFFA8C9E7),
      ),
      focused: TextBoxColorVariation(
        border: Color(0xFF375067),
        content: Color(0xFF426F99),
        label: Color(0xFF375067),
        hint: Color(0xFFA8C9E7),
      ),
    ),
    unitButton: ConvertouchListItemColor(
      regular: ListItemColorVariation(
        border: Color(0xFF7FA0BE),
        background: Color(0xFFE2EEF8),
        content: Color(0xFF426F99),
      ),
      focused: ListItemColorVariation(
        border: Color(0xFF375067),
        background: Color(0xFFB9D7F1),
        content: Color(0xFF2D4B67),
      ),
    ),
  ),
  ConvertouchUITheme.dark: ConvertouchConversionItemColor(
    handlersColor: Color(0xFF7FA0BE),
    textBox: ConvertouchTextBoxColor(
      regular: TextBoxColorVariation(
        border: Color(0xFF7FA0BE),
        content: Color(0xFF8FB1D0),
        label: Color(0xFF7FA0BE),
      ),
      focused: TextBoxColorVariation(
        border: Color(0xFF98BAD9),
        content: Color(0xFFA0C4E5),
        label: Color(0xFF98BAD9),
      ),
    ),
    unitButton: ConvertouchListItemColor(
      regular: ListItemColorVariation(
        border: Color(0xFF7FA0BE),
        background: Color(0xFF373F4B),
        content: Color(0xFF7FA0BE),
      ),
      focused: ListItemColorVariation(
        border: Color(0xFF8FB1D0),
        background: Color(0xDF49597A),
        content: Color(0xFF8FB1D0),
      ),
    ),
  ),
};

const refreshingJobItemsColors = {
  ConvertouchUITheme.light: RefreshingJobItemColor(
    activeStatusLabel: Color(0xFF3BA93E),
    notActiveStatusLabel: Color(0xFF3A3A88),
    jobItem: ConvertouchListItemColor(
      regular: ListItemColorVariation(
        border: Color(0xFFC2CCFF),
        background: Color(0xFFF2F5FF),
        content: Color(0xFF3A3A88),
      ),
      selected: ListItemColorVariation(
        border: Color(0xFF5262B9),
        background: Color(0xFFE5EAFF),
        content: Color(0xFF303073),
      ),
    ),
    refreshButton: ButtonColor(
      regular: ButtonColorVariation(
        border: Color(0xFF3A3A88),
        background: Color(0xFFF2F5FF),
        foreground: Color(0xFF3A3A88),
      ),
      inactive: ButtonColorVariation(
        border: Color(0xFFC2CCFF),
        background: Color(0xFFF2F5FF),
        foreground: Color(0xFFC2CCFF),
      ),
    ),
    toggleButton: ButtonColor(
      regular: ButtonColorVariation(
        border: Color(0xFF3A3A88),
        background: Color(0xFFF2F5FF),
        foreground: Color(0xFF3A3A88),
      ),
      clicked: ButtonColorVariation(
        border: Color(0xFF3A3A88),
        background: Color(0xFF3A3A88),
        foreground: Color(0xFFF2F5FF),
      ),
    ),
  ),
  ConvertouchUITheme.dark: RefreshingJobItemColor(
    activeStatusLabel: Color(0xFF4EAD51),
    notActiveStatusLabel: Color(0xFFB1B5EA),
    jobItem: ConvertouchListItemColor(
      regular: ListItemColorVariation(
        border: Color(0xFF585A6C),
        background: Color(0xFF3E4754),
        content: Color(0xFFB1B5EA),
      ),
      selected: ListItemColorVariation(
        border: Color(0xFFA5B2FF),
        background: Color(0xFF3E4754),
        content: Color(0xFFB3B6DE),
      ),
    ),
    refreshButton: ButtonColor(
      regular: ButtonColorVariation(
        border: Color(0xFF585A6C),
        background: Color(0xFF3E4754),
        foreground: Color(0xFFB1B5EA),
      ),
      inactive: ButtonColorVariation(
        border: Color(0xFF585A6C),
        background: Color(0xFF3E4754),
        foreground: Color(0xFF7E82B4),
      ),
    ),
    toggleButton: ButtonColor(
      regular: ButtonColorVariation(
        border: Color(0xFF585A6C),
        background: Color(0xFF3E4754),
        foreground: Color(0xFFB1B5EA),
      ),
      clicked: ButtonColorVariation(
        border: Color(0xFFB1B5EA),
        background: Color(0xFFB1B5EA),
        foreground: Color(0xFF3E4754),
      ),
    ),
  ),
};

const unitGroupsPageFloatingButtonColors = {
  ConvertouchUITheme.light: ButtonColorVariation(
    background: Color(0xFF7473FA),
    foreground: Color(0xFFDEE9FF),
  ),
  ConvertouchUITheme.dark: ButtonColorVariation(
    background: Color(0xFF616491),
    foreground: Color(0xFFD1CFD3),
  ),
};

const unitsPageFloatingButtonColors = {
  ConvertouchUITheme.light: ButtonColorVariation(
    background: Color(0xFF5499DA),
    foreground: Color(0xFFDEE9FF),
  ),
  ConvertouchUITheme.dark: ButtonColorVariation(
    background: Color(0xDB446F96),
    foreground: Color(0xFFD1CFD3),
  ),
};

const conversionPageFloatingButtonColors = {
  ConvertouchUITheme.light: ButtonColorVariation(
    background: Color(0xFF6793BE),
    foreground: Color(0xFFF5F7FF),
  ),
  ConvertouchUITheme.dark: ButtonColorVariation(
    background: Color(0xDB446F96),
    foreground: Color(0xFFD1CFD3),
  ),
};

const removalFloatingButtonColors = {
  ConvertouchUITheme.light: ButtonColorVariation(
    background: Color(0xFFD36422),
    foreground: Color(0xFFDEE9FF),
  ),
  ConvertouchUITheme.dark: ButtonColorVariation(
    background: Color(0xFF9D5225),
    foreground: Color(0xFFDEE9FF),
  ),
};

const dividerWithTextColors = {
  ConvertouchUITheme.light: Color(0xFF709FCB),
  ConvertouchUITheme.dark: Color(0xFF709FCB),
};

const textBoxColors = {
  ConvertouchUITheme.light: ConvertouchTextBoxColor(
    regular: TextBoxColorVariation(
      border: Color(0xFF426F99),
      content: Color(0xFF426F99),
      label: Color(0xFF426F99),
      hint: Color(0xFF426F99),
    ),
    focused: TextBoxColorVariation(
      border: Color(0xFF426F99),
      content: Color(0xFF426F99),
      label: Color(0xFF426F99),
      hint: Color(0xFF426F99),
    ),
  ),
  ConvertouchUITheme.dark: ConvertouchTextBoxColor(
    regular: TextBoxColorVariation(
      border: Color(0xFF709FCB),
      content: Color(0xFF709FCB),
      label: Color(0xFF709FCB),
      hint: Color(0xFF709FCB),
    ),
    focused: TextBoxColorVariation(
      border: Color(0xFF709FCB),
      content: Color(0xFF709FCB),
      label: Color(0xFF709FCB),
      hint: Color(0xFF709FCB),
    ),
  ),
};

const unitGroupTextBoxColors = {
  ConvertouchUITheme.light: ConvertouchTextBoxColor(
    regular: TextBoxColorVariation(
      border: Color(0xFF5F4299),
      content: Color(0xFF5F4299),
      label: Color(0xFF5F4299),
    ),
    focused: TextBoxColorVariation(
      border: Color(0xFF5F4299),
      content: Color(0xFF5F4299),
      label: Color(0xFF5F4299),
    ),
  ),
  ConvertouchUITheme.dark: ConvertouchTextBoxColor(
    regular: TextBoxColorVariation(
      border: Color(0xFFA1A4CE),
      content: Color(0xFFA1A4CE),
      label: Color(0xFFA1A4CE),
    ),
    focused: TextBoxColorVariation(
      border: Color(0xFFC1C3E5),
      content: Color(0xFFC1C3E5),
      label: Color(0xFFC1C3E5),
    ),
  ),
};
