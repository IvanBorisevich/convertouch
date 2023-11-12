import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/app/app_events.dart';
import 'package:convertouch/presentation/bloc/side_menu/side_menu_bloc.dart';
import 'package:convertouch/presentation/bloc/side_menu/side_menu_events.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/pages/scaffold/navigation_service.dart';
import 'package:convertouch/presentation/pages/scaffold/side_menu.dart';
import 'package:convertouch/presentation/pages/style/colors.dart';
import 'package:convertouch/presentation/pages/style/model/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchScaffold extends StatelessWidget {
  final Widget body;
  final ConvertouchUITheme theme;
  final Widget? appBarLeftWidget;
  final String pageTitle;
  final List<Widget>? appBarRightWidgets;
  final Widget? secondaryAppBar;
  final Widget? floatingActionButton;
  final bool floatingActionButtonVisible;
  final void Function()? onFloatingButtonForRemovalClick;
  final double appBarPadding;
  final ConvertouchScaffoldColor? customColor;

  const ConvertouchScaffold({
    required this.body,
    this.theme = ConvertouchUITheme.light,
    this.appBarLeftWidget,
    this.pageTitle = appName,
    this.appBarRightWidgets,
    this.secondaryAppBar,
    this.floatingActionButton,
    this.floatingActionButtonVisible = false,
    this.onFloatingButtonForRemovalClick,
    this.appBarPadding = 7,
    this.customColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ConvertouchScaffoldColor color = customColor ?? scaffoldColor[theme]!;

    return appBloc((appState) {
      return SafeArea(
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.velocity.pixelsPerSecond.dx > 0) {
              BlocProvider.of<SideMenuBloc>(context).add(
                const OpenSideMenu(),
              );
            }
          },
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: color.regular.backgroundColor,
                appBar: AppBar(
                  leading: Builder(
                    builder: (context) {
                      if (appBarLeftWidget != null) {
                        return appBarLeftWidget!;
                      }
                      if (appState.removalMode) {
                        return _leadingIcon(
                          Icons.clear,
                          () {
                            BlocProvider.of<AppBloc>(context).add(
                              const DisableRemovalMode(),
                            );
                          },
                          color,
                        );
                      } else if (NavigationService.I.isHomePage(context)) {
                        return _leadingIcon(
                          Icons.menu,
                          () {
                            BlocProvider.of<SideMenuBloc>(context).add(
                              const OpenSideMenu(),
                            );
                          },
                          color,
                        );
                      } else {
                        return _leadingIcon(
                          Icons.arrow_back_rounded,
                          () {
                            NavigationService.I.navigateBack();
                          },
                          color,
                        );
                      }
                    },
                  ),
                  centerTitle: true,
                  title: Text(
                    pageTitle,
                    style: TextStyle(
                      color: color.regular.appBarFontColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: color.regular.appBarColor,
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
                          color: color.regular.appBarColor,
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
                floatingActionButton: Visibility(
                  visible: floatingActionButtonVisible,
                  child: SizedBox(
                    height: 68,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        FittedBox(
                          child: appState.removalMode
                              ? _floatingActionButtonForRemoval(
                                  onClick: onFloatingButtonForRemovalClick,
                                )
                              : floatingActionButton,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            decoration: BoxDecoration(
                              color: removalFloatingButtonColor[theme],
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: color.regular.backgroundColor,
                                width: 2,
                                strokeAlign: BorderSide.strokeAlignOutside,
                              ),
                            ),
                            child: appState.selectedItemIdsForRemoval.isNotEmpty
                                ? Text(
                                    appState.selectedItemIdsForRemoval.length
                                        .toString(),
                                    style: TextStyle(
                                      color: color.regular.backgroundColor,
                                      fontSize: 14,
                                    ),
                                  )
                                : empty(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const ConvertouchSideMenu(),
            ],
          ),
        ),
      );
    });
  }

  Widget _leadingIcon(
    IconData iconData,
    void Function()? onPressed,
    ConvertouchScaffoldColor color,
  ) {
    return IconButton(
      icon: Icon(
        iconData,
        color: color.regular.appBarIconColor,
      ),
      onPressed: onPressed,
    );
  }

  Widget _floatingActionButtonForRemoval({void Function()? onClick}) {
    return FloatingActionButton(
      onPressed: onClick,
      backgroundColor: removalFloatingButtonColor[theme],
      elevation: 0,
      child: const Icon(Icons.delete_outline_rounded),
    );
  }
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
