import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/ui/pages/unit_group_creation_page.dart';
import 'package:convertouch/presentation/ui/pages/unit_groups_page_for_conversion.dart';
import 'package:convertouch/presentation/ui/pages/unit_groups_page_regular.dart';
import 'package:convertouch/presentation/ui/pages/units_conversion_page.dart';
import 'package:convertouch/presentation/ui/pages/units_page_for_conversion.dart';
import 'package:convertouch/presentation/ui/pages/units_page_regular.dart';
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
      unitsConversionPage: (context) => const ConvertouchUnitsConversionPage(),
      unitGroupsPageRegular: (context) =>
          const ConvertouchUnitGroupsPageRegular(),
      unitGroupsPageForConversion: (context) =>
          const ConvertouchUnitGroupsPageForConversion(),
      unitsPageRegular: (context) => const ConvertouchUnitsPageRegular(),
      unitsPageForConversion: (context) =>
          const ConvertouchUnitsPageForConversion(),
      unitGroupCreationPage: (context) =>
          const ConvertouchUnitGroupCreationPage(),
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
