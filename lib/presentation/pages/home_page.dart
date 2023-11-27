import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/pages/abstract_page.dart';
import 'package:convertouch/presentation/pages/scaffold/app_bar.dart';
import 'package:convertouch/presentation/pages/style/colors.dart';
import 'package:convertouch/presentation/pages/style/model/color.dart';
import 'package:convertouch/presentation/pages/unit_groups_page.dart';
import 'package:convertouch/presentation/pages/units_conversion_page.dart';
import 'package:convertouch/presentation/pages/units_page.dart';
import 'package:flutter/material.dart';

class ConvertouchHomePage extends StatefulWidget {
  final Widget? appBarLeftWidget;
  final void Function()? onClickForAdd;
  final void Function()? onClickForRemove;
  final double appBarPadding;
  final ConvertouchScaffoldColor? customColor;

  const ConvertouchHomePage({
    this.appBarLeftWidget,
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
    // Icons.menu_outlined,
  ];

  static const List<IconData> bottomNavBarIconsSelected = [
    Icons.home_rounded,
    Icons.dashboard_customize_rounded,
    // Icons.menu_rounded,
  ];

  static const Map<String, ConvertouchPage> pages = {
    unitsConversionPageId: ConvertouchUnitsConversionPage(),
    unitGroupsPageId: ConvertouchUnitGroupsPage(),
    unitsPageId: ConvertouchUnitsPage(),
  };

  static const List<String> startPages = [
    unitsConversionPageId,
    unitGroupsPageId,
  ];

  int _selectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return commonBloc((commonState) {
      String selectedPageId;
      if (commonState.prevState == null) {
        selectedPageId = startPages[_selectedPageIndex];
      } else {
        selectedPageId = commonState.pageId;
      }

      ConvertouchPage selectedPage = pages[selectedPageId]!;
      selectedPage.onStart(context);

      ConvertouchScaffoldColor commonColor = scaffoldColors[commonState.theme]!;

      return SafeArea(
        child: GestureDetector(
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: commonColor.regular.backgroundColor,
                appBar: ConvertouchAppBar(
                  content: selectedPage.buildAppBar(context, commonState),
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
                floatingActionButton: selectedPage.buildFloatingActionButton(
                    context, commonState),
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
