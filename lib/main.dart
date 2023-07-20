import 'package:convertouch/model/constant.dart';
import 'package:convertouch/presenter/bloc/units_conversion_bloc.dart';
import 'package:convertouch/presenter/bloc/items_menu_view_bloc.dart';
import 'package:convertouch/presenter/bloc/unit_groups_menu_bloc.dart';
import 'package:convertouch/presenter/bloc/units_menu_bloc.dart';
import 'package:convertouch/presenter/bloc_observer.dart';
import 'package:convertouch/presenter/events/unit_groups_menu_events.dart';
import 'package:convertouch/view/animation/navigation_animation.dart';
import 'package:convertouch/view/home_page.dart';
import 'package:convertouch/view/scaffold/bloc.dart';
import 'package:convertouch/view/scaffold/navigation.dart';
import 'package:convertouch/view/unit_creation_page.dart';
import 'package:convertouch/view/unit_group_creation_page.dart';
import 'package:convertouch/view/unit_groups_menu_page.dart';
import 'package:convertouch/view/units_menu_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

void main() {
  Bloc.observer = ConvertouchBlocObserver();
  GetIt.I.registerSingleton<NavigationService>(NavigationService());
  runApp(const ConvertouchApp());
}

class ConvertouchApp extends StatelessWidget {
  const ConvertouchApp({super.key});

  static final Map<String, Widget> routes = {
    homePageId: const ConvertouchHomePage(),
    unitGroupsPageId: const ConvertouchUnitGroupsMenuPage(),
    unitsPageId: const ConvertouchUnitsMenuPage(),
    unitGroupCreationPageId: const ConvertouchUnitGroupCreationPage(),
    unitCreationPageId: const ConvertouchUnitCreationPage()
  };

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UnitsConversionBloc()),
        BlocProvider(create: (context) => ItemsMenuViewBloc()),
        BlocProvider(create: (context) => UnitGroupsMenuBloc()
          ..add(const FetchUnitGroups())),
        BlocProvider(create: (context) => UnitsMenuBloc()),
      ],
      child: wrapIntoNavigationListeners(
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
        )
      ),
    );
  }

  Widget _getRoute(String? routeName) {
    return routes[routeName] ?? routes[homePageId]!;
  }
}
