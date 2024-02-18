import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/ui/pages/conversion_page.dart';
import 'package:convertouch/presentation/ui/pages/refreshing_job_details_page.dart';
import 'package:convertouch/presentation/ui/pages/settings_page.dart';
import 'package:convertouch/presentation/ui/pages/unit_details_page.dart';
import 'package:convertouch/presentation/ui/pages/unit_group_details_page.dart';
import 'package:convertouch/presentation/ui/pages/unit_groups_page_for_conversion.dart';
import 'package:convertouch/presentation/ui/pages/unit_groups_page_for_unit_details.dart';
import 'package:convertouch/presentation/ui/pages/unit_groups_page_regular.dart';
import 'package:convertouch/presentation/ui/pages/units_page_for_conversion.dart';
import 'package:convertouch/presentation/ui/pages/units_page_for_unit_details.dart';
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
      return MapEntry<String, WidgetBuilder>(pageId, (context) => page);
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
          PageName.unitGroupsPageForUnitDetails.name,
          const ConvertouchUnitGroupsPageForUnitDetails(),
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
          PageName.unitsPageForUnitDetails.name,
          const ConvertouchUnitsPageForUnitDetails(),
        ),
        route(
          PageName.unitGroupDetailsPage.name,
          const ConvertouchUnitGroupDetailsPage(),
        ),
        route(
          PageName.unitDetailsPage.name,
          const ConvertouchUnitDetailsPage(),
        ),
        route(
          PageName.settingsPage.name,
          const ConvertouchSettingsPage(),
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
