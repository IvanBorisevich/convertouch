import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/color_variation.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';

const pageColorSchemeLight = PageColorScheme(
  appBar: ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xff9bb4ec)),
    foreground: ColorVariation(
      regular: Color(0xFF3B5B7A),
    ),
  ),
  page: ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xffe8efff)),
    foreground: ColorVariation.only(Color(0xFF426F99)),
  ),
  snackBar: SnackBarColorScheme(
    background: ColorVariation.only(Color(0xFF467FB2)),
    foregroundError: ColorVariation.only(Color(0xFFFFAAAA)),
    foregroundWarning: ColorVariation.only(Color(0xFFF1FFB0)),
    foregroundInfo: ColorVariation.only(Color(0xFFF2F8FF)),
  ),
  bottomBar: ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xffa7c2ff)),
    foreground: ColorVariation(
      regular: Color(0xFF38638A),
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

const unitGroupItemColorSchemeLight = ListItemColorScheme(
  border: ColorVariation(
    regular: Color(0xffc6d7fd),
    selected: Color(0xFF535D91),
  ),
  background: ColorVariation(
    regular: Color(0xffc6d7fd),
    selected: Color(0xff9db3ea),
  ),
  foreground: ColorVariation(
    regular: Color(0xFF303073),
    selected: Color(0xFF303073),
  ),
  divider: ColorVariation(
    regular: Color(0xFF353D69),
    selected: Color(0xFF303073),
  ),
  removalIcon: ConvertouchColorScheme(
    border: ColorVariation(
      regular: Color(0xFF303073),
    ),
    background: ColorVariation(
      regular: noColor,
      selected: Color(0xFF303073),
    ),
    foreground: ColorVariation(
      regular: noColor,
      selected: Colors.white,
    ),
  ),
  modeIcon: ConvertouchColorScheme(
    border: ColorVariation(
      regular: Color(0xffaebfe7),
    ),
    background: ColorVariation(
      regular: Color(0xffaebfe7),
    ),
    foreground: ColorVariation(
      regular: Color(0xFF303073),
    ),
  ),
);

const unitGroupItemInAppBarColorSchemeLight = ListItemColorScheme(
  border: ColorVariation.only(Color(0xffc4d6ff)),
  background: ColorVariation.only(Color(0xffc4d6ff)),
  foreground: ColorVariation.only(Color(0xFF353D69)),
  divider: ColorVariation.only(Color(0xFF353D69)),
);

const unitItemColorSchemeLight = ListItemColorScheme(
  border: ColorVariation(
    regular: Color(0xFFAAC9F1),
    marked: Color(0xE57AB2F8),
    selected: Color(0xFF26537E),
    disabled: Color(0xAEB1CFF5),
  ),
  background: ColorVariation(
    regular: Color(0xFFAAC9F1),
    marked: Color(0xE57AB2F8),
    selected: Color(0xE57AB2F8),
    disabled: Color(0x9EAAC9F1),
  ),
  foreground: ColorVariation(
    regular: Color(0xFF2C6396),
    marked: Color(0xFF1E4770),
    selected: Color(0xFF26537E),
    disabled: Color(0xB2366C9F),
  ),
  divider: ColorVariation(
    regular: Color(0xFF2C6396),
    marked: Color(0xFF26537E),
    selected: Color(0xFF26537E),
    disabled: Color(0xB2366C9F),
  ),
  removalIcon: ConvertouchColorScheme(
    border: ColorVariation(
      regular: Color(0xFF2C6396),
    ),
    background: ColorVariation(
      regular: noColor,
      selected: Color(0xFF2C6396),
    ),
    foreground: ColorVariation(
      regular: noColor,
      selected: Colors.white,
    ),
  ),
  modeIcon: ConvertouchColorScheme(
    border: ColorVariation(
      regular: Color(0xFF96B5DC),
    ),
    background: ColorVariation(
      regular: Color(0xFF96B5DC),
    ),
    foreground: ColorVariation(
      regular: Color(0xFF2C6396),
    ),
  ),
);

const unitGroupPageInfoBoxColorLight = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xFFE1D8F5)),
);

const unitPageInfoBoxColorLight = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xFFBCD6FF)),
);

const unitGroupPageEmptyViewColorLight = ConvertouchColorScheme(
  foreground: ColorVariation.only(Color(0xFF45459A)),
);

const unitPageEmptyViewColorLight = ConvertouchColorScheme(
  foreground: ColorVariation.only(Color(0xFF3B6083)),
);

const unitTextBoxColorLight = TextBoxColorScheme(
  border: ColorVariation(
    regular: Color(0xFF5E7993),
    focused: Color(0xFF375067),
  ),
  foreground: ColorVariation(
    regular: Color(0xFF345C81),
  ),
  hint: ColorVariation(
    regular: Color(0xBE345C81),
  ),
);

const conversionItemColorSchemeLight = ConversionItemColorScheme(
  textBox: unitTextBoxColorLight,
  background: ColorVariation.only(Color(0xffe7f2ff)),
  unitButton: ConvertouchColorScheme(
    border: ColorVariation(
      regular: Color(0xFFAAC9F1),
      focused: Color(0xFF375067),
    ),
    background: ColorVariation(
      regular: Color(0xFFAAC9F1),
    ),
    foreground: ColorVariation(
      regular: Color(0xFF2C6396),
    ),
  ),
  handler: ConvertouchColorScheme(
    foreground: ColorVariation.only(Color(0xFF5E7993)),
  ),
);

const unitGroupsPageFloatingButtonColorSchemeLight = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xCF6A69D5)),
  foreground: ColorVariation.only(Color(0xFFDEE9FF)),
);

const unitsPageFloatingButtonColorSchemeLight = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xD25189BE)),
  foreground: ColorVariation.only(Color(0xFFDEE9FF)),
);

const conversionPageFloatingButtonColorSchemeLight = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xC55980A6)),
  foreground: ColorVariation.only(Color(0xFFF5F7FF)),
);

const refreshButtonColorSchemeLight = ConvertouchColorScheme(
  border: ColorVariation(
    regular: Color(0xC82095B7),
  ),
  foreground: ColorVariation(
    regular: Color(0xFFE8E8FF),
    selected: Color(0xC82095B7),
  ),
  background: ColorVariation.only(Color(0xC82095B7)),
);

const removalFloatingButtonColorLight = ConvertouchColorScheme(
  border: ColorVariation.only(Color(0xFFFCFEFF)),
  background: ColorVariation.only(Color(0xFFD36422)),
  foreground: ColorVariation.only(Color(0xFFDEE9FF)),
);

const unitGroupTextBoxColorLight = TextBoxColorScheme(
  border: ColorVariation(
    regular: Color(0xFF5F4299),
    disabled: Color(0xB561449B),
  ),
  foreground: ColorVariation(
    regular: Color(0xFF5F4299),
    disabled: Color(0xB561449B),
  ),
  hint: ColorVariation(
    regular: Color(0xB561449B),
  ),
);

const settingItemColorLight = SettingItemColorScheme(
  border: ColorVariation.only(Color(0xFFB1BFE1)),
  background: ColorVariation(
    regular: Color(0xFFD5E2FF),
    selected: Color(0xFFE5ECFF),
    disabled: Color(0xFFE5ECFF),
  ),
  foreground: ColorVariation(
    regular: Color(0xFF426F99),
    selected: Color(0xFF426F99),
    disabled: Color(0xFF6F9ECB),
  ),
  divider: ColorVariation.only(Color(0xFFB1BFE1)),
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

const alertDialogColorLight = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xFFD5E2FF)),
  foreground: ColorVariation.only(Color(0xFF426F99)),
);

const errorInfoBoxColorLight = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xFFBCD6FF)),
  foreground: ColorVariation.only(Color(0xFF426F99)),
);
