import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/base_bloc.dart';
import 'package:convertouch/presentation/bloc/base_state.dart';
import 'package:convertouch/presentation/pages/abstract_page.dart';
import 'package:convertouch/presentation/pages/style/colors.dart';
import 'package:convertouch/presentation/pages/style/model/color.dart';
import 'package:convertouch/presentation/pages/units_conversion_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    unitGroupsPageId: ConvertouchUnitsConversionPage(),
    unitGroupCreationPageId: ConvertouchUnitsConversionPage(),
    unitsPageId: ConvertouchUnitsConversionPage(),
    unitCreationPageId: ConvertouchUnitsConversionPage(),
  };

  int _selectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
      return BlocBuilder<ConvertouchPageBloc, ConvertouchPageState>(
        builder: (_, pageState) {
          ConvertouchPage selectedPage = pages[pageState.pageId]!;
          ConvertouchScaffoldColor commonColor = scaffoldColor[pageState.theme]!;
          selectedPage.onStart(context);

          return SafeArea(
            child: GestureDetector(
              child: Stack(
                children: [
                  Scaffold(
                    backgroundColor: commonColor.regular.backgroundColor,
                    appBar: selectedPage.buildAppBar(context),
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
                    floatingActionButton: selectedPage.buildFloatingActionButton(context),
                  ),
                  // ConvertouchSideMenu(
                  //   theme: appState.theme,
                  // ),
                ],
              ),
            ),
          );
        },
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
