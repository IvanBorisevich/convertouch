import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/ui/style/color/color_set.dart';
import 'package:convertouch/presentation/ui/style/color/color_state_variation.dart';
import 'package:convertouch/presentation/ui/style/color/themes/dark.dart';
import 'package:convertouch/presentation/ui/style/color/themes/light.dart';
import 'package:flutter/material.dart';

const Color noColor = Colors.transparent;

const pageCommonColors = {
  ConvertouchUITheme.light: pageColorSchemeLight,
  ConvertouchUITheme.dark: pageColorSchemeDark,
};

const searchBarColors = {
  ConvertouchUITheme.light: searchBarColorSchemeLight,
  ConvertouchUITheme.dark: searchBarColorSchemeDark,
};

const unitGroupItemColors = {
  ConvertouchUITheme.light: unitGroupItemColorSchemeLight,
  ConvertouchUITheme.dark: unitGroupItemColorSchemeDark,
};

const unitGroupItemInAppBarColors = {
  ConvertouchUITheme.light: unitGroupItemInAppBarColorSchemeLight,
  ConvertouchUITheme.dark: unitGroupItemInAppBarColorSchemeDark,
};

const unitItemColors = {
  ConvertouchUITheme.light: unitItemColorSchemeLight,
  ConvertouchUITheme.dark: unitItemColorSchemeDark,
};

const conversionItemColors = {
  ConvertouchUITheme.light: conversionItemColorSchemeLight,
  ConvertouchUITheme.dark: conversionItemColorSchemeDark,
};

const unitGroupsPageFloatingButtonColors = {
  ConvertouchUITheme.light: ButtonColorSet(
    background: Color(0xFF7473FA),
    foreground: Color(0xFFDEE9FF),
  ),
  ConvertouchUITheme.dark: ButtonColorSet(
    background: Color(0xFF616491),
    foreground: Color(0xFFD1CFD3),
  ),
};

const unitsPageFloatingButtonColors = {
  ConvertouchUITheme.light: ButtonColorSet(
    background: Color(0xFF5499DA),
    foreground: Color(0xFFDEE9FF),
  ),
  ConvertouchUITheme.dark: ButtonColorSet(
    background: Color(0xDB446F96),
    foreground: Color(0xFFD1CFD3),
  ),
};

const conversionPageFloatingButtonColors = {
  ConvertouchUITheme.light: ButtonColorSet(
    background: Color(0xFF6793BE),
    foreground: Color(0xFFF5F7FF),
  ),
  ConvertouchUITheme.dark: ButtonColorSet(
    background: Color(0xDB446F96),
    foreground: Color(0xFFD1CFD3),
  ),
};

const refreshButtonColors = {
  ConvertouchUITheme.light: ColorStateVariation(
    regular: BaseColorSet(
      border: Color(0xFF3A3A88),
      background: Color(0xFFF2F5FF),
      foreground: Color(0xFF3A3A88),
    ),
    disabled: BaseColorSet(
      border: Color(0xFFC2CCFF),
      background: Color(0xFFF2F5FF),
      foreground: Color(0xFFC2CCFF),
    ),
  ),
  ConvertouchUITheme.dark: ColorStateVariation(
    regular: BaseColorSet(
      border: Color(0xFF585A6C),
      background: Color(0xFF3E4754),
      foreground: Color(0xFFB1B5EA),
    ),
    disabled: BaseColorSet(
      border: Color(0xFF585A6C),
      background: Color(0xFF3E4754),
      foreground: Color(0xFF7E82B4),
    ),
  ),
};

const removalFloatingButtonColors = {
  ConvertouchUITheme.light: ButtonColorSet(
    background: Color(0xFFD36422),
    foreground: Color(0xFFDEE9FF),
  ),
  ConvertouchUITheme.dark: ButtonColorSet(
    background: Color(0xFF9D5225),
    foreground: Color(0xFFDEE9FF),
  ),
};

const dividerWithTextColors = {
  ConvertouchUITheme.light: Color(0xFF709FCB),
  ConvertouchUITheme.dark: Color(0xFF709FCB),
};

const textBoxColors = {
  ConvertouchUITheme.light: ColorStateVariation(
    regular: TextBoxColorSet(
      border: Color(0xFF426F99),
      foreground: Color(0xFF426F99),
      label: Color(0xFF426F99),
      hint: Color(0xFF426F99),
    ),
    focused: TextBoxColorSet(
      border: Color(0xFF426F99),
      foreground: Color(0xFF426F99),
      label: Color(0xFF426F99),
      hint: Color(0xFF426F99),
    ),
  ),
  ConvertouchUITheme.dark: ColorStateVariation(
    regular: TextBoxColorSet(
      border: Color(0xFF709FCB),
      foreground: Color(0xFF709FCB),
      label: Color(0xFF709FCB),
      hint: Color(0xFF709FCB),
    ),
    focused: TextBoxColorSet(
      border: Color(0xFF709FCB),
      foreground: Color(0xFF709FCB),
      label: Color(0xFF709FCB),
      hint: Color(0xFF709FCB),
    ),
  ),
};

const unitGroupTextBoxColors = {
  ConvertouchUITheme.light: ColorStateVariation(
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
  ),
  ConvertouchUITheme.dark: ColorStateVariation(
    regular: TextBoxColorSet(
      border: Color(0xFFA1A4CE),
      foreground: Color(0xFFA1A4CE),
      label: Color(0xFFA1A4CE),
    ),
    focused: TextBoxColorSet(
      border: Color(0xFFC1C3E5),
      foreground: Color(0xFFC1C3E5),
      label: Color(0xFFC1C3E5),
    ),
  ),
};

const settingItemColors = {
  ConvertouchUITheme.light: ColorStateVariation(
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
  ),
};

const progressIndicatorColors = {
  ConvertouchUITheme.light: BaseColorSet(
    foreground: Color(0xFF3A3A88),
  ),
  ConvertouchUITheme.dark: BaseColorSet(
    foreground: Color(0xFF7272C9),
  ),
};
