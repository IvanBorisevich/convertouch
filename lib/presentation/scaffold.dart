import 'package:app_settings/app_settings.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/main.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/input_validation/input_validation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_list/items_list_events.dart';
import 'package:convertouch/presentation/bloc/common/items_list/list_values_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_states.dart';
import 'package:convertouch/presentation/bloc/common/refresh_button/refresh_button_bloc.dart';
import 'package:convertouch/presentation/bloc/common/root_screen/root_screen_bloc.dart';
import 'package:convertouch/presentation/bloc/common/root_screen/root_screen_events.dart';
import 'package:convertouch/presentation/bloc/common/root_screen/root_screen_states.dart';
import 'package:convertouch/presentation/bloc/common/sliding_panel_bloc/sliding_panel_bloc.dart';
import 'package:convertouch/presentation/bloc/common/tooltip/tooltip_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_item/conversion_item_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_param_sets_page/conversion_param_sets_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_param_sets_page/single_param_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_events.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/single_group_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/ui/pages/conversion_groups_page.dart';
import 'package:convertouch/presentation/ui/pages/conversion_page.dart';
import 'package:convertouch/presentation/ui/pages/conversion_param_sets_page.dart';
import 'package:convertouch/presentation/ui/pages/error_page.dart';
import 'package:convertouch/presentation/ui/pages/settings_page.dart';
import 'package:convertouch/presentation/ui/pages/unit_details_page.dart';
import 'package:convertouch/presentation/ui/pages/unit_group_details_page.dart';
import 'package:convertouch/presentation/ui/pages/unit_groups_page_for_unit_details.dart';
import 'package:convertouch/presentation/ui/pages/units_page_for_conversion.dart';
import 'package:convertouch/presentation/ui/pages/units_page_for_conversion_params.dart';
import 'package:convertouch/presentation/ui/pages/units_page_for_unit_details.dart';
import 'package:convertouch/presentation/ui/pages/units_page_regular.dart';
import 'package:convertouch/presentation/ui/style/color/colors_factory.dart';
import 'package:convertouch/presentation/ui/style/color/model/widget_color_scheme.dart';
import 'package:convertouch/presentation/ui/widgets/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.locator<RefreshButtonBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<InputValidationBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<ConvertouchTooltipBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<SlidingPanelBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<NavigationBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<RootScreenBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<ItemsSelectionBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<ItemsSelectionBlocForUnitDetails>(),
        ),
        BlocProvider(
          create: (context) => di.locator<ListValuesBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<ConversionBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<ConversionUnitValueBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<ConversionParamValueBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<UnitGroupsBloc>()
            ..add(
              const FetchItems<UnitGroupsFetchParams>(),
            ),
        ),
        BlocProvider(
          create: (context) => di.locator<SingleGroupBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<UnitGroupsBlocForUnitDetails>(),
        ),
        BlocProvider(
          create: (context) => di.locator<UnitsBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<UnitsBlocForUnitDetails>(),
        ),
        BlocProvider(
          create: (context) => di.locator<UnitDetailsBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<UnitGroupDetailsBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<RefreshingJobsBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<ConversionParamSetsBloc>(),
        ),
        BlocProvider(
          create: (context) => di.locator<SingleParamBloc>(),
        ),
      ],
      child: appBlocBuilder(
        builderFunc: (appState) {
          PageColorScheme pageColorScheme = appColors[appState.theme].page;

          return BlocBuilder<RootScreenBloc, RootScreenState>(
            builder: (context, state) {
              BottomNavbarItem selectedItem = state.selectedNavbarItem;

              GlobalKey<NavigatorState> navKey =
                  _screenNavigatorKeys[selectedItem]!;

              return BlocListener<NavigationBloc, NavigationState>(
                listenWhen: (prev, next) {
                  return prev != next;
                },
                listener: (_, state) {
                  if (state is! NavigationDone) {
                    return;
                  }

                  if (state.closeUiElements) {
                    navKey.currentState?.pop();
                  }

                  if (state.exception == null) {
                    if (state.nextPageName != null) {
                      if (!state.isReplaced) {
                        navKey.currentState
                            ?.pushNamed(state.nextPageName!.name);
                      } else {
                        navKey.currentState
                            ?.pushReplacementNamed(state.nextPageName!.name);
                      }
                    } else if (state.navigateBack &&
                        !state.navigateBackToRoot) {
                      navKey.currentState?.pop();
                    } else if (state.navigateBack && state.navigateBackToRoot) {
                      navKey.currentState?.popUntil(
                        (route) => route.isFirst,
                      );
                    }
                  } else if (state.exception!.isError) {
                    navKey.currentState?.push(
                      MaterialPageRoute(
                        builder: (context) => ConvertouchErrorPage(
                          error: state.exception!,
                        ),
                      ),
                    );
                  } else {
                    showSnackBar(
                      context,
                      exception: state.exception!,
                      theme: appState.theme,
                    );
                  }
                },
                child: PopScope(
                  canPop: false,
                  onPopInvokedWithResult: (didPop, result) async {
                    if (didPop) {
                      return;
                    }

                    if (selectedItem != BottomNavbarItem.home) {
                      BlocProvider.of<RootScreenBloc>(
                        _screenNavigatorKeys[selectedItem]!.currentContext!,
                      ).add(
                        SelectBottomNavbarItem(
                          targetItem: BottomNavbarItem.home,
                          selectedItem: selectedItem,
                        ),
                      );
                    } else {
                      final isFirstRouteInSelectedNavbarItem =
                          !await _screenNavigatorKeys[selectedItem]!
                              .currentState!
                              .maybePop();

                      if (isFirstRouteInSelectedNavbarItem) {
                        SystemNavigator.pop();
                      }
                    }
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
                              PageName.unitsPageForConversionParams.name:
                                  const ConvertouchUnitsPageForConversionParams(),
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
                              PageName.paramSetsPage.name:
                                  const ConversionParamSetsPage(),
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
                        showSelectedLabels: false,
                        showUnselectedLabels: false,
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
                          BlocProvider.of<RootScreenBloc>(context).add(
                            SelectBottomNavbarItem(
                              targetItem: BottomNavbarItem.values[index],
                              selectedItem: selectedItem,
                            ),
                          );
                        },
                        currentIndex: selectedItem.index,
                        elevation: 0,
                        selectedFontSize: 12,
                        unselectedItemColor:
                            pageColorScheme.bottomBar.foreground.regular,
                        selectedItemColor:
                            pageColorScheme.bottomBar.foreground.selected,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
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
    NotificationColorScheme snackBarColor = appColors[theme].notification;

    Color foreground;
    switch (exception.severity) {
      case ExceptionSeverity.warning:
        foreground = snackBarColor.foreground.warning;
        break;
      case ExceptionSeverity.error:
        foreground = snackBarColor.foreground.error;
        break;
      case ExceptionSeverity.info:
        foreground = snackBarColor.foreground.regular;
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
