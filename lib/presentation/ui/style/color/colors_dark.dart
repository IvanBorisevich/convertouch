import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/color_variation.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';

const pageColorSchemeDark = PageColorScheme(
  appBar: ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xFF2C323D)),
    foreground: ColorVariation(
      regular: Color(0xFFCCD7E0),
      disabled: Color(0xFF8D8D8D),
    ),
  ),
  page: ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xFF373F4B)),
    foreground: ColorVariation.only(Color(0xFFCCD7E0)),
  ),
  snackBar: SnackBarColorScheme(
    background: ColorVariation.only(Color(0xFF535E6E)),
    foregroundError: ColorVariation.only(Color(0xFFFFAAAA)),
    foregroundWarning: ColorVariation.only(Color(0xFFF1FFB0)),
    foregroundInfo: ColorVariation.only(Color(0xFFF2F8FF)),
  ),
  bottomBar: ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xFF2C323D)),
    foreground: ColorVariation(
      regular: Color(0xFFCCD7E0),
      disabled: Color(0xFF8D8D8D),
      selected: Color(0xFFC0DCF3),
    ),
  ),
);

const searchBarColorSchemeDark = SearchBarColorScheme(
  textBox: TextBoxColorScheme(
    background: ColorVariation.only(Color(0xFF444C59)),
    foreground: ColorVariation.only(Color(0xFFCCD7E0)),
    hint: ColorVariation.only(Color(0xFF8791A1)),
  ),
  viewModeButton: ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xFF444C59)),
    foreground: ColorVariation.only(Color(0xFFCCD7E0)),
  ),
);

const unitGroupItemColorSchemeDark = ConvertouchColorScheme(
  border: ColorVariation(
    regular: Color(0xFF585A6C),
    selected: Color(0xFFA5B2FF),
  ),
  background: ColorVariation(
    regular: Color(0xFF3E4754),
    selected: Color(0xFF3E4754),
  ),
  foreground: ColorVariation(
    regular: Color(0xFFB1B5EA),
    selected: Color(0xFFB3B6DE),
  ),
);

const unitGroupItemInAppBarColorSchemeDark = ConvertouchColorScheme(
  border: ColorVariation.only(Color(0xFF60647E)),
  background: ColorVariation.only(Color(0xFF585A6C)),
  foreground: ColorVariation.only(Color(0xFFA1A4CE)),
);

const unitGroupPageInfoBoxColorDark = ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xFFF1EBFF))
);

const unitItemColorSchemeDark = ConvertouchColorScheme(
  border: ColorVariation(
    regular: Color(0xFF54616C),
    marked: Color(0xFF7A9EBE),
    selected: Color(0xFF7A9EBE),
    disabled: Color(0xFF6A7885),
  ),
  background: ColorVariation(
    regular: Color(0xFF3E4754),
    marked: Color(0xE4415F7E),
    selected: Color(0xE4415F7E),
    disabled: Color(0xFF545E6E),
  ),
  foreground: ColorVariation(
    regular: Color(0xFF7DAAD3),
    marked: Color(0xFFA0CAF1),
    selected: Color(0xFFA0CAF1),
    disabled: Color(0xFF8DBAE3),
  ),
);

const unitPageInfoBoxColorDark = ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xFFDFEAFF))
);

const textBoxColorDark = TextBoxColorScheme(
  border: ColorVariation(
    regular: Color(0xFF7FA0BE),
    focused: Color(0xFF98BAD9),
  ),
  foreground: ColorVariation(
    regular: Color(0xFF8FB1D0),
    focused: Color(0xFFA0C4E5),
  ),
  hint: ColorVariation(
    regular: Color(0xFFA8C9E7),
    focused: Color(0xFFA8C9E7),
  ),
);

const conversionItemColorSchemeDark = ConversionItemColorScheme(
  textBox: textBoxColorDark,
  background: ColorVariation.only(Color(0xFF373F4B)),
  unitButton: ConvertouchColorScheme(
    border: ColorVariation(
      regular: Color(0xFF7FA0BE),
      focused: Color(0xFF8FB1D0),
    ),
    background: ColorVariation(
      regular: Color(0xFF373F4B),
      focused: Color(0xDF49597A),
    ),
    foreground: ColorVariation(
      regular: Color(0xFF7FA0BE),
      focused: Color(0xFF8FB1D0),
    ),
  ),
  handler: ConvertouchColorScheme(
    foreground: ColorVariation.only(Color(0xFF7FA0BE)),
  ),
);

const unitGroupsPageFloatingButtonColorSchemeDark = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xFF616491)),
  foreground: ColorVariation.only(Color(0xFFD1CFD3)),
);

const unitsPageFloatingButtonColorSchemeDark = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xDB446F96)),
  foreground: ColorVariation.only(Color(0xFFD1CFD3)),
);

const conversionPageFloatingButtonColorSchemeDark = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xDB446F96)),
  foreground: ColorVariation.only(Color(0xFFD1CFD3)),
);

const refreshButtonColorSchemeDark = ConvertouchColorScheme(
  border: ColorVariation(
    regular: Color(0xFF585A6C),
  ),
  foreground: ColorVariation(
    regular: Color(0xFFBFC3F6),
    disabled: Color(0xFF7E82B4),
  ),
  background: ColorVariation.only(Color(0xFFC9C9F8)),
);

const removalFloatingButtonColorDark = ConvertouchColorScheme(
  border: ColorVariation.only(Color(0xFF373F4B)),
  background: ColorVariation.only(Color(0xFF9D5225)),
  foreground: ColorVariation.only(Color(0xFFDEE9FF)),
);

const unitGroupTextBoxColorDark = TextBoxColorScheme(
  border: ColorVariation(
    regular: Color(0xFFA1A4CE),
    disabled: Color(0xFFC3C5E3),
  ),
  foreground: ColorVariation(
    regular: Color(0xFFA1A4CE),
    disabled: Color(0xFFC3C5E3),
  ),
  hint: ColorVariation(
    regular: Color(0xFFC3C5E3),
    disabled: Color(0xFFC3C5E3),
  ),
);

const settingItemColorDark = SettingItemColorScheme(
  background: ColorVariation(
    regular: Color(0xFF3A4E60),
    selected: Color(0xFF506394),
    disabled: Color(0xFF506394),
  ),
  foreground: ColorVariation(
    regular: Color(0xFFB1D2F1),
    selected: Color(0xFF88A3BD),
    disabled: Color(0xFF6F9ECB),
  ),
  divider: ColorVariation.only(Color(0xFF4D5D83)),
  switcher: SwitcherColorScheme(
    track: ConvertouchColorScheme(
      border: ColorVariation(
        regular: Color(0xFF88A3BD),
        selected: Color(0xFF7FA1C0),
        disabled: Color(0xFF94B4D2),
      ),
      background: ColorVariation(
        regular: noColor,
        selected: Color(0xFF7FA1C0),
        disabled: Color(0xFF94B4D2),
      ),
    ),
  ),
);

const progressIndicatorColorDark = ConvertouchColorScheme(
  foreground: ColorVariation.only(Color(0xFF7272C9)),
);
