import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_states.dart';
import 'package:convertouch/presentation/ui/pages/conversion_page.dart';
import 'package:convertouch/presentation/ui/pages/refreshing_job_details_page.dart';
import 'package:convertouch/presentation/ui/pages/settings_page.dart';
import 'package:convertouch/presentation/ui/pages/unit_details_page.dart';
import 'package:convertouch/presentation/ui/pages/unit_group_details_page.dart';
import 'package:convertouch/presentation/ui/pages/unit_groups_page_for_conversion.dart';
import 'package:convertouch/presentation/ui/pages/unit_groups_page_for_unit_details.dart';
import 'package:convertouch/presentation/ui/pages/unit_groups_page_regular.dart';
import 'package:convertouch/presentation/ui/pages/units_page_for_conversion.dart';
import 'package:convertouch/presentation/ui/pages/units_page_for_unit_details.dart';
import 'package:convertouch/presentation/ui/pages/units_page_regular.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/root_screen.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchScaffold extends StatefulWidget {
  const ConvertouchScaffold({super.key});

  @override
  State createState() => _ConvertouchScaffoldState();
}

class _ConvertouchScaffoldState extends State<ConvertouchScaffold> {
  final _bottomBarNavigatorKeys = {
    BottomNavbarItem.home: GlobalKey<NavigatorState>(),
    BottomNavbarItem.unitsMenu: GlobalKey<NavigatorState>(),
    BottomNavbarItem.settings: GlobalKey<NavigatorState>(),
  };

  static const _navBarIcons = {
    BottomNavbarItem.home: Icons.home_outlined,
    BottomNavbarItem.unitsMenu: Icons.dashboard_customize_outlined,
    BottomNavbarItem.settings: Icons.settings_outlined,
  };

  static const _navBarIconsSelected = {
    BottomNavbarItem.home: Icons.home_rounded,
    BottomNavbarItem.unitsMenu: Icons.dashboard_customize_rounded,
    BottomNavbarItem.settings: Icons.settings_rounded,
  };

  static const _navBarLabels = {
    BottomNavbarItem.home: "Home",
    BottomNavbarItem.unitsMenu: "Units Menu",
    BottomNavbarItem.settings: "Settings",
  };

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      PageColorScheme pageColorScheme = pageColors[appState.theme]!;

      return BlocBuilder<NavigationBloc, NavigationState>(
          builder: (_, navigationState) {
        BottomNavbarItem selectedItem = navigationState.bottomNavbarItem;

        return WillPopScope(
          onWillPop: () async {
            final isFirstRouteInSelectedNavbarItem =
                !await _bottomBarNavigatorKeys[selectedItem]!
                    .currentState!
                    .maybePop();
            return isFirstRouteInSelectedNavbarItem;
          },
          child: SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  ConvertouchRootScreen(
                    navigatorKey:
                        _bottomBarNavigatorKeys[BottomNavbarItem.home],
                    bottomNavbarItem: BottomNavbarItem.home,
                    rootPageId: PageName.unitsConversionPage,
                    selected: selectedItem == BottomNavbarItem.home,
                    routesMap: {
                      PageName.unitsConversionPage.name:
                          const ConvertouchConversionPage(),
                      PageName.unitGroupsPageForConversion.name:
                          const ConvertouchUnitGroupsPageForConversion(),
                      PageName.unitsPageForConversion.name:
                          const ConvertouchUnitsPageForConversion(),
                    },
                  ),
                  ConvertouchRootScreen(
                    navigatorKey:
                        _bottomBarNavigatorKeys[BottomNavbarItem.unitsMenu],
                    bottomNavbarItem: BottomNavbarItem.unitsMenu,
                    rootPageId: PageName.unitGroupsPageRegular,
                    selected: selectedItem == BottomNavbarItem.unitsMenu,
                    routesMap: {
                      PageName.unitGroupsPageRegular.name:
                          const ConvertouchUnitGroupsPageRegular(),
                      PageName.unitsPageRegular.name:
                          const ConvertouchUnitsPageRegular(),
                      PageName.unitGroupsPageForUnitDetails.name:
                          const ConvertouchUnitGroupsPageForUnitDetails(),
                      PageName.unitsPageForUnitDetails.name:
                          const ConvertouchUnitsPageForUnitDetails(),
                      PageName.unitGroupDetailsPage.name:
                          const ConvertouchUnitGroupDetailsPage(),
                      PageName.unitDetailsPage.name:
                          const ConvertouchUnitDetailsPage(),
                    },
                  ),
                  ConvertouchRootScreen(
                    navigatorKey:
                        _bottomBarNavigatorKeys[BottomNavbarItem.settings],
                    bottomNavbarItem: BottomNavbarItem.settings,
                    rootPageId: PageName.settingsPage,
                    selected: selectedItem == BottomNavbarItem.settings,
                    routesMap: {
                      PageName.settingsPage.name:
                          const ConvertouchSettingsPage(),
                      PageName.refreshingJobDetailsPage.name:
                          const ConvertouchRefreshingJobDetailsPage(),
                    },
                  ),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: [
                  _buildNavbarItem(
                    bottomNavbarItem: BottomNavbarItem.home,
                    selectedItem: navigationState.bottomNavbarItem,
                  ),
                  _buildNavbarItem(
                    bottomNavbarItem: BottomNavbarItem.unitsMenu,
                    selectedItem: navigationState.bottomNavbarItem,
                  ),
                  _buildNavbarItem(
                    bottomNavbarItem: BottomNavbarItem.settings,
                    selectedItem: navigationState.bottomNavbarItem,
                  ),
                ],
                onTap: (index) {
                  BlocProvider.of<NavigationBloc>(context).add(
                    SelectBottomNavbarItem(
                      bottomNavbarItem: BottomNavbarItem.values[index],
                    ),
                  );
                },
                currentIndex: navigationState.bottomNavbarItem.index,
                elevation: 0,
                backgroundColor: pageColorScheme.bottomBar.regular.background,
                unselectedItemColor:
                    pageColorScheme.bottomBar.regular.foreground,
                selectedItemColor:
                    pageColorScheme.bottomBar.selected?.foreground,
              ),
            ),
          ),
        );
      });
    });
  }

  BottomNavigationBarItem _buildNavbarItem({
    required BottomNavbarItem bottomNavbarItem,
    required BottomNavbarItem selectedItem,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(
        bottomNavbarItem == selectedItem
            ? _navBarIconsSelected[bottomNavbarItem]
            : _navBarIcons[bottomNavbarItem],
      ),
      label: _navBarLabels[bottomNavbarItem],
    );
  }
}
