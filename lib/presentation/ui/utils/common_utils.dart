import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

double _dimFactor = 0.54;
Color _dimmingOverlayColor = Colors.black.withValues(alpha: _dimFactor);

SystemUiOverlayStyle buildSystemUiOverlayStyle({
  required ConvertouchUITheme theme,
  bool dialogOpened = false,
}) {
  Color statusTopBarColor;
  Color systemBottomNavbarColor;
  Brightness iconBrightness;

  if (dialogOpened) {
    // Do NOT use a method that changes the opacity of your original color
    // when you intend to pass it to SystemUiOverlayStyle,
    // e. g. withValues(alpha: alpha)

    statusTopBarColor = Color.alphaBlend(
      _dimmingOverlayColor,
      pageColors[theme]!.appBar.background.regular,
    );

    systemBottomNavbarColor = Color.alphaBlend(
      _dimmingOverlayColor,
      pageColors[theme]!.bottomBar.background.regular,
    );

    iconBrightness = Brightness.light;
  } else {
    statusTopBarColor = pageColors[theme]!.appBar.background.regular;
    systemBottomNavbarColor = pageColors[theme]!.bottomBar.background.regular;
    iconBrightness =
        theme == ConvertouchUITheme.dark ? Brightness.light : Brightness.dark;
  }

  return SystemUiOverlayStyle(
    statusBarColor: statusTopBarColor,
    statusBarIconBrightness: iconBrightness,
    systemNavigationBarColor: systemBottomNavbarColor,
    systemNavigationBarIconBrightness: iconBrightness,
    systemNavigationBarDividerColor: Colors.transparent,
  );
}

Future<T?> showConvertouchDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  required ConvertouchUITheme currentTheme,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: Duration.zero,
    pageBuilder: (buildContext, animation, secondaryAnimation) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: buildSystemUiOverlayStyle(
          theme: currentTheme,
          dialogOpened: true,
        ),
        child: builder(buildContext),
      );
    },
  );
}
