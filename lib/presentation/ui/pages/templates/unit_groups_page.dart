import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/common/app/app_event.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/menu_items_view.dart';
import 'package:convertouch/presentation/ui/widgets/search_bar.dart';
import 'package:convertouch/presentation/ui/widgets/secondary_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitGroupsPage extends StatelessWidget {
  final String pageTitle;
  final Widget? customLeadingIcon;
  final List<UnitGroupModel> unitGroups;
  final void Function(UnitGroupModel)? onUnitGroupTap;
  final void Function(UnitGroupModel)? onUnitGroupTapForRemoval;
  final void Function(UnitGroupModel)? onUnitGroupLongPress;
  final void Function(String)? onSearchStringChanged;
  final void Function()? onSearchReset;
  final void Function()? onUnitGroupsRemove;
  final List<int> itemIdsSelectedForRemoval;
  final List<Widget>? appBarRightWidgets;
  final bool selectedUnitGroupVisible;
  final bool editableUnitGroupsVisible;
  final int? selectedUnitGroupId;
  final List<int>? disabledUnitGroupIds;
  final bool removalModeEnabled;
  final bool removalModeAllowed;
  final Widget? floatingButton;
  final String searchBarPlaceholder;

  const ConvertouchUnitGroupsPage({
    required this.pageTitle,
    required this.customLeadingIcon,
    required this.unitGroups,
    required this.onUnitGroupTap,
    required this.onUnitGroupTapForRemoval,
    required this.onUnitGroupLongPress,
    required this.onSearchStringChanged,
    required this.onSearchReset,
    required this.onUnitGroupsRemove,
    required this.itemIdsSelectedForRemoval,
    required this.appBarRightWidgets,
    required this.selectedUnitGroupVisible,
    required this.editableUnitGroupsVisible,
    required this.selectedUnitGroupId,
    required this.disabledUnitGroupIds,
    required this.removalModeEnabled,
    required this.removalModeAllowed,
    required this.floatingButton,
    this.searchBarPlaceholder = "Search unit groups...",
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder(
      builderFunc: (appState) {
        return ConvertouchPage(
          title: pageTitle,
          customLeadingIcon: customLeadingIcon,
          appBarRightWidgets: appBarRightWidgets,
          secondaryAppBar: SecondaryAppBar(
            theme: appState.theme,
            child: ConvertouchSearchBar(
              placeholder: searchBarPlaceholder,
              theme: appState.theme,
              pageViewMode: appState.unitGroupsViewMode,
              onViewModeChange: () {
                BlocProvider.of<AppBloc>(context).add(
                  ChangeSetting(
                    settingKey: SettingKeys.unitGroupsViewMode,
                    settingValue: appState.unitGroupsViewMode.next.value,
                  ),
                );
              },
              onSearchStringChanged: onSearchStringChanged,
              onSearchReset: onSearchReset,
            ),
          ),
          body: ConvertouchMenuItemsView(
            unitGroups,
            selectedItemId: selectedUnitGroupId,
            disabledItemIds: disabledUnitGroupIds,
            showSelectedItem: selectedUnitGroupVisible,
            itemIdsMarkedForRemoval: itemIdsSelectedForRemoval,
            removalModeEnabled: removalModeEnabled,
            removalModeAllowed: removalModeAllowed,
            editableItemsVisible: editableUnitGroupsVisible,
            onItemTap: onUnitGroupTap,
            onItemTapForRemoval: onUnitGroupTapForRemoval,
            onItemLongPress: onUnitGroupLongPress,
            itemsViewMode: appState.unitGroupsViewMode,
            theme: appState.theme,
          ),
          floatingActionButton: floatingButton,
          onItemsRemove: onUnitGroupsRemove,
        );
      },
    );
  }
}
