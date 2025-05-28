import 'package:convertouch/presentation/ui/style/color/color_variation.dart';

class ConvertouchColorScheme {
  static const ConvertouchColorScheme none = ConvertouchColorScheme();

  final ColorVariation border;
  final ColorVariation background;
  final ColorVariation foreground;

  const ConvertouchColorScheme({
    this.border = ColorVariation.none,
    this.background = ColorVariation.none,
    this.foreground = ColorVariation.none,
  });
}

class ParamSetPanelColorScheme {
  final ConvertouchColorScheme tab;
  final ConvertouchColorScheme toolset;
  final ConvertouchColorScheme footer;
  final ColorVariation removalIcon;
  final ConversionItemColorScheme paramItem;

  const ParamSetPanelColorScheme({
    this.tab = ConvertouchColorScheme.none,
    this.toolset = ConvertouchColorScheme.none,
    this.footer = ConvertouchColorScheme.none,
    this.removalIcon = ColorVariation.none,
    required this.paramItem,
  });
}

class ListItemColorScheme extends ConvertouchColorScheme {
  final ColorVariation divider;
  final ColorVariation titleBackground;
  final ConvertouchColorScheme modeIcon;
  final ConvertouchColorScheme checkBox;
  final ColorVariation matchBackground;
  final ColorVariation matchForeground;

  const ListItemColorScheme({
    super.border,
    super.background,
    super.foreground,
    this.titleBackground = ColorVariation.none,
    this.modeIcon = ConvertouchColorScheme.none,
    this.checkBox = ConvertouchColorScheme.none,
    this.divider = ColorVariation.none,
    this.matchForeground = ColorVariation.none,
    this.matchBackground = ColorVariation.none,
  });
}

class SwitcherColorScheme extends ConvertouchColorScheme {
  static const SwitcherColorScheme none = SwitcherColorScheme();

  final ConvertouchColorScheme track;

  const SwitcherColorScheme({
    this.track = ConvertouchColorScheme.none,
  });
}

class SettingItemColorScheme extends ListItemColorScheme {
  final SwitcherColorScheme switcher;

  const SettingItemColorScheme({
    super.border,
    super.background,
    super.foreground,
    super.divider,
    this.switcher = SwitcherColorScheme.none,
  });
}

class SnackBarColorScheme extends ConvertouchColorScheme {
  final ColorVariation foregroundError;
  final ColorVariation foregroundWarning;
  final ColorVariation foregroundInfo;
  final ColorVariation action;

  const SnackBarColorScheme({
    super.border,
    super.background,
    this.foregroundError = ColorVariation.none,
    this.foregroundWarning = ColorVariation.none,
    this.foregroundInfo = ColorVariation.none,
    this.action = ColorVariation.none,
  });
}

class InputBoxColorScheme extends ConvertouchColorScheme {
  final ColorVariation hint;
  final ConvertouchColorScheme dropdown;

  const InputBoxColorScheme({
    super.border,
    super.background,
    super.foreground,
    this.hint = ColorVariation.none,
    this.dropdown = ConvertouchColorScheme.none,
  });
}

class SearchBarColorScheme {
  final InputBoxColorScheme textBox;
  final ConvertouchColorScheme viewModeButton;

  const SearchBarColorScheme({
    required this.textBox,
    required this.viewModeButton,
  });
}

class ConversionItemColorScheme extends ConvertouchColorScheme {
  final InputBoxColorScheme textBox;
  final ConvertouchColorScheme unitButton;
  final ConvertouchColorScheme handler;
  final ColorVariation highlightBackground;

  const ConversionItemColorScheme({
    required this.textBox,
    required this.unitButton,
    this.handler = ConvertouchColorScheme.none,
    this.highlightBackground = ColorVariation.none,
    super.background,
  });
}

class PageColorScheme {
  final ConvertouchColorScheme appBar;
  final ConvertouchColorScheme page;
  final ConvertouchColorScheme bottomBar;
  final SnackBarColorScheme snackBar;

  const PageColorScheme({
    required this.appBar,
    required this.page,
    required this.bottomBar,
    required this.snackBar,
  });
}
