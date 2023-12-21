import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/ui/pages/conversion_page.dart';
import 'package:convertouch/presentation/ui/pages/refreshing_jobs_page.dart';
import 'package:convertouch/presentation/ui/pages/unit_creation_page.dart';
import 'package:convertouch/presentation/ui/pages/unit_group_creation_page.dart';
import 'package:convertouch/presentation/ui/pages/unit_groups_page_for_conversion.dart';
import 'package:convertouch/presentation/ui/pages/unit_groups_page_for_unit_creation.dart';
import 'package:convertouch/presentation/ui/pages/unit_groups_page_regular.dart';
import 'package:convertouch/presentation/ui/pages/units_page_for_conversion.dart';
import 'package:convertouch/presentation/ui/pages/units_page_for_unit_creation.dart';
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
    MapEntry<String, WidgetBuilder> route(String pageId, Widget page) {
      return MapEntry(pageId, (context) => page);
    }

    return {}..addEntries([
        route(
          unitsConversionPage,
          const ConvertouchConversionPage(),
        ),
        route(
          unitGroupsPageRegular,
          const ConvertouchUnitGroupsPageRegular(),
        ),
        route(
          unitGroupsPageForConversion,
          const ConvertouchUnitGroupsPageForConversion(),
        ),
        route(
          unitGroupsPageForUnitCreation,
          const ConvertouchUnitGroupsPageForUnitCreation(),
        ),
        route(
          unitsPageRegular,
          const ConvertouchUnitsPageRegular(),
        ),
        route(
          unitsPageForConversion,
          const ConvertouchUnitsPageForConversion(),
        ),
        route(
          unitsPageForUnitCreation,
          const ConvertouchUnitsPageForUnitCreation(),
        ),
        route(
          unitGroupCreationPage,
          const ConvertouchUnitGroupCreationPage(),
        ),
        route(
          unitCreationPage,
          const ConvertouchUnitCreationPage(),
        ),
        route(
          refreshingJobsPage,
          const ConvertouchRefreshingJobsPage(),
        ),
      ]);
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
