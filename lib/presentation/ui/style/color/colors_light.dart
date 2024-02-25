import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/color_variation.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';

const pageColorSchemeLight = PageColorScheme(
  appBar: ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xffb0cbef)),
    foreground: ColorVariation(
      regular: Color(0xFF3B5B7A),
    ),
  ),
  page: ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xffe7f2ff)),
    foreground: ColorVariation.only(Color(0xFF426F99)),
  ),
  snackBar: SnackBarColorScheme(
    background: ColorVariation.only(Color(0xFF426F99)),
    foregroundError: ColorVariation.only(Color(0xFFFFAAAA)),
    foregroundWarning: ColorVariation.only(Color(0xFFF1FFB0)),
    foregroundInfo: ColorVariation.only(Color(0xFFF2F8FF)),
  ),
  bottomBar: ConvertouchColorScheme(
    background: ColorVariation(
      regular: Color(0xffb0cbef),
      disabled: Color(0xffa4c0e5),
      selected: Color(0xFFDEE9FF),
    ),
    foreground: ColorVariation(
      regular: Color(0xFF426F99),
      disabled: Color(0xFFA0C4F5),
    ),
  ),
);

const searchBarColorSchemeLight = SearchBarColorScheme(
  textBox: TextBoxColorScheme(
    background: ColorVariation.only(Color(0xFFF6F9FF)),
    foreground: ColorVariation.only(Color(0xFF426F99)),
    hint: ColorVariation.only(Color(0xFF5C93C7)),
  ),
  viewModeButton: ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xFFF6F9FF)),
    foreground: ColorVariation.only(Color(0xFF426F99)),
  ),
);

const unitGroupItemColorSchemeLight = ConvertouchColorScheme(
  border: ColorVariation(
    regular: Color(0xFFC2CCFF),
    selected: Color(0xFF9EADFA),
  ),
  background: ColorVariation(
    regular: Color(0xFFF2F5FF),
    selected: Color(0xFFE5EAFF),
  ),
  foreground: ColorVariation(
    regular: Color(0xFF3A3A88),
    selected: Color(0xFF303073),
  ),
);

const unitGroupItemInAppBarColorSchemeLight = ConvertouchColorScheme(
  border: ColorVariation.only(Color(0xffabbeee)),
  background: ColorVariation.only(Color(0xffd1dfff)),
  foreground: ColorVariation.only(Color(0xFF353D69)),
);

const unitGroupPageInfoBoxColorLight = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xFFF1EBFF))
);

const unitItemColorSchemeLight = ConvertouchColorScheme(
  border: ColorVariation(
    regular: Color(0xFFB5DBFF),
    marked: Color(0xFF509CE0),
    selected: Color(0xFF2F7DC2),
    disabled: Color(0xFFCCE5FF),
  ),
  background: ColorVariation(
    regular: Color(0xFFDFEDFF),
    marked: Color(0xFFCCE1FF),
    selected: Color(0xFFCCE1FF),
    disabled: Color(0xFFE9F2FF),
  ),
  foreground: ColorVariation(
    regular: Color(0xFF366C9F),
    marked: Color(0xFF366C9F),
    selected: Color(0xFF366C9F),
    disabled: Color(0xFF83B5E5),
  ),
);

const unitPageInfoBoxColorLight = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xFFDFEAFF))
);

const textBoxColorLight = TextBoxColorScheme(
  border: ColorVariation(
    regular: Color(0xFF7FA0BE),
    focused: Color(0xFF375067),
  ),
  foreground: ColorVariation(
    regular: Color(0xFF426F99),
    focused: Color(0xFF426F99),
  ),
  hint: ColorVariation(
    regular: Color(0xFF85A9CB),
  ),
);

const conversionItemColorSchemeLight = ConversionItemColorScheme(
  textBox: textBoxColorLight,
  background: ColorVariation.only(Color(0xffe7f2ff)),
  unitButton: ConvertouchColorScheme(
    border: ColorVariation(
      regular: Color(0xFF9FC3E3),
      focused: Color(0xFF375067),
    ),
    background: ColorVariation(
      regular: Color(0xFFB3D2EE),
    ),
    foreground: ColorVariation(
      regular: Color(0xFF2D4B67),
    ),
  ),
  handler: ConvertouchColorScheme(
    foreground: ColorVariation.only(Color(0xFF7FA0BE)),
  ),
);

const unitGroupsPageFloatingButtonColorSchemeLight = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xFF7473FA)),
  foreground: ColorVariation.only(Color(0xFFDEE9FF)),
);

const unitsPageFloatingButtonColorSchemeLight = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xFF5499DA)),
  foreground: ColorVariation.only(Color(0xFFDEE9FF)),
);

const conversionPageFloatingButtonColorSchemeLight = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xFF6793BE)),
  foreground: ColorVariation.only(Color(0xFFF5F7FF)),
);

const refreshButtonColorSchemeLight = ConvertouchColorScheme(
  border: ColorVariation(
    regular: Color(0xFF484898),
    disabled: Color(0xFFC2CCFF),
  ),
  foreground: ColorVariation(
    regular: Color(0xFF484898),
    disabled: Color(0xFFC2CCFF),
  ),
  background: ColorVariation.only(Color(0xFFC9C9F8)),
);

const removalFloatingButtonColorLight = ConvertouchColorScheme(
  border: ColorVariation.only(Color(0xFFFCFEFF)),
  background: ColorVariation.only(Color(0xFFD36422)),
  foreground: ColorVariation.only(Color(0xFFDEE9FF)),
);

const unitGroupTextBoxColorLight = TextBoxColorScheme(
  border: ColorVariation(
    regular: Color(0xFF5F4299),
    disabled: Color(0xFFB9A3E7),
  ),
  foreground: ColorVariation(
    regular: Color(0xFF5F4299),
    disabled: Color(0xFFB9A3E7),
  ),
  hint: ColorVariation(
    regular: Color(0xFFC4B0EF),
    disabled: Color(0xFFB9A3E7),
  ),
);

const settingItemColorLight = SettingItemColorScheme(
  background: ColorVariation(
    regular: Color(0xFFE5ECFF),
    selected: Color(0xFFE5ECFF),
    disabled: Color(0xFFE5ECFF),
  ),
  foreground: ColorVariation(
    regular: Color(0xFF426F99),
    selected: Color(0xFF426F99),
    disabled: Color(0xFF6F9ECB),
  ),
  divider: ColorVariation.only(Color(0xFFB6CAFF)),
  switcher: SwitcherColorScheme(
    track: ConvertouchColorScheme(
      border: ColorVariation(
        regular: Color(0xFF426F99),
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

const progressIndicatorColorLight = ConvertouchColorScheme(
  foreground: ColorVariation.only(Color(0xFF3A3A88)),
);
