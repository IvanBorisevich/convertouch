import 'package:convertouch/presentation/bloc/base_state.dart';
import 'package:convertouch/presentation/pages/scaffold/navigation_service.dart';
import 'package:convertouch/presentation/pages/style/colors.dart';
import 'package:convertouch/presentation/pages/style/model/color.dart';
import 'package:convertouch/presentation/pages/style/model/color_variation.dart';
import 'package:flutter/material.dart';

abstract class ConvertouchPage extends StatelessWidget {
  const ConvertouchPage({super.key});

  void onStart(BuildContext context);
  Widget buildFloatingActionButton(BuildContext context);
  List<Widget>? buildAppBarRightIcons(BuildContext context) {
    return [];
  }
  PreferredSizeWidget buildAppBar(BuildContext context);

  PreferredSizeWidget buildAppBarForState(BuildContext context, ConvertouchPageState pageState,) {
    ConvertouchScaffoldColor commonColor = scaffoldColor[pageState.theme]!;

    return AppBar(
      leading: Builder(
        builder: (context) {
          if (pageState.removalMode) {
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
          } else if (!NavigationService.I.isStartPage(context)) {
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
        pageState.pageTitle,
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

Widget empty() {
  return const SizedBox(
    height: 0,
    width: 0,
  );
}
