import 'package:app_settings/app_settings.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/main.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_states.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_events.dart';
import 'package:convertouch/presentation/ui/pages/conversion_groups_page.dart';
import 'package:convertouch/presentation/ui/pages/conversion_page.dart';
import 'package:convertouch/presentation/ui/pages/error_page.dart';
import 'package:convertouch/presentation/ui/pages/refreshing_job_details_page.dart';
import 'package:convertouch/presentation/ui/pages/settings_page.dart';
import 'package:convertouch/presentation/ui/pages/unit_details_page.dart';
import 'package:convertouch/presentation/ui/pages/unit_group_details_page.dart';
import 'package:convertouch/presentation/ui/pages/unit_groups_page_for_unit_details.dart';
import 'package:convertouch/presentation/ui/pages/units_page_for_conversion.dart';
import 'package:convertouch/presentation/ui/pages/units_page_for_unit_details.dart';
import 'package:convertouch/presentation/ui/pages/units_page_regular.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchScaffold extends StatefulWidget {
  const ConvertouchScaffold({super.key});

  @override
  State createState() => _ConvertouchScaffoldState();
}

class _ConvertouchScaffoldState extends State<ConvertouchScaffold> {
  final _screenNavigatorKeys = {
    BottomNavbarItem.home: GlobalKey<NavigatorState>(),
    BottomNavbarItem.settings: GlobalKey<NavigatorState>(),
  };

  static final _navBarIcons = {
    BottomNavbarItem.home: const Icon(Icons.home_outlined),
    BottomNavbarItem.settings: const Icon(Icons.settings_outlined),
  };

  static final _navBarIconsSelected = {
    BottomNavbarItem.home: const Icon(Icons.home_rounded),
    BottomNavbarItem.settings: const Icon(Icons.settings_rounded),
  };

  static const _navBarLabels = {
    BottomNavbarItem.home: "Home",
    BottomNavbarItem.settings: "Settings",
  };

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    logger.d("Scaffold initialized");
  }

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder(
      builderFunc: (appState) {
        PageColorScheme pageColorScheme = pageColors[appState.theme]!;

        return BlocConsumer<NavigationBloc, NavigationState>(
          listenWhen: (prev, next) {
            return prev != next && next is NavigationDone;
          },
          listener: (_, state) {
            if (state is NavigationDone) {
              GlobalKey<NavigatorState> navKey =
                  _screenNavigatorKeys[state.selectedNavbarItem]!;

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
              BottomNavbarItem selectedItem = state.selectedNavbarItem;
              return WillPopScope(
                onWillPop: () async {
                  final isFirstRouteInSelectedNavbarItem =
                      !await _screenNavigatorKeys[selectedItem]!
                          .currentState!
                          .maybePop();
                  if (isFirstRouteInSelectedNavbarItem) {
                    if (selectedItem != BottomNavbarItem.home) {
                      BlocProvider.of<NavigationBloc>(
                              _screenNavigatorKeys[selectedItem]!
                                  .currentContext!)
                          .add(
                        SelectBottomNavbarItem(
                          targetItem: BottomNavbarItem.home,
                          selectedItem: selectedItem,
                        ),
                      );
                      return false;
                    }
                  }
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
                          rootPageId: PageName.conversionGroupsPage,
                          selected: selectedItem == BottomNavbarItem.home,
                          routesMap: {
                            PageName.conversionPage.name:
                                const ConvertouchConversionPage(),
                            PageName.conversionGroupsPage.name:
                                const ConversionGroupsPage(),
                            PageName.unitsPageForConversion.name:
                                const ConvertouchUnitsPageForConversion(),
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
                          bottomNavbarItem: BottomNavbarItem.settings,
                          selectedItem: selectedItem,
                        ),
                      ],
                      onTap: (index) {
                        BlocProvider.of<NavigationBloc>(context).add(
                          SelectBottomNavbarItem(
                            targetItem: BottomNavbarItem.values[index],
                            selectedItem: selectedItem,
                          ),
                        );
                      },
                      currentIndex: selectedItem.index,
                      elevation: 0,
                      selectedFontSize: 12,
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
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  BottomNavigationBarItem _buildNavbarItem({
    required BottomNavbarItem bottomNavbarItem,
    required BottomNavbarItem selectedItem,
  }) {
    return BottomNavigationBarItem(
      icon: bottomNavbarItem == selectedItem
          ? _navBarIconsSelected[bottomNavbarItem]!
          : _navBarIcons[bottomNavbarItem]!,
      label: _navBarLabels[bottomNavbarItem],
    );
  }

  void showSnackBar(
    BuildContext context, {
    required ConvertouchException exception,
    required ConvertouchUITheme theme,
    int durationInSec = 2,
  }) {
    SnackBarColorScheme snackBarColor = pageColors[theme]!.snackBar;

    Color foreground;
    switch (exception.severity) {
      case ExceptionSeverity.warning:
        foreground = snackBarColor.foregroundWarning.regular;
        break;
      case ExceptionSeverity.error:
        foreground = snackBarColor.foregroundError.regular;
        break;
      case ExceptionSeverity.info:
        foreground = snackBarColor.foregroundInfo.regular;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        showCloseIcon: exception.handlingAction == null,
        closeIconColor: foreground,
        backgroundColor: snackBarColor.background.regular,
        duration: Duration(seconds: durationInSec),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(7),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        action: exception.handlingAction != null
            ? SnackBarAction(
                label: exception.handlingAction!.label,
                textColor: snackBarColor.action.regular,
                onPressed: _snackBarActions[exception.handlingAction!] ?? () {},
              )
            : null,
        content: Text(
          exception.message,
          style: TextStyle(
            color: foreground,
            fontFamily: quicksandFontFamily,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

final Map<ConvertouchSysAction, void Function()> _snackBarActions = {
  ConvertouchSysAction.connection: () {
    AppSettings.openAppSettings(
      type: AppSettingsType.wireless,
      asAnotherTask: true,
    );
  },
};
