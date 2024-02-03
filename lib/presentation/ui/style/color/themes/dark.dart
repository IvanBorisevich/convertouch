import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/color_set.dart';
import 'package:convertouch/presentation/ui/style/color/color_state_variation.dart';
import 'package:flutter/material.dart';

const pageColorSchemeDark = PageColorScheme(
  appBar: ColorStateVariation(
    regular: AppBarColorSet(
      background: Color(0xFF2C323D),
      foreground: Color(0xFFCCD7E0),
    ),
    disabled: AppBarColorSet(
      background: Color(0xFF2C323D),
      foreground: Color(0xFF8D8D8D),
    ),
  ),
  page: BaseColorSet(
    background: Color(0xFF373F4B),
    foreground: Color(0xFFCCD7E0),
  ),
  snackBar: BaseColorSet(
    background: Color(0xFF535E6E),
    foreground: Color(0xFFE1E5E7),
  ),
  bottomBar: ColorStateVariation(
    regular: AppBarColorSet(
      background: Color(0xFF2C323D),
      foreground: Color(0xFFCCD7E0),
    ),
    disabled: AppBarColorSet(
      background: Color(0xFF2C323D),
      foreground: Color(0xFF8D8D8D),
    ),
    selected: AppBarColorSet(
      background: Color(0xFF2C323D),
      foreground: Color(0xFFC0DCF3),
    ),
  ),
);

const searchBarColorSchemeDark = SearchBarColorScheme(
  searchBox: TextBoxColorSet(
    background: Color(0xFF444C59),
    foreground: Color(0xFFCCD7E0),
    hint: Color(0xFF8791A1),
  ),
  viewModeButton: ButtonColorSet(
    background: Color(0xFF444C59),
    foreground: Color(0xFFCCD7E0),
  ),
);

const unitGroupItemColorSchemeDark = ColorStateVariation(
  regular: BaseColorSet(
    border: Color(0xFF585A6C),
    background: Color(0xFF3E4754),
    foreground: Color(0xFFB1B5EA),
  ),
  selected: BaseColorSet(
    border: Color(0xFFA5B2FF),
    background: Color(0xFF3E4754),
    foreground: Color(0xFFB3B6DE),
  ),
);

const unitGroupItemInAppBarColorSchemeDark = ColorStateVariation(
  regular: BaseColorSet(
    border: Color(0xFF60647E),
    foreground: Color(0xFFA1A4CE),
  ),
);

const unitItemColorSchemeDark = ColorStateVariation(
  regular: BaseColorSet(
    border: Color(0xFF54616C),
    background: Color(0xFF3E4754),
    foreground: Color(0xFF7DAAD3),
  ),
  marked: BaseColorSet(
    border: Color(0xFF7A9EBE),
    background: Color(0xE4415F7E),
    foreground: Color(0xFFA0CAF1),
  ),
  selected: BaseColorSet(
    border: Color(0xFF7A9EBE),
    background: Color(0xE4415F7E),
    foreground: Color(0xFFA0CAF1),
  ),
);

const conversionItemColorSchemeDark = ConversionItemColorScheme(
  textBox: ColorStateVariation(
    regular: TextBoxColorSet(
      border: Color(0xFF7FA0BE),
      foreground: Color(0xFF8FB1D0),
      label: Color(0xFF7FA0BE),
    ),
    focused: TextBoxColorSet(
      border: Color(0xFF98BAD9),
      foreground: Color(0xFFA0C4E5),
      label: Color(0xFF98BAD9),
    ),
  ),
  unitButton: ColorStateVariation(
    regular: BaseColorSet(
      border: Color(0xFF7FA0BE),
      background: Color(0xFF373F4B),
      foreground: Color(0xFF7FA0BE),
    ),
    focused: BaseColorSet(
      border: Color(0xFF8FB1D0),
      background: Color(0xDF49597A),
      foreground: Color(0xFF8FB1D0),
    ),
  ),
  handler: Color(0xFF7FA0BE),
);
