import 'package:convertouch/presentation/bloc/base_state.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/pages/scaffold/navigation_service.dart';
import 'package:convertouch/presentation/pages/style/colors.dart';
import 'package:convertouch/presentation/pages/style/model/color.dart';
import 'package:convertouch/presentation/pages/style/model/color_variation.dart';
import 'package:flutter/material.dart';

abstract class ConvertouchPage extends StatelessWidget {
  const ConvertouchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return commonBloc((commonState) {
      return buildBody(context, commonState);
    });
  }

  void onStart(BuildContext context);

  Widget buildAppBar(
    BuildContext context,
    ConvertouchCommonStateBuilt commonState,
  );

  Widget buildBody(
    BuildContext context,
    ConvertouchCommonStateBuilt commonState,
  );

  Widget buildFloatingActionButton(
    BuildContext context,
    ConvertouchCommonStateBuilt commonState,
  );

  List<Widget>? buildAppBarRightIcons(BuildContext context) {
    return [];
  }

  Widget buildAppBarForState(
    BuildContext context,
    ConvertouchCommonStateBuilt commonState, {
    required String pageTitle,
  }) {
    ConvertouchScaffoldColor commonColor = scaffoldColors[commonState.theme]!;

    return AppBar(
      leading: Builder(
        builder: (context) {
          if (commonState.removalMode) {
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
          } else if (commonState.prevState != null) {
            return leadingIcon(
              icon: Icons.arrow_back_rounded,
              onClick: () {
                //NavigationService.I.navigateBack();
              },
            );
          } else {
            return empty();
          }
        },
      ),
      centerTitle: true,
      title: Text(
        pageTitle,
        style: TextStyle(
          color: commonColor.regular.appBarFontColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: commonColor.regular.appBarColor,
      elevation: 0,
      actions: buildAppBarRightIcons(context),
    );
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

Widget itemsRemovalCounter({
  required int itemsCount,
  required Color backgroundColor,
  required Color foregroundColor,
  required Color borderColor,
}) {
  return Align(
    alignment: Alignment.topRight,
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: borderColor,
          width: 1,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: Text(
        itemsCount.toString(),
        style: TextStyle(
          color: foregroundColor,
          fontSize: 14,
        ),
      ),
    ),
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
