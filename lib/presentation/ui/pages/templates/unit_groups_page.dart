import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/menu_items_view/menu_items_view_bloc.dart';
import 'package:convertouch/presentation/bloc/menu_items_view/menu_items_view_event.dart';
import 'package:convertouch/presentation/ui/items_view/menu_items_view.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      return unitGroupsViewModeBloc((viewModeState) {
        return ConvertouchPage(
          appState: appState,
          title: pageTitle,
          appBarRightWidgets: appBarRightWidgets,
          secondaryAppBar: ConvertouchSearchBar(
            placeholder: "Search unit groups...",
            theme: appState.theme,
            iconViewMode: viewModeState.iconViewMode,
            pageViewMode: viewModeState.pageViewMode,
            onViewModeChange: () {
              BlocProvider.of<UnitGroupsViewModeBloc>(context).add(
                ChangeMenuItemsView(
                  targetViewMode: viewModeState.iconViewMode,
                ),
              );
            },
          ),
          body: ConvertouchMenuItemsView(
            unitGroups,
            selectedItemId: selectedUnitGroupId,
            showSelectedItem: selectedUnitGroupVisible,
            removalModeAllowed: removalModeAllowed,
            onItemTap: onUnitGroupTap,
            itemsViewMode: viewModeState.pageViewMode,
            theme: appState.theme,
          ),
          floatingActionButton: floatingButton,
        );
      });
    });
  }
}