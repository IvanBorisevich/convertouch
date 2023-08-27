import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants.dart';
import 'package:convertouch/presentation/bloc/items_menu_view_mode/items_menu_view_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_creation/unit_creation_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/units/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_conversion/units_conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/bloc_observer.dart';
import 'package:convertouch/presentation/bloc/unit_groups/unit_groups_events.dart';
import 'package:convertouch/presentation/pages/animation/navigation_animation.dart';
import 'package:convertouch/presentation/pages/home_page.dart';
import 'package:convertouch/presentation/pages/scaffold/bloc_wrappers.dart';
import 'package:convertouch/presentation/pages/scaffold/navigation_service.dart';
import 'package:convertouch/presentation/pages/unit_creation_page.dart';
import 'package:convertouch/presentation/pages/unit_group_creation_page.dart';
import 'package:convertouch/presentation/pages/unit_groups_page.dart';
import 'package:convertouch/presentation/pages/units_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  Bloc.observer = ConvertouchBlocObserver();
  di.init();
  runApp(const ConvertouchApp());
}

class ConvertouchApp extends StatelessWidget {
  const ConvertouchApp({super.key});

  static final Map<String, Widget> routes = {
    homePageId: const ConvertouchHomePage(),
    unitGroupsPageId: const ConvertouchUnitGroupsPage(),
    unitsPageId: const ConvertouchUnitsPage(),
    unitGroupCreationPageId: const ConvertouchUnitGroupCreationPage(),
    unitCreationPageId: const ConvertouchUnitCreationPage()
  };

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.locator<UnitsConversionBloc>()),
        BlocProvider(create: (context) => di.locator<ItemsMenuViewBloc>()),
        BlocProvider(
          create: (context) => di.locator<UnitGroupsBloc>()
            ..add(
              const FetchUnitGroups(
                action: ConvertouchAction.fetchUnitGroupsInitially,
              ),
            ),
        ),
        BlocProvider(create: (context) => di.locator<UnitsBloc>()),
        BlocProvider(create: (context) => di.locator<UnitCreationBloc>()),
      ],
      child: navigationListeners(
        MaterialApp(
          title: appName,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: quicksandFontFamily),
          initialRoute: homePageId,
          navigatorKey: NavigationService.I.navigatorKey,
          onGenerateRoute: (settings) {
            return ConvertouchNavigationAnimation.wrapIntoAnimation(
                _getRoute(settings.name), settings);
          },
        ),
      ),
    );
  }

  Widget _getRoute(String? routeName) {
    return routes[routeName] ?? routes[homePageId]!;
  }
}
