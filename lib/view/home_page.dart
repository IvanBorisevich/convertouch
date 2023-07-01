import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/util/app_util.dart';
import 'package:convertouch/view/converted_units_page.dart';
import 'package:convertouch/view/unit_groups_menu_page.dart';
import 'package:flutter/cupertino.dart';

class ConvertouchHomePage extends StatelessWidget {
  const ConvertouchHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    switch (getHomePageId()) {
      case convertedItemsPageId:
        return const ConvertouchConvertedUnitsPage();
      case unitGroupsPageId:
      default:
        return const ConvertouchUnitGroupsMenuPage();
    }
  }
}
