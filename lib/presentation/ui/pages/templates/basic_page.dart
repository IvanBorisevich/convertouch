import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchPage extends StatelessWidget {
  final Widget body;
  final String title;
  final Widget? customLeadingIcon;
  final List<Widget>? appBarRightWidgets;
  final PreferredSizeWidget? secondaryAppBar;
  final Widget? floatingActionButton;
  final void Function()? onItemsRemove;

  const ConvertouchPage({
    required this.body,
    required this.title,
    this.customLeadingIcon,
    this.appBarRightWidgets,
    this.secondaryAppBar,
    this.floatingActionButton,
    this.onItemsRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      PageColorScheme pageColorScheme = pageColors[appState.theme]!;
      return SafeArea(
        child: Scaffold(
          backgroundColor: pageColorScheme.page.background.regular,
          appBar: AppBar(
            leading: Builder(
              builder: (context) {
                if (customLeadingIcon != null) {
                  return customLeadingIcon!;
                } else if (ModalRoute.of(context)?.canPop == true) {
                  return IconButton(
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: pageColorScheme.appBar.foreground.regular,
                    ),
                    onPressed: () {
                      BlocProvider.of<NavigationBloc>(context).add(
                        const NavigateBack(),
                      );
                    },
                  );
                } else {
                  return empty();
                }
              },
            ),
            bottom: secondaryAppBar,
            centerTitle: true,
            title: Text(
              title,
              style: TextStyle(
                color: pageColorScheme.appBar.foreground.regular,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: pageColorScheme.appBar.background.regular,
            elevation: 0,
            actions: appBarRightWidgets,
          ),
          body: body,
          floatingActionButton: floatingActionButton,
        ),
      );
    });
  }
}


void showAlertDialog(
  BuildContext context, {
  required String message,
}) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              BlocProvider.of<NavigationBloc>(context).add(
                const NavigateBack(),
              );
            },
            child: const Text('OK'),
          ),
        ],
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
  SnackBarColorScheme snackBarColor = pageColors[theme]!.snackBar;

  Color foreground;

  switch (exception.severity) {
    case ExceptionSeverity.warning:
      foreground = snackBarColor.foregroundWarning.regular;
      break;
    case ExceptionSeverity.error:
      foreground = snackBarColor.foregroundError.regular;
      break;
    case ExceptionSeverity.info:
      foreground = snackBarColor.foregroundInfo.regular;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      closeIconColor: foreground,
      backgroundColor: snackBarColor.background.regular,
      duration: Duration(seconds: durationInSec),
      content: Center(
        child: Text(
          exception.message,
          style: TextStyle(
            color: foreground,
            fontFamily: quicksandFontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}

Widget infoNote({
  required double width,
  required Widget child,
  Color backgroundColor = noColor,
}) {
  return Container(
    width: width,
    padding: const EdgeInsets.symmetric(
      vertical: 10,
      horizontal: 14,
    ),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: child,
  );
}

Widget noItemsView(String label) {
  return SizedBox(
    child: Center(
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

Widget empty() {
  return const SizedBox(
    height: 0,
    width: 0,
  );
}
