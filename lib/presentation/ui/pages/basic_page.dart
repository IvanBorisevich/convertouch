import 'package:convertouch/presentation/bloc/base_state.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color.dart';
import 'package:convertouch/presentation/ui/style/model/color_variation.dart';
import 'package:convertouch/presentation/services/navigation_service.dart';
import 'package:flutter/material.dart';

class ConvertouchPage extends StatelessWidget {
  final ConvertouchCommonStateBuilt globalState;
  final Widget body;
  final String title;
  final List<Widget>? appBarRightWidgets;
  final Widget? secondaryAppBar;
  final Color? secondaryAppBarColor;
  final double appBarPadding;
  final Widget? floatingActionButton;
  final void Function()? onItemsRemove;

  const ConvertouchPage({
    required this.globalState,
    required this.body,
    required this.title,
    this.appBarRightWidgets,
    this.secondaryAppBar,
    this.secondaryAppBarColor,
    this.appBarPadding = 7,
    this.floatingActionButton,
    this.onItemsRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ConvertouchScaffoldColor scaffoldColor = scaffoldColors[globalState.theme]!;
    FloatingButtonColorVariation removalButtonColor =
        removalFloatingButtonColors[globalState.theme]!;

    return Scaffold(
      backgroundColor: scaffoldColor.regular.backgroundColor,
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            if (globalState.removalMode) {
              return leadingIcon(
                icon: Icons.clear,
                onClick: () {
                  // BlocProvider.of<AppBloc>(context).add(
                  //   DisableRemovalMode(
                  //     currentPageId: appState.pageId,
                  //     pageTitle: appState.pageTitle,
                  //     floatingButtonVisible:
                  //     appState.floatingButtonVisible,
                  //     uiTheme: appState.theme,
                  //   ),
                  // );
                },
              );
            } else if (globalState.prevState != null) {
              return leadingIcon(
                icon: Icons.arrow_back_rounded,
                onClick: () {},
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
              height: 53,
              decoration: BoxDecoration(
                color: secondaryAppBarColor ?? scaffoldColor.regular.appBarColor,
              ),
              padding: EdgeInsetsDirectional.fromSTEB(
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
      floatingActionButton: globalState.removalMode
          ? ConvertouchFloatingActionButton.removal(
              extraLabelText:
                  globalState.selectedItemIdsForRemoval.length.toString(),
              background: removalButtonColor.background,
              foreground: removalButtonColor.foreground,
              border: scaffoldColor.regular.backgroundColor,
            )
          : floatingActionButton,
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
              NavigationService.I.navigateBack();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

Widget checkIcon(
  BuildContext context, {
  bool isVisible = true,
  bool isEnabled = false,
  void Function()? onPressedFunc,
  required ConvertouchScaffoldColor color,
}) {
  return Visibility(
    visible: isVisible,
    child: IconButton(
      icon: Icon(
        Icons.check,
        color: isEnabled ? color.regular.appBarIconColor : null,
      ),
      disabledColor: color.regular.appBarIconColorDisabled,
      onPressed: isEnabled ? onPressedFunc : null,
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
