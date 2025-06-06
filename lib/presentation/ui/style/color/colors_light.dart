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
      regular: Color(0xffdae5ff),
    ),
    foreground: ColorVariation(
      regular: Color(0xFF2D6698),
    ),
  ),
  toolset: ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xffc6d6ff)),
    foreground: ColorVariation(
      regular: Color(0xFF235475),
      disabled: Color(0xFF97B0C7),
    ),
  ),
  removalIcon: ColorVariation.only(Color(0xFFB6441C)),
  footer: ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xffabbff3)),
    foreground: ColorVariation.only(Color(0xFF6C9CC9)),
  ),
  paramItem: ConversionItemColorScheme(
    textBox: InputBoxColorScheme(
      border: ColorVariation(
        regular: Color(0xFF5680A2),
        focused: Color(0xFF3A6588),
      ),
      foreground: ColorVariation(
        regular: Color(0xFF456885),
      ),
      hint: ColorVariation(
        regular: Color(0xFF7DA4C4),
      ),
      dropdown: ConvertouchColorScheme(
        background: ColorVariation.only(Color(0xffabc4fd)),
        foreground: ColorVariation.only(Color(0xFF1D578C)),
      ),
    ),
    background: ColorVariation.only(Color(0xffdae5ff)),
    unitButton: ConvertouchColorScheme(
      border: ColorVariation(
        regular: Color(0xFFA2C0F3),
        focused: Color(0xFF375067),
      ),
      background: ColorVariation(
        regular: Color(0xFFA2C0F3),
      ),
      foreground: ColorVariation(
        regular: Color(0xFF224F79),
      ),
    ),
    handler: ConvertouchColorScheme(
      border: ColorVariation(
        regular: Color(0xff82a7ec),
        selected: Colors.transparent,
      ),
      background: ColorVariation(
        regular: Colors.transparent,
        selected: Color(0xffa1c2ff),
      ),
      foreground: ColorVariation(
        regular: Color(0xff82a7ec),
        selected: Color(0xFF304860),
      ),
    ),
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
  matchBackground: ColorVariation.only(Color(0xFF80ADE7)),
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
  foreground: ColorVariation.only(Color(0xFF45459A)),
);

const unitPageEmptyViewColorLight = ConvertouchColorScheme(
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
  textBox: InputBoxColorScheme(
    background: ColorVariation.only(Color(0xffe8efff)),
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
      background: ColorVariation.only(Color(0xffabc4fd)),
      foreground: ColorVariation.only(Color(0xFF1D578C)),
    ),
  ),
  background: ColorVariation.only(Color(0xffe7f2ff)),
  unitButton: ConvertouchColorScheme(
    border: ColorVariation(
      regular: Color(0xFFAAC9F1),
      selected: Color(0xFF90B5E5),
    ),
    background: ColorVariation(
      regular: Color(0xFFAAC9F1),
      selected: Color(0xFF90B5E5),
    ),
    foreground: ColorVariation(
      regular: Color(0xFF2C6396),
    ),
  ),
  handler: ConvertouchColorScheme(
    background: ColorVariation(
      regular: Color(0xffcee0ff),
      selected: Color(0xff9ab7ee),
    ),
    foreground: ColorVariation(
      regular: Color(0xFF7799B9),
      selected: Color(0xFF2C6396),
    ),
  ),
  wrapBackground: ColorVariation.only(Color(0xffccdfff)),
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

const settingItemColorLight = SettingsColorScheme(
  viewTitle: ConvertouchColorScheme(
    foreground: ColorVariation.only(Color(0xFF426F99)),
  ),
  settingItem: ConvertouchColorScheme(
    background: ColorVariation(
      regular: Color(0xFFDBE6FF),
      selected: Color(0xFFE5ECFF),
      disabled: Color(0xFFE5ECFF),
    ),
    foreground: ColorVariation(
      regular: Color(0xFF345F87),
    ),
  ),
  divider: ColorVariation.only(Color(0xffe8efff)),
  selectedValue: ColorVariation(
    regular: Color(0xFF517FAA),
  ),
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
