import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/color_variation.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';

const pageColorSchemeDark = PageColorScheme(
  appBar: ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xFF26292F)),
    foreground: ColorVariation.only(Color(0xFFBDCDDA)),
  ),
  page: ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xFF363D48)),
    foreground: ColorVariation.only(Color(0xFFCCD7E0)),
  ),
  snackBar: SnackBarColorScheme(
    background: ColorVariation.only(Color(0xFF384867)),
    foregroundError: ColorVariation.only(Color(0xFFFFAAAA)),
    foregroundWarning: ColorVariation.only(Color(0xFFEADFB8)),
    foregroundInfo: ColorVariation.only(Color(0xFFA3D4FF)),
    action: ColorVariation.only(Color(0xFFB6D5F6)),
  ),
  bottomBar: ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xFF2B2F38)),
    foreground: ColorVariation(
      regular: Color(0xFFCCD7E0),
      selected: Color(0xFF85B3D9),
      disabled: Color(0xFF8D8D8D),
    ),
  ),
);

const searchBarColorSchemeDark = SearchBarColorScheme(
  textBox: InputBoxColorScheme(
    background: ColorVariation.only(Color(0xFF444C59)),
    foreground: ColorVariation.only(Color(0xFFCCD7E0)),
    hint: ColorVariation.only(Color(0xFF8791A1)),
  ),
  viewModeButton: ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xFF383D46)),
    foreground: ColorVariation.only(Color(0xFFCCD7E0)),
  ),
);

const paramSetColorSchemeDark = ParamSetPanelColorScheme(
  background: ColorVariation.only(Color(0xFF2F323A)),
  foreground: ColorVariation.only(Color(0xFF76C1FF)),
  icon: ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xFF424756)),
    foreground: ColorVariation.only(Color(0xFF76C1FF)),
  ),
);

const unitBottomLoaderDark = ListItemColorScheme(
  background: ColorVariation.only(Color(0xFF3A4454)),
  foreground: ColorVariation.only(Color(0xFF85B3DC)),
);

const unitGroupBottomLoaderDark = ListItemColorScheme(
  background: ColorVariation.only(Color(0xff3f4552)),
  foreground: ColorVariation.only(Color(0xffa3b4e1)),
);

const unitGroupItemColorSchemeDark = ListItemColorScheme(
  border: ColorVariation(
    regular: Color(0xff434c60),
    selected: Color(0xffa6baee),
  ),
  background: ColorVariation(
    regular: Color(0xff434c60),
    selected: Color(0xff475065),
  ),
  titleBackground: ColorVariation(
    regular: Color(0xff4b5369),
    selected: Color(0xff475065),
  ),
  matchBackground: ColorVariation.only(Color(0xff626f8c)),
  matchForeground: ColorVariation.only(Color(0xffd1ddfc)),
  foreground: ColorVariation(
    regular: Color(0xffa6baee),
  ),
  divider: ColorVariation(
    regular: Color(0xffa6baee),
  ),
  checkBox: ConvertouchColorScheme(
    border: ColorVariation(
      regular: Color(0xff849ad2),
    ),
    background: ColorVariation(
      regular: Color(0xFF363D48),
      selected: Color(0xff849ad2),
    ),
    foreground: ColorVariation(
      regular: noColor,
      selected: Colors.white,
    ),
  ),
  modeIcon: ConvertouchColorScheme(
    border: ColorVariation(
      regular: Color(0xff525c72),
    ),
    background: ColorVariation(
      regular: Color(0xff525c72),
    ),
    foreground: ColorVariation(
      regular: Color(0xffa6baee),
    ),
  ),
);

const unitItemColorSchemeDark = ListItemColorScheme(
  border: ColorVariation(
    regular: Color(0xFF435064),
    disabled: Color(0x9B424E62),
  ),
  background: ColorVariation(
    regular: Color(0xFF435064),
    disabled: Color(0x9B3C485B),
  ),
  titleBackground: ColorVariation(
    regular: Color(0xFF495972),
    disabled: Color(0x9B3F4B5E),
  ),
  matchBackground: ColorVariation.only(Color(0xFF5A6C86)),
  matchForeground: ColorVariation.only(Color(0xFFA6D5FF)),
  foreground: ColorVariation(
    regular: Color(0xFF85B3DC),
    disabled: Color(0x867FACD5),
  ),
  divider: ColorVariation(
    regular: Color(0xFF7DAAD3),
    disabled: Color(0x867FACD5),
  ),
  checkBox: ConvertouchColorScheme(
    border: ColorVariation(
      regular: Color(0xFF6F98BD),
    ),
    background: ColorVariation(
      regular: Color(0xFF363D48),
      selected: Color(0xFF6F98BD),
    ),
    foreground: ColorVariation(
      regular: noColor,
      selected: Colors.white,
    ),
  ),
  modeIcon: ConvertouchColorScheme(
    border: ColorVariation(
      regular: Color(0xFF54637A),
    ),
    background: ColorVariation(
      regular: Color(0xFF54637A),
    ),
    foreground: ColorVariation(
      regular: Color(0xFF85B3DC),
    ),
  ),
);

const unitGroupPageInfoBoxColorDark = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xff434c60)),
);

const unitPageInfoBoxColorDark = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xFF3E4A5D)),
);

const unitGroupPageEmptyViewColorDark = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xff434b5d)),
  foreground: ColorVariation.only(Color(0xffa6baee)),
);

const unitPageEmptyViewColorDark = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xFF3B4556)),
  foreground: ColorVariation.only(Color(0xFF7DAAD3)),
);

const unitTextBoxColorDark = InputBoxColorScheme(
  border: ColorVariation(
    regular: Color(0xFF84A1BD),
    focused: Color(0xFF98BAD9),
    disabled: Color(0xFF687A8C),
  ),
  foreground: ColorVariation(
    regular: Color(0xFFA3C2DE),
    disabled: Color(0xFF687A8C),
  ),
  hint: ColorVariation(
    regular: Color(0xFF84A1BD),
    disabled: Color(0xFF7C9EBE),
  ),
  dropdown: ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xFF3F4857)),
    foreground: ColorVariation.only(Color(0xFFBFD3E3)),
  ),
);

const unitGroupTextBoxColorDark = InputBoxColorScheme(
  border: ColorVariation(
    regular: Color(0xFF8594F1),
    disabled: Color(0x90A5B2FF),
  ),
  foreground: ColorVariation(
    regular: Color(0xFFA7B2F5),
    disabled: Color(0x90A5B2FF),
  ),
  hint: ColorVariation(
    regular: Color(0xFF8594F1),
  ),
);

const conversionItemColorSchemeDark = ConversionItemColorScheme(
  textBox: unitTextBoxColorDark,
  background: ColorVariation.only(Color(0xFF373F4B)),
  unitButton: ConvertouchColorScheme(
    border: ColorVariation(
      regular: Color(0xFF495972), //Color(0xFF708EA8),
      focused: Color(0xFF8FB1D0),
    ),
    background: ColorVariation(
      regular: Color(0xFF495972),
    ),
    foreground: ColorVariation(
      regular: Color(0xFFADCEEC),
    ),
  ),
  handler: ConvertouchColorScheme(
    background: ColorVariation.only(Color(0xFF3C4554)),
    foreground: ColorVariation.only(Color(0xFF7E9CB7)),
  ),
);

const unitGroupsPageFloatingButtonColorSchemeDark = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xFF5E63A8)),
  foreground: ColorVariation.only(Color(0xFFD1CFD3)),
);

const unitsPageFloatingButtonColorSchemeDark = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xFF446F96)),
  foreground: ColorVariation.only(Color(0xFFD1CFD3)),
);

const conversionPageFloatingButtonColorSchemeDark = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xFF4079B0)),
  foreground: ColorVariation.only(Color(0xFFDEE0FF)),
);

const refreshButtonColorSchemeDark = ConvertouchColorScheme(
  border: ColorVariation(
    regular: Color(0xFF39889F),
  ),
  foreground: ColorVariation(
    regular: Color(0xFFBFEFFF),
    selected: Color(0xFF5BAEC7),
  ),
  background: ColorVariation.only(Color(0xFF39889F)),
);

const removalFloatingButtonColorDark = ConvertouchColorScheme(
  border: ColorVariation.only(Color(0xFF373F4B)),
  background: ColorVariation.only(Color(0xFF9D5225)),
  foreground: ColorVariation.only(Color(0xFFDEE9FF)),
);

const settingItemColorDark = SettingItemColorScheme(
  border: ColorVariation(regular: Color(0xE4485564)),
  background: ColorVariation(
    regular: Color(0xE438434F),
    selected: Color(0xFF506394),
    disabled: Color(0xFF506394),
  ),
  foreground: ColorVariation(
    regular: Color(0xFFB1D2F1),
    selected: Color(0xFF88A3BD),
    disabled: Color(0xFF6F9ECB),
  ),
  divider: ColorVariation.only(Color(0xE4485564)),
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

const alertDialogColorDark = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xE438434F)),
  foreground: ColorVariation.only(Color(0xFFB1D2F1)),
);

const errorInfoBoxColorDark = ConvertouchColorScheme(
  background: ColorVariation.only(Color(0xFF3E4A5D)),
  foreground: ColorVariation.only(Color(0xFF81B8EC)),
);
