import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/ui/pages/unit_groups_page.dart';
import 'package:convertouch/presentation/ui/pages/units_conversion_page.dart';
import 'package:flutter/material.dart';

class ConvertouchBottomNavbarItemNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState>? navigatorKey;
  final BottomNavbarItem bottomNavbarItem;
  final String rootPageId;

  const ConvertouchBottomNavbarItemNavigator({
    required this.navigatorKey,
    required this.bottomNavbarItem,
    required this.rootPageId,
    super.key,
  });

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      homePageId: (context) => const ConvertouchUnitsConversionPage(),
      unitGroupsPageId: (context) => const ConvertouchUnitGroupsPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);

    return Navigator(
      key: navigatorKey,
      initialRoute: rootPageId,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name]!(context),
        );
      },
    );
  }
}
