import 'package:convertouch/model/constant.dart';
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
        leading: appBarLeftWidget ?? menuIcon(context),
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

Widget menuIcon(BuildContext context) {
  return IconButton(
    icon: const Icon(
      Icons.menu,
      color: Color(0xFF426F99),
    ),
    onPressed: () {},
  );
}

Widget backIcon(BuildContext context) {
  return IconButton(
    icon: const Icon(
      Icons.arrow_back_rounded,
      color: Color(0xFF426F99),
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
}

Widget checkIcon(
    BuildContext context, bool isEnabled, void Function()? onPressedFunc) {
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
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
