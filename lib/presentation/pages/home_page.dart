import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/app/app_events.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/pages/abstract_page.dart';
import 'package:convertouch/presentation/pages/scaffold/navigation_service.dart';
import 'package:convertouch/presentation/pages/style/colors.dart';
import 'package:convertouch/presentation/pages/style/model/color.dart';
import 'package:convertouch/presentation/pages/style/model/color_variation.dart';
import 'package:convertouch/presentation/pages/units_conversion_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchHomePage extends StatefulWidget {
  final Widget? appBarLeftWidget;
  final String pageTitle;
  final List<Widget>? appBarRightWidgets;
  final void Function()? onClickForAdd;
  final void Function()? onClickForRemove;
  final double appBarPadding;
  final ConvertouchScaffoldColor? customColor;

  const ConvertouchHomePage({
    this.appBarLeftWidget,
    this.pageTitle = appName,
    this.appBarRightWidgets,
    this.onClickForAdd,
    this.onClickForRemove,
    this.appBarPadding = 7,
    this.customColor,
    super.key,
  });

  @override
  State createState() => _ConvertouchHomePageState();
}

class _ConvertouchHomePageState extends State<ConvertouchHomePage> {
  static const List<IconData> bottomNavBarIcons = [
    Icons.home_outlined,
    Icons.dashboard_customize_outlined,
    Icons.menu_outlined,
  ];

  static const List<IconData> bottomNavBarIconsSelected = [
    Icons.home_rounded,
    Icons.dashboard_customize_rounded,
    Icons.menu_rounded,
  ];

  static const Map<String, ConvertouchPage> pages = {
    unitsConversionPageId: ConvertouchUnitsConversionPage(),
    unitGroupsPageId: ConvertouchUnitsConversionPage(),
    unitGroupCreationPageId: ConvertouchUnitsConversionPage(),
    unitsPageId: ConvertouchUnitsConversionPage(),
    unitCreationPageId: ConvertouchUnitsConversionPage(),
  };

  int _selectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return appBloc((appState) {
      FloatingButtonColorVariation removalButtonColor =
          removalFloatingButtonColor[appState.theme]!;
      ConvertouchScaffoldColor commonColor = scaffoldColor[appState.theme]!;

      ConvertouchPage selectedPage = pages[appState.pageId]!;
      selectedPage.onStart(context, appState);

      return SafeArea(
        child: GestureDetector(
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: commonColor.regular.backgroundColor,
                appBar: AppBar(
                  leading: Builder(
                    builder: (context) {
                      if (appState.removalMode) {
                        return leadingIcon(
                          icon: Icons.clear,
                          onClick: () {
                            BlocProvider.of<AppBloc>(context).add(
                              DisableRemovalMode(
                                currentPageId: appState.pageId,
                                pageTitle: appState.pageTitle,
                                floatingButtonVisible:
                                    appState.floatingButtonVisible,
                                uiTheme: appState.theme,
                              ),
                            );
                          },
                        );
                      } else if (!NavigationService.I.isStartPage(context)) {
                        return leadingIcon(
                          icon: Icons.arrow_back_rounded,
                          onClick: () {
                            NavigationService.I.navigateBack();
                          },
                        );
                      } else {
                        return empty();
                      }
                    },
                  ),
                  centerTitle: true,
                  title: Text(
                    appState.pageTitle,
                    style: TextStyle(
                      color: commonColor.regular.appBarFontColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: commonColor.regular.appBarColor,
                  elevation: 0,
                  actions: widget.appBarRightWidgets,
                ),
                body: selectedPage,
                bottomNavigationBar: Container(
                  height: 53,
                  decoration: BoxDecoration(
                    color: commonColor.regular.appBarColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < bottomNavBarIcons.length; i++)
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: IconButton(
                              icon: Icon(
                                i == _selectedPageIndex
                                    ? bottomNavBarIconsSelected[i]
                                    : bottomNavBarIcons[i],
                                color: commonColor.regular.appBarIconColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedPageIndex = i;
                                });
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                floatingActionButton: Visibility(
                  visible: appState.floatingButtonVisible,
                  child: SizedBox(
                    height: 70,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        FittedBox(
                          child: appState.removalMode
                              ? selectedPage.buildButtonToRemove(
                                  context, appState)
                              : selectedPage.buildButtonToAdd(
                                  context, appState),
                        ),
                        appState.removalMode
                            ? _itemsRemovalCounter(
                                itemsCount:
                                    appState.selectedItemIdsForRemoval.length,
                                backgroundColor: removalButtonColor.background,
                                foregroundColor: removalButtonColor.foreground,
                                borderColor:
                                    commonColor.regular.backgroundColor,
                              )
                            : empty(),
                      ],
                    ),
                  ),
                ),
              ),
              // ConvertouchSideMenu(
              //   theme: appState.theme,
              // ),
            ],
          ),
        ),
      );
    });
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

Widget _itemsRemovalCounter({
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
