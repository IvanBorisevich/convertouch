import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/main.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_states.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_events.dart';
import 'package:convertouch/presentation/ui/pages/conversion_page.dart';
import 'package:convertouch/presentation/ui/pages/error_page.dart';
import 'package:convertouch/presentation/ui/pages/refreshing_job_details_page.dart';
import 'package:convertouch/presentation/ui/pages/settings_page.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/pages/unit_details_page.dart';
import 'package:convertouch/presentation/ui/pages/unit_group_details_page.dart';
import 'package:convertouch/presentation/ui/pages/unit_groups_page_for_conversion.dart';
import 'package:convertouch/presentation/ui/pages/unit_groups_page_for_unit_details.dart';
import 'package:convertouch/presentation/ui/pages/unit_groups_page_regular.dart';
import 'package:convertouch/presentation/ui/pages/units_page_for_conversion.dart';
import 'package:convertouch/presentation/ui/pages/units_page_for_unit_details.dart';
import 'package:convertouch/presentation/ui/pages/units_page_regular.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class ConvertouchScaffold extends StatefulWidget {
  const ConvertouchScaffold({super.key});

  @override
  State createState() => _ConvertouchScaffoldState();
}

class _ConvertouchScaffoldState extends State<ConvertouchScaffold> {
  final _screenNavigatorKeys = {
    BottomNavbarItem.home: GlobalKey<NavigatorState>(),
    BottomNavbarItem.unitsEditor: GlobalKey<NavigatorState>(),
    BottomNavbarItem.settings: GlobalKey<NavigatorState>(),
  };

  static const _navBarIcons = {
    BottomNavbarItem.home: Icons.home_outlined,
    BottomNavbarItem.unitsEditor: Icons.dashboard_customize_outlined,
    BottomNavbarItem.settings: Icons.settings_outlined,
  };

  static const _navBarIconsSelected = {
    BottomNavbarItem.home: Icons.home_rounded,
    BottomNavbarItem.unitsEditor: Icons.dashboard_customize_rounded,
    BottomNavbarItem.settings: Icons.settings_rounded,
  };

  static const _navBarLabels = {
    BottomNavbarItem.home: "Home",
    BottomNavbarItem.unitsEditor: "Units Editor",
    BottomNavbarItem.settings: "Settings",
  };

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    FlutterNativeSplash.remove();
    logger.d("Scaffold initialized");
  }

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      PageColorScheme pageColorScheme = pageColors[appState.theme]!;

      return BlocConsumer<NavigationBloc, NavigationState>(
        listenWhen: (prev, next) {
          return prev != next && next is NavigationDone;
        },
        listener: (_, state) {
          if (state is NavigationDone) {
            GlobalKey<NavigatorState> navKey =
                _screenNavigatorKeys[state.bottomNavbarItem]!;

            if (state.nextPageName != null && state.exception == null) {
              navKey.currentState?.pushNamed(state.nextPageName!.name);
            } else if (state.exception != null && state.exception!.isError) {
              navKey.currentState?.push(
                MaterialPageRoute(
                  builder: (context) => ConvertouchErrorPage(
                    error: state.exception!,
                  ),
                ),
              );
            } else if (state.exception != null && !state.exception!.isError) {
              showSnackBar(
                context,
                exception: state.exception!,
                theme: appState.theme,
              );
            } else if (state.navigateBack && !state.navigateBackToRoot) {
              navKey.currentState?.pop();
            } else if (state.navigateBack && state.navigateBackToRoot) {
              navKey.currentState?.popUntil(
                (route) => route.isFirst,
              );
            }
          }
        },
        builder: (_, state) {
          if (state is NavigationDone) {
            BottomNavbarItem selectedItem = state.bottomNavbarItem;
            return WillPopScope(
              onWillPop: () async {
                final isFirstRouteInSelectedNavbarItem =
                    !await _screenNavigatorKeys[selectedItem]!
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
                            _screenNavigatorKeys[BottomNavbarItem.home],
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
                            _screenNavigatorKeys[BottomNavbarItem.unitsEditor],
                        bottomNavbarItem: BottomNavbarItem.unitsEditor,
                        rootPageId: PageName.unitGroupsPageRegular,
                        selected: selectedItem == BottomNavbarItem.unitsEditor,
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
                            _screenNavigatorKeys[BottomNavbarItem.settings],
                        bottomNavbarItem: BottomNavbarItem.settings,
                        rootPageId: PageName.settingsPage,
                        selected: selectedItem == BottomNavbarItem.settings,
                        routesMap: {
                          PageName.settingsPage.name:
                              const ConvertouchSettingsPage(),
                          PageName.refreshingJobDetailsPage.name:
                              const ConvertouchRefreshingJobDetailsPage(),
                        },
                        onInit: () {
                          BlocProvider.of<RefreshingJobsBloc>(context).add(
                            const FetchRefreshingJobs(),
                          );
                        },
                      ),
                    ],
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    items: [
                      _buildNavbarItem(
                        bottomNavbarItem: BottomNavbarItem.home,
                        selectedItem: selectedItem,
                      ),
                      _buildNavbarItem(
                        bottomNavbarItem: BottomNavbarItem.unitsEditor,
                        selectedItem: selectedItem,
                      ),
                      _buildNavbarItem(
                        bottomNavbarItem: BottomNavbarItem.settings,
                        selectedItem: selectedItem,
                      ),
                    ],
                    onTap: (index) {
                      BlocProvider.of<NavigationBloc>(context).add(
                        SelectBottomNavbarItem(
                          bottomNavbarItem: BottomNavbarItem.values[index],
                        ),
                      );
                    },
                    currentIndex: selectedItem.index,
                    elevation: 0,
                    backgroundColor:
                        pageColorScheme.bottomBar.background.regular,
                    unselectedItemColor:
                        pageColorScheme.bottomBar.foreground.regular,
                    selectedItemColor:
                        pageColorScheme.bottomBar.foreground.selected,
                  ),
                ),
              ),
            );
          }
          return empty();
        },
      );
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
