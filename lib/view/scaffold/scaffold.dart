import 'package:convertouch/model/constant.dart';
import 'package:convertouch/view/scaffold/navigation.dart';
import 'package:flutter/material.dart';

class ConvertouchScaffold extends StatelessWidget {
  const ConvertouchScaffold(
      {super.key,
      this.appBarLeftWidget,
      this.pageTitle = appName,
      this.appBarRightWidgets,
      this.body,
      this.floatingActionButton});

  final Widget? appBarLeftWidget;
  final String pageTitle;
  final List<Widget>? appBarRightWidgets;
  final Widget? body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: appBarLeftWidget ??
            (NavigationService.I.isHomePage()
                ? leadingIcon(Icons.menu, () {

                  })
                : leadingIcon(Icons.arrow_back_rounded, () {
                  NavigationService.I.navigateBack();
                  })),
        centerTitle: true,
        title: Text(
          pageTitle,
          style: const TextStyle(
              color: Color(0xFF426F99),
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFFDEE9FF),
        elevation: 0,
        actions: appBarRightWidgets,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    ));
  }
}

Widget leadingIcon(IconData iconData, void Function()? onPressed) {
  return IconButton(
    icon: Icon(
      iconData,
      color: const Color(0xFF426F99),
    ),
    onPressed: onPressed,
  );
}

Widget checkIcon(
    BuildContext context, {
      bool isEnabled = false,
      void Function()? onPressedFunc,
    }) {
  return IconButton(
    icon: Icon(
      Icons.check,
      color: isEnabled ? const Color(0xFF426F99) : null,
    ),
    disabledColor: const Color(0xFFA0C4F5),
    onPressed: isEnabled ? onPressedFunc : null,
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
