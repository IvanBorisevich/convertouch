import 'package:convertouch/presentation/bloc/app/app_state.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color.dart';
import 'package:convertouch/presentation/ui/style/model/color_variation.dart';
import 'package:flutter/material.dart';

class ConvertouchPage extends StatelessWidget {
  final AppStateBuilt appState;
  final Widget body;
  final String title;
  final Widget? customLeadingIcon;
  final List<Widget>? appBarRightWidgets;
  final Widget? secondaryAppBar;
  final Color? secondaryAppBarColor;
  final double secondaryAppBarHeight;
  final EdgeInsetsGeometry secondaryAppBarPadding;
  final Widget? floatingActionButton;
  final void Function()? onItemsRemove;

  const ConvertouchPage({
    required this.appState,
    required this.body,
    required this.title,
    this.customLeadingIcon,
    this.appBarRightWidgets,
    this.secondaryAppBar,
    this.secondaryAppBarColor,
    this.secondaryAppBarHeight = 53,
    this.secondaryAppBarPadding = const EdgeInsets.only(
      left: 7,
      top: 0,
      right: 7,
      bottom: 7,
    ),
    this.floatingActionButton,
    this.onItemsRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ConvertouchScaffoldColor scaffoldColor = scaffoldColors[appState.theme]!;
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldColor.regular.backgroundColor,
        appBar: AppBar(
          leading: Builder(
            builder: (context) {
              if (customLeadingIcon != null) {
                return customLeadingIcon!;
              } else if (ModalRoute.of(context)?.canPop ?? true) {
                return leadingIcon(
                  icon: Icons.arrow_back_rounded,
                  color: scaffoldColor.regular,
                  onClick: () {
                    Navigator.of(context).pop();
                  },
                );
              } else {
                return empty();
              }
            },
          ),
          centerTitle: true,
          title: Text(
            title,
            style: TextStyle(
              color: scaffoldColor.regular.appBarFontColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: scaffoldColor.regular.appBarColor,
          elevation: 0,
          actions: appBarRightWidgets,
        ),
        body: Column(
          children: [
            Visibility(
              visible: secondaryAppBar != null,
              child: Container(
                height: secondaryAppBarHeight,
                decoration: BoxDecoration(
                  color:
                      secondaryAppBarColor ?? scaffoldColor.regular.appBarColor,
                ),
                padding: secondaryAppBarPadding,
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
}

Widget leadingIcon({
  required IconData icon,
  void Function()? onClick,
  ScaffoldColorVariation? color,
}) {
  return IconButton(
    icon: Icon(
      icon,
      color: color?.appBarIconColor,
    ),
    onPressed: onClick,
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
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
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
