import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/color_variation.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';

const pageColorSchemeLight = PageColorScheme(
  appBar: ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xff7f9dec)),
    foreground: ColorVariation.only(Color(0xFF1D5180)),
  ),
  page: ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xffe8efff)),
    foreground: ColorVariation.only(Color(0xFF426F99)),
  ),
  snackBar: SnackBarColorScheme(
    background: ColorVariation.only(Color(0xFF384867)),
    foregroundError: ColorVariation.only(Color(0xFFFFAAAA)),
    foregroundWarning: ColorVariation.only(Color(0xFFEADFB8)),
    foregroundInfo: ColorVariation.only(Color(0xFFA3D4FF)),
    action: ColorVariation.only(Color(0xFFB6D5F6)),
  ),
  bottomBar: ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xff7f9dec)),
    foreground: ColorVariation(
      regular: Color(0xFF1D5180),
      selected: Color(0xFF1C3750),
      disabled: Color(0xFFA0C4F5),
    ),
  ),
);

const searchBarColorSchemeLight = SearchBarColorScheme(
  textBox: InputBoxColorScheme(
    background: ColorVariation.only(Color(0xFFF6F9FF)),
    foreground: ColorVariation.only(Color(0xFF426F99)),
    hint: ColorVariation.only(Color(0xFF5C93C7)),
  ),
  viewModeButton: ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xffc1d7ff)),
    foreground: ColorVariation.only(Color(0xFF4D79A1)),
  ),
);

const paramSetColorSchemeLight = ParamSetPanelColorScheme(
  tab: ConvertouchColorScheme(
    background: ColorVariation(
      regular: Color(0xffc8d9ff),
    ),
    foreground: ColorVariation(
      regular: Color(0xFF2D6698),
    ),
  ),
  toolset: ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xffbcceff)),
    foreground: ColorVariation(
        regular: Color(0xFF235475),
      disabled: Color(0xFF7497B7),
    ),
  ),
  removalIcon: ColorVariation.only(Color(0xFFC44D22)),
  footer: ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xffabbff3)),
    foreground: ColorVariation.only(Color(0xFF6C9CC9)),
  ),
);

const unitBottomLoaderLight = ListItemColorScheme(
  background: ColorVariation.only(Color(0xFFC7DDFA)),
  foreground: ColorVariation.only(Color(0xFF2C6396)),
);

const unitGroupBottomLoaderLight = ListItemColorScheme(
  background: ColorVariation.only(Color(0xffccd9f8)),
  foreground: ColorVariation.only(Color(0xFF303073)),
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
  titleBackground: ColorVariation(
    regular: Color(0xffb8caf6),
    selected: Color(0xffaabce8),
  ),
  matchBackground: ColorVariation.only(Color(0xff9aafe0)),
  matchForeground: ColorVariation.only(Color(0xFF1E1E3D)),
  foreground: ColorVariation(
    regular: Color(0xFF303073),
    selected: Color(0xFF303073),
  ),
  divider: ColorVariation(
    regular: Color(0xFF353D69),
    selected: Color(0xFF303073),
  ),
  checkBox: ConvertouchColorScheme(
    border: ColorVariation(
      regular: Color(0xFF303073),
    ),
    background: ColorVariation(
      regular: Color(0xffe8efff),
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

const unitItemColorSchemeLight = ListItemColorScheme(
  border: ColorVariation(
    regular: Color(0xFFAAC9F1),
    disabled: Color(0xAEB1CFF5),
  ),
  background: ColorVariation(
    regular: Color(0xFFAAC9F1),
    disabled: Color(0x9EBFD8FA),
  ),
  titleBackground: ColorVariation(
    regular: Color(0xFF99C1EF),
    disabled: Color(0x9EB1CBEF),
  ),
  matchBackground: ColorVariation.only(Color(0xFF4E79B2)),
  matchForeground: ColorVariation.only(Color(0xFF264E72)),
  foreground: ColorVariation(
    regular: Color(0xFF2C6396),
    disabled: Color(0xB25086BB),
  ),
  divider: ColorVariation(
    regular: Color(0xFF2C6396),
    disabled: Color(0xB2366C9F),
  ),
  checkBox: ConvertouchColorScheme(
    border: ColorVariation(
      regular: Color(0xFF467CAD),
    ),
    background: ColorVariation(
      regular: Color(0xffe8efff),
      selected: Color(0xFF467CAD),
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
  background: ColorVariation.only(Color(0xFFE6DFF6)),
  foreground: ColorVariation.only(Color(0xFF45459A)),
);

const unitPageEmptyViewColorLight = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xFFD4E5FC)),
  foreground: ColorVariation.only(Color(0xFF3B6083)),
);

const unitTextBoxColorLight = InputBoxColorScheme(
  border: ColorVariation(
    regular: Color(0xFF4F7498),
    focused: Color(0xFF233B50),
    disabled: Color(0xFF90A8C0),
  ),
  foreground: ColorVariation(
    regular: Color(0xBE143656),
    disabled: Color(0xFF90A8C0),
  ),
  hint: ColorVariation(
    regular: Color(0xFF799BBB),
    disabled: Color(0xBE73ACE5),
  ),
  dropdown: ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xff9eb7f3)),
    foreground: ColorVariation.only(Color(0xFF134470)),
  ),
);

const unitGroupTextBoxColorLight = InputBoxColorScheme(
  border: ColorVariation(
    regular: Color(0xFF6766D3),
    disabled: Color(0xFF6160BE),
  ),
  foreground: ColorVariation(
    regular: Color(0xFF4544AB),
    disabled: Color(0xFF414194),
  ),
  hint: ColorVariation(
    regular: Color(0xFF7574E1),
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
    background: ColorVariation.only(Color(0xffccdeff)),
    foreground: ColorVariation.only(Color(0xFF4D657C)),
  ),
);

const unitGroupsPageFloatingButtonColorSchemeLight = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xFF6A69D5)),
  foreground: ColorVariation.only(Color(0xFFDEE9FF)),
);

const unitsPageFloatingButtonColorSchemeLight = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xFF5189BE)),
  foreground: ColorVariation.only(Color(0xFFDEE9FF)),
);

const conversionPageFloatingButtonColorSchemeLight = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xFF5980A6)),
  foreground: ColorVariation.only(Color(0xFFF5F7FF)),
);

const refreshButtonColorSchemeLight = ConvertouchColorScheme(
  border: ColorVariation(
    regular: Color(0xFF2095B7),
  ),
  foreground: ColorVariation(
    regular: Color(0xFFE8E8FF),
    selected: Color(0xFF2095B7),
  ),
  background: ColorVariation.only(Color(0xFF2095B7)),
);

const removalFloatingButtonColorLight = ConvertouchColorScheme(
  border: ColorVariation.only(Color(0xFFFCFEFF)),
  background: ColorVariation.only(Color(0xFFD36422)),
  foreground: ColorVariation.only(Color(0xFFDEE9FF)),
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
