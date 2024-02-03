import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/color_set.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';

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
          backgroundColor: pageColorScheme.page.background,
          appBar: AppBar(
            leading: Builder(
              builder: (context) {
                if (customLeadingIcon != null) {
                  return customLeadingIcon!;
                } else if (ModalRoute.of(context)?.canPop ?? true) {
                  return leadingIcon(
                    icon: Icons.arrow_back_rounded,
                    color: pageColorScheme.appBar.regular,
                    onClick: () {
                      Navigator.of(context).pop();
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
                color: pageColorScheme.appBar.regular.foreground,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: pageColorScheme.appBar.regular.background,
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

Widget leadingIcon({
  required IconData icon,
  void Function()? onClick,
  AppBarColorSet? color,
}) {
  return IconButton(
    icon: Icon(
      icon,
      color: color?.foreground,
    ),
    onPressed: onClick,
  );
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
              Navigator.of(context).pop();
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
  required String message,
  required BaseColorSet colorSet,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      closeIconColor: colorSet.foreground,
      backgroundColor: colorSet.background,
      content: Center(
        child: Text(
          message,
          style: TextStyle(
            color: colorSet.foreground,
            fontFamily: quicksandFontFamily,
          ),
        ),
      ),
    ),
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
