import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/ui/pages/conversion_page.dart';
import 'package:convertouch/presentation/ui/pages/refreshing_job_details_page.dart';
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
  final PageName rootPageId;

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
          PageName.unitsConversionPage.name,
          const ConvertouchConversionPage(),
        ),
        route(
          PageName.unitGroupsPageRegular.name,
          const ConvertouchUnitGroupsPageRegular(),
        ),
        route(
          PageName.unitGroupsPageForConversion.name,
          const ConvertouchUnitGroupsPageForConversion(),
        ),
        route(
          PageName.unitGroupsPageForUnitCreation.name,
          const ConvertouchUnitGroupsPageForUnitCreation(),
        ),
        route(
          PageName.unitsPageRegular.name,
          const ConvertouchUnitsPageRegular(),
        ),
        route(
          PageName.unitsPageForConversion.name,
          const ConvertouchUnitsPageForConversion(),
        ),
        route(
          PageName.unitsPageForUnitCreation.name,
          const ConvertouchUnitsPageForUnitCreation(),
        ),
        route(
          PageName.unitGroupCreationPage.name,
          const ConvertouchUnitGroupCreationPage(),
        ),
        route(
          PageName.unitCreationPage.name,
          const ConvertouchUnitCreationPage(),
        ),
        route(
          PageName.refreshingJobsPage.name,
          const ConvertouchRefreshingJobsPage(),
        ),
        route(
          PageName.refreshingJobDetailsPage.name,
          const ConvertouchRefreshingJobDetailsPage(),
        ),
      ]);
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);

    return Navigator(
      key: navigatorKey,
      initialRoute: rootPageId.name,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name]!(context),
        );
      },
    );
  }
}
