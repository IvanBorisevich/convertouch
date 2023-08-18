import 'package:convertouch/model/constant.dart';
import 'package:convertouch/view/scaffold/navigation_service.dart';
import 'package:convertouch/view/style/colors.dart';
import 'package:flutter/material.dart';

class ConvertouchScaffold extends StatelessWidget {
  static const double appBarPadding = 7;

  const ConvertouchScaffold({
    super.key,
    required this.body,
    this.appBarLeftWidget,
    this.pageTitle = appName,
    this.appBarRightWidgets,
    this.secondaryAppBar,
    this.floatingActionButton,
  });

  final Widget? appBarLeftWidget;
  final String pageTitle;
  final List<Widget>? appBarRightWidgets;
  final Widget? secondaryAppBar;
  final Widget body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: appBarLeftWidget ??
              (NavigationService.I.isHomePage(context)
                  ? leadingIcon(Icons.menu, () {})
                  : leadingIcon(Icons.arrow_back_rounded, () {
                      NavigationService.I.navigateBack();
                    })),
          centerTitle: true,
          title: Text(
            pageTitle,
            style: TextStyle(
              color: scaffoldColors[ConvertouchUITheme.light]!.appBarFontColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor:
              scaffoldColors[ConvertouchUITheme.light]!.appBarColor,
          elevation: 0,
          actions: appBarRightWidgets,
        ),
        body: Column(
          children: [
            Visibility(
              visible: secondaryAppBar != null,
              child: Container(
                height: 53,
                decoration: BoxDecoration(
                  color: scaffoldColors[ConvertouchUITheme.light]!.appBarColor,
                ),
                padding: const EdgeInsetsDirectional.fromSTEB(
                  appBarPadding,
                  0,
                  appBarPadding,
                  appBarPadding,
                ),
                child: secondaryAppBar,
              ),
            ),
            Expanded(
              child: body,
            ),
          ],
        ),
        floatingActionButton: floatingActionButton,
      ),
    );
  }

  Widget leadingIcon(
    IconData iconData,
    void Function()? onPressed,
  ) {
    return IconButton(
      icon: Icon(
        iconData,
        color: scaffoldColors[ConvertouchUITheme.light]!.appBarIconColor,
      ),
      onPressed: onPressed,
    );
  }
}

Widget checkIcon(
  BuildContext context, {
  bool isVisible = true,
  bool isEnabled = false,
  void Function()? onPressedFunc,
}) {
  return Visibility(
    visible: isVisible,
    child: IconButton(
      icon: Icon(
        Icons.check,
        color: isEnabled
            ? scaffoldColors[ConvertouchUITheme.light]!.appBarIconColor
            : null,
      ),
      disabledColor:
          scaffoldColors[ConvertouchUITheme.light]!.appBarIconColorDisabled,
      onPressed: isEnabled ? onPressedFunc : null,
    ),
  );
}

void showAlertDialog(BuildContext context, String message) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              NavigationService.I.navigateBack();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

Widget empty() {
  return const SizedBox(
    height: 0,
    width: 0,
  );
}