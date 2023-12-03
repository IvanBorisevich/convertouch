import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/ui/items_view/menu_items_view.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/search_bar.dart';
import 'package:flutter/material.dart';

class ConvertouchUnitGroupsPage extends StatelessWidget {
  final String pageTitle;
  final List<UnitGroupModel> unitGroups;
  final void Function(IdNameItemModel)? onUnitGroupTap;
  final List<Widget>? appBarRightWidgets;
  final bool selectedUnitGroupVisible;
  final int? selectedUnitGroupId;
  final bool removalModeAllowed;
  final Widget? floatingButton;

  const ConvertouchUnitGroupsPage({
    required this.pageTitle,
    required this.unitGroups,
    required this.onUnitGroupTap,
    required this.appBarRightWidgets,
    required this.selectedUnitGroupVisible,
    required this.selectedUnitGroupId,
    required this.removalModeAllowed,
    required this.floatingButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return appBloc((appState) {
      return ConvertouchPage(
        appState: appState,
        title: pageTitle,
        appBarRightWidgets: appBarRightWidgets,
        secondaryAppBar: ConvertouchSearchBar(
          placeholder: "Search unit groups...",
          theme: appState.theme,
          iconViewMode: ItemsViewMode.list,
          pageViewMode: ItemsViewMode.grid,
        ),
        body: ConvertouchMenuItemsView(
          unitGroups,
          selectedItemId: selectedUnitGroupId,
          showSelectedItem: selectedUnitGroupVisible,
          removalModeAllowed: removalModeAllowed,
          onItemTap: onUnitGroupTap,
          theme: appState.theme,
        ),
        floatingActionButton: floatingButton,
      );
    });
  }
}