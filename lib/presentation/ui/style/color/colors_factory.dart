import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/presentation/ui/style/color/schemes/dark.dart';
import 'package:convertouch/presentation/ui/style/color/schemes/light.dart';
import 'package:convertouch/presentation/ui/style/color/model/app_color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';

class _AppColorsFactory {
  static const instance = _AppColorsFactory._();

  const _AppColorsFactory._();

  AppColorScheme operator [](ConvertouchUITheme theme) => _colors[theme]!;

  Map<ConvertouchUITheme, MenuViewColorScheme> get unitsMenuColors =>
      _colors.map((theme, appScheme) => MapEntry(theme, appScheme.unitsMenu));

  Map<ConvertouchUITheme, MenuViewColorScheme> get unitGroupsMenuColors =>
      _colors
          .map((theme, appScheme) => MapEntry(theme, appScheme.unitGroupsMenu));
}

const Map<ConvertouchUITheme, AppColorScheme> _colors = {
  ConvertouchUITheme.light: colorSchemeLight,
  ConvertouchUITheme.dark: colorSchemeDark,
};

const appColors = _AppColorsFactory.instance;
