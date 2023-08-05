import 'package:convertouch/model/constant.dart';
import 'package:convertouch/view/scaffold/navigation.dart';
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
    this.appBarColor = const Color(0xFFDEE9FF),
    this.appBarFontColor = const Color(0xFF426F99),
    this.appBarIconColor = const Color(0xFF426F99),
  });

  final Widget? appBarLeftWidget;
  final String pageTitle;
  final List<Widget>? appBarRightWidgets;
  final Widget? secondaryAppBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Color appBarColor;
  final Color appBarFontColor;
  final Color appBarIconColor;

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
              color: appBarFontColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: appBarColor,
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
                  color: appBarColor,
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
        color: appBarIconColor,
      ),
      onPressed: onPressed,
    );
  }
}

Widget checkIcon(
  BuildContext context, {
  bool isVisible = true,
  bool isEnabled = false,
  Color iconColor = const Color(0xFF426F99),
  Color iconColorDisabled = const Color(0xFFA0C4F5),
  void Function()? onPressedFunc,
}) {
  return Visibility(
    visible: isVisible,
    child: IconButton(
      icon: Icon(
        Icons.check,
        color: isEnabled ? iconColor : null,
      ),
      disabledColor: iconColorDisabled,
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

Widget horizontalDividerWithText(String text) {
  return Row(children: [
    const Expanded(child: Divider(color: Color(0xFF426F99), thickness: 1.2)),
    const SizedBox(width: 7),
    Text(
      text,
      style: const TextStyle(
          color: Color(0xFF426F99), fontWeight: FontWeight.w500),
    ),
    const SizedBox(width: 7),
    const Expanded(
        child: Divider(
      color: Color(0xFF426F99),
      thickness: 1.2,
    )),
  ]);
}

Widget empty() {
  return const SizedBox(
    height: 0,
    width: 0,
  );
}