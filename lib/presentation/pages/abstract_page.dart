import 'package:convertouch/presentation/bloc/app/app_states.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/pages/scaffold/navigation_service.dart';
import 'package:convertouch/presentation/pages/style/model/color_variation.dart';
import 'package:flutter/material.dart';

abstract class ConvertouchPage extends StatelessWidget {
  const ConvertouchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return appBloc((appState) {
      return buildBody(context, appState);
    });
  }

  void onStart(BuildContext context, AppStateChanged appState);
  Widget buildBody(BuildContext context, AppStateChanged appState);
  Widget buildButtonToAdd(BuildContext context, AppStateChanged appState) {
    return empty();
  }
  Widget buildButtonToRemove(BuildContext context, AppStateChanged appState) {
    return empty();
  }
}

Widget floatingActionButton({
  required IconData iconData,
  void Function()? onClick,
  FloatingButtonColorVariation? color,
}) {
  return FloatingActionButton(
    onPressed: onClick,
    backgroundColor: color?.background,
    foregroundColor: color?.foreground,
    elevation: 0,
    child: Icon(iconData),
  );
}

Widget empty() {
  return const SizedBox(
    height: 0,
    width: 0,
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
