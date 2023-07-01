import 'package:convertouch/model/constant.dart';
import 'package:convertouch/presenter/bloc/converted_items_bloc.dart';
import 'package:convertouch/presenter/bloc/items_menu_view_bloc.dart';
import 'package:convertouch/presenter/bloc/unit_groups_menu_bloc.dart';
import 'package:convertouch/presenter/bloc/units_menu_bloc.dart';
import 'package:convertouch/presenter/bloc_observer.dart';
import 'package:convertouch/presenter/events/unit_groups_menu_events.dart';
import 'package:convertouch/view/home_page.dart';
import 'package:convertouch/view/items_menu_page/unit_groups_menu_page.dart';
import 'package:convertouch/view/items_menu_page/units_menu_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  Bloc.observer = ConvertouchBlocObserver();
  runApp(const ConvertouchApp());
}

class ConvertouchApp extends StatelessWidget {
  const ConvertouchApp({super.key});

  static final Map<String, Widget> routes = {
    homePageId: const ConvertouchHomePage(),
    unitGroupsPageId: const ConvertouchUnitGroupsMenuPage(),
    unitsPageId: const ConvertouchUnitsMenuPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ConvertedItemsBloc()),
        BlocProvider(create: (context) => ItemsMenuViewBloc()),
        BlocProvider(
            create: (context) =>
                UnitGroupsMenuFetchBloc()..add(const FetchUnitGroups(firstTime: true))),
        BlocProvider(create: (context) => UnitsMenuFetchBloc()),
        BlocProvider(create: (context) => UnitsMenuSelectBloc()),
      ],
      child: MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: quicksandFontFamily),
        initialRoute: homePageId,
        onGenerateRoute: (settings) {
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => _getRoute(settings.name),
            transitionDuration: const Duration(milliseconds: 200),
            reverseTransitionDuration: const Duration(milliseconds: 150),
            transitionsBuilder: (context, anim, secondaryAnim, child) =>
                SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: anim,
                  curve: Curves.easeOutCirc,
                ),
              ),
              child: FadeTransition(
                opacity: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(
                  CurvedAnimation(
                    parent: anim,
                    curve: Curves.linear,
                  ),
                ),
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getRoute(String? routeName) {
    return routes[routeName] ?? routes[homePageId]!;
  }
}
