import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/color_set.dart';
import 'package:convertouch/presentation/ui/style/color/color_state_variation.dart';
import 'package:flutter/material.dart';

const pageColorSchemeLight = PageColorScheme(
  appBar: ColorStateVariation(
    regular: AppBarColorSet(
      background: Color(0xFFDEE9FF),
      foreground: Color(0xFF426F99),
    ),
    disabled: AppBarColorSet(
      background: Color(0xFFDEE9FF),
      foreground: Color(0xFFA0C4F5),
    ),
  ),
  page: BaseColorSet(
    background: Color(0xFFFCFEFF),
    foreground: Color(0xFF426F99),
  ),
  snackBar: SnackBarColorSet(
    background: Color(0xFF426F99),
    foregroundInfo: Color(0xFFF2F8FF),
    foregroundWarning: Color(0xFFF1FFB0),
    foregroundError: Color(0xFFFFAAAA),
  ),
  bottomBar: ColorStateVariation(
    regular: AppBarColorSet(
      background: Color(0xFFDEE9FF),
      foreground: Color(0xFF426F99),
    ),
    disabled: AppBarColorSet(
      background: Color(0xFFDEE9FF),
      foreground: Color(0xFFA0C4F5),
    ),
    selected: AppBarColorSet(
      background: Color(0xFFDEE9FF),
      foreground: Color(0xFF4C90EC),
    ),
  ),
);

const searchBarColorSchemeLight = SearchBarColorScheme(
  searchBox: TextBoxColorSet(
    background: Color(0xFFF6F9FF),
    foreground: Color(0xFF426F99),
    hint: Color(0xFF5C93C7),
  ),
  viewModeButton: ButtonColorSet(
    background: Color(0xFFF6F9FF),
    foreground: Color(0xFF426F99),
  ),
);

const unitGroupItemColorSchemeLight = ColorStateVariation(
  regular: BaseColorSet(
    border: Color(0xFFC2CCFF),
    background: Color(0xFFF2F5FF),
    foreground: Color(0xFF3A3A88),
  ),
  selected: BaseColorSet(
    border: Color(0xFF9EADFA),
    background: Color(0xFFE5EAFF),
    foreground: Color(0xFF303073),
  ),
);

const unitGroupItemInAppBarColorSchemeLight = ColorStateVariation(
  regular: BaseColorSet(
    border: Color(0xFF426F99),
    foreground: Color(0xFF426F99),
  ),
);

const unitItemColorSchemeLight = ColorStateVariation(
  regular: BaseColorSet(
    border: Color(0xFFB5DBFF),
    background: Color(0xFFDFEDFF),
    foreground: Color(0xFF366C9F),
  ),
  marked: BaseColorSet(
    border: Color(0xFF509CE0),
    background: Color(0xFFCCE1FF),
    foreground: Color(0xFF366C9F),
  ),
  selected: BaseColorSet(
    border: Color(0xFF2F7DC2),
    background: Color(0xFFCCE1FF),
    foreground: Color(0xFF366C9F),
  ),
  disabled: BaseColorSet(
    border: Color(0xFFCCE5FF),
    background: Color(0xFFE9F2FF),
    foreground: Color(0xFF83B5E5),
  ),
);

const textBoxColorLight = ColorStateVariation(
  regular: TextBoxColorSet(
    border: Color(0xFF7FA0BE),
    foreground: Color(0xFF426F99),
    label: Color(0xFF7FA0BE),
    hint: Color(0xFFA8C9E7),
  ),
  focused: TextBoxColorSet(
    border: Color(0xFF375067),
    foreground: Color(0xFF426F99),
    label: Color(0xFF375067),
    hint: Color(0xFFA8C9E7),
  ),
);

const conversionItemColorSchemeLight = ConversionItemColorScheme(
  textBox: textBoxColorLight,
  unitButton: ColorStateVariation(
    regular: BaseColorSet(
      border: Color(0xFF7FA0BE),
      background: Color(0xFFE2EEF8),
      foreground: Color(0xFF426F99),
    ),
    focused: BaseColorSet(
      border: Color(0xFF375067),
      background: Color(0xFFB9D7F1),
      foreground: Color(0xFF2D4B67),
    ),
  ),
  handler: Color(0xFF7FA0BE),
);

const unitGroupsPageFloatingButtonColorSchemeLight = ButtonColorSet(
  background: Color(0xFF7473FA),
  foreground: Color(0xFFDEE9FF),
);

const unitsPageFloatingButtonColorSchemeLight = ButtonColorSet(
  background: Color(0xFF5499DA),
  foreground: Color(0xFFDEE9FF),
);

const conversionPageFloatingButtonColorSchemeLight = ButtonColorSet(
  background: Color(0xFF6793BE),
  foreground: Color(0xFFF5F7FF),
);

const refreshButtonColorSchemeLight = ColorStateVariation(
  regular: BaseColorSet(
    border: Color(0xFF484898),
    foreground: Color(0xFF484898),
    background: Color(0xFFC9C9F8),
  ),
  disabled: BaseColorSet(
    border: Color(0xFFC2CCFF),
    foreground: Color(0xFFC2CCFF),
  ),
);

const removalFloatingButtonColorLight = ButtonColorSet(
  background: Color(0xFFD36422),
  foreground: Color(0xFFDEE9FF),
  border: Color(0xFFFCFEFF),
);

const unitGroupTextBoxColorLight = ColorStateVariation(
  regular: TextBoxColorSet(
    border: Color(0xFF5F4299),
    foreground: Color(0xFF5F4299),
    label: Color(0xFF5F4299),
  ),
  focused: TextBoxColorSet(
    border: Color(0xFF5F4299),
    foreground: Color(0xFF5F4299),
    label: Color(0xFF5F4299),
  ),
);

const settingItemColorLight = ColorStateVariation(
  regular: SettingItemColorSet(
    background: Color(0xFFE5ECFF),
    foreground: Color(0xFF426F99),
    divider: Color(0xFFB6CAFF),
    switcher: SwitcherColorSet(
      track: BaseColorSet(
        border: Color(0xFF426F99),
      ),
    ),
  ),
  selected: SettingItemColorSet(
    background: Color(0xFFE5ECFF),
    foreground: Color(0xFF426F99),
    divider: Color(0xFFB6CAFF),
    switcher: SwitcherColorSet(
      track: BaseColorSet(
        background: Color(0xFF7FA1C0),
        border: Color(0xFF7FA1C0),
      ),
    ),
  ),
  disabled: SettingItemColorSet(
    background: Color(0xFFE5ECFF),
    foreground: Color(0xFF6F9ECB),
    divider: Color(0xFFB6CAFF),
    switcher: SwitcherColorSet(
      track: BaseColorSet(
        background: Color(0xFF94B4D2),
        border: Color(0xFF94B4D2),
      ),
    ),
  ),
);
