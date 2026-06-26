import 'package:app_settings/app_settings.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/presentation/ui/style/color/colors_factory.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
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
      appColors[theme].page.appBar.background.regular,
    );

    systemBottomNavbarColor = Color.alphaBlend(
      _dimmingOverlayColor,
      appColors[theme].page.bottomBar.background.regular,
    );

    iconBrightness = Brightness.light;
  } else {
    statusTopBarColor = appColors[theme].page.appBar.background.regular;
    systemBottomNavbarColor =
        appColors[theme].page.bottomBar.background.regular;
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
  required StatefulWidgetBuilder builder,
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
        child: StatefulBuilder(
          builder: builder,
        ),
      );
    },
  );
}

void showSnackBar(
  BuildContext context, {
  required ConvertouchException exception,
  required ConvertouchUITheme theme,
  int durationInSec = 2,
}) {
  NotificationColorScheme snackBarColor = appColors[theme].notification;

  Color foreground;
  switch (exception.severity) {
    case ExceptionSeverity.warning:
      foreground = snackBarColor.foreground.warning;
      break;
    case ExceptionSeverity.error:
      foreground = snackBarColor.foreground.error;
      break;
    case ExceptionSeverity.info:
      foreground = snackBarColor.foreground.regular;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: exception.handlingAction == null,
      closeIconColor: foreground,
      backgroundColor: snackBarColor.background.regular,
      duration: Duration(seconds: durationInSec),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(7),
      padding: const EdgeInsets.only(left: 18),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      action: exception.handlingAction != null
          ? SnackBarAction(
              label: exception.handlingAction!.label,
              textColor: snackBarColor.action.regular,
              onPressed: _snackBarActions[exception.handlingAction!] ?? () {},
            )
          : null,
      content: Text(
        exception.message,
        style: TextStyle(
          color: foreground,
          fontFamily: quicksandFontFamily,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}

final Map<ConvertouchSysAction, void Function()> _snackBarActions = {
  ConvertouchSysAction.connection: () {
    AppSettings.openAppSettings(
      type: AppSettingsType.wireless,
      asAnotherTask: true,
    );
  },
};
