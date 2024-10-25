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

class ListItemColorScheme extends ConvertouchColorScheme {
  final ColorVariation divider;
  final ColorVariation titleBackground;
  final ConvertouchColorScheme modeIcon;
  final ConvertouchColorScheme checkBox;

  const ListItemColorScheme({
    super.border,
    super.background,
    super.foreground,
    this.titleBackground = ColorVariation.none,
    this.modeIcon = ConvertouchColorScheme.none,
    this.checkBox = ConvertouchColorScheme.none,
    this.divider = ColorVariation.none,
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

  const SnackBarColorScheme({
    super.border,
    super.background,
    this.foregroundError = ColorVariation.none,
    this.foregroundWarning = ColorVariation.none,
    this.foregroundInfo = ColorVariation.none,
  });
}

class TextBoxColorScheme extends ConvertouchColorScheme {
  final ColorVariation hint;

  const TextBoxColorScheme({
    super.border,
    super.background,
    super.foreground,
    this.hint = ColorVariation.none,
  });
}

class SearchBarColorScheme {
  final TextBoxColorScheme textBox;
  final ConvertouchColorScheme viewModeButton;

  const SearchBarColorScheme({
    required this.textBox,
    required this.viewModeButton,
  });
}

class ConversionItemColorScheme extends ConvertouchColorScheme {
  final TextBoxColorScheme textBox;
  final ConvertouchColorScheme unitButton;
  final ConvertouchColorScheme handler;

  const ConversionItemColorScheme({
    required this.textBox,
    required this.unitButton,
    required this.handler,
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
