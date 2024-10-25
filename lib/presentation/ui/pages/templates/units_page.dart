import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/common/app/app_event.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/menu_items_view.dart';
import 'package:convertouch/presentation/ui/widgets/search_bar.dart';
import 'package:convertouch/presentation/ui/widgets/secondary_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsPage extends StatelessWidget {
  final String pageTitle;
  final Widget? customLeadingIcon;
  final List<UnitModel> units;
  final List<int> checkedUnitIds;
  final List<int> disabledUnitIds;
  final void Function(UnitModel)? onUnitTap;
  final void Function(UnitModel)? onUnitTapForRemoval;
  final void Function(UnitModel)? onUnitLongPress;
  final void Function(String)? onSearchStringChanged;
  final void Function()? onSearchReset;
  final void Function()? onUnitsRemove;
  final List<Widget>? appBarRightWidgets;
  final bool checkableUnitsVisible;
  final bool editableUnitsVisible;
  final int? selectedUnitId;
  final bool removalModeEnabled;
  final Widget? floatingButton;

  const ConvertouchUnitsPage({
    required this.pageTitle,
    required this.customLeadingIcon,
    required this.units,
    required this.onUnitTap,
    required this.onUnitTapForRemoval,
    required this.onUnitLongPress,
    required this.onSearchStringChanged,
    required this.onSearchReset,
    required this.onUnitsRemove,
    required this.appBarRightWidgets,
    required this.checkedUnitIds,
    required this.checkableUnitsVisible,
    required this.editableUnitsVisible,
    required this.selectedUnitId,
    required this.disabledUnitIds,
    required this.removalModeEnabled,
    required this.floatingButton,
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
              placeholder: "Search units...",
              theme: appState.theme,
              pageViewMode: appState.unitsViewMode,
              onViewModeChange: () {
                BlocProvider.of<AppBloc>(context).add(
                  ChangeSetting(
                    settingKey: SettingKeys.unitsViewMode,
                    settingValue: appState.unitsViewMode.next.value,
                  ),
                );
              },
              onSearchStringChanged: onSearchStringChanged,
              onSearchReset: onSearchReset,
            ),
          ),
          body: ConvertouchMenuItemsView(
            units,
            checkedItemIds: checkedUnitIds,
            selectedItemId: selectedUnitId,
            disabledItemIds: disabledUnitIds,
            removalModeEnabled: removalModeEnabled,
            checkableItemsVisible: checkableUnitsVisible,
            editableItemsVisible: editableUnitsVisible,
            onItemTap: onUnitTap,
            onItemTapForRemoval: onUnitTapForRemoval,
            onItemLongPress: onUnitLongPress,
            itemsViewMode: appState.unitsViewMode,
            theme: appState.theme,
          ),
          floatingActionButton: floatingButton,
          onItemsRemove: onUnitsRemove,
        );
      },
    );
  }
}
