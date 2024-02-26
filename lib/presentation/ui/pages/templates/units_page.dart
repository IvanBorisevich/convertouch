import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
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
  final void Function(IdNameItemModel)? onUnitTap;
  final void Function(IdNameItemModel)? onUnitTapForRemoval;
  final void Function(IdNameItemModel)? onUnitLongPress;
  final void Function(String)? onSearchStringChanged;
  final void Function()? onSearchReset;
  final void Function()? onUnitsRemove;
  final List<int> itemIdsSelectedForRemoval;
  final List<Widget>? appBarRightWidgets;
  final bool markedUnitsForConversionVisible;
  final List<int>? markedUnitIdsForConversion;
  final bool selectedUnitVisible;
  final int? selectedUnitId;
  final int? disabledUnitId;
  final bool removalModeAllowed;
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
    required this.itemIdsSelectedForRemoval,
    required this.appBarRightWidgets,
    required this.markedUnitsForConversionVisible,
    required this.markedUnitIdsForConversion,
    required this.selectedUnitVisible,
    required this.selectedUnitId,
    required this.disabledUnitId,
    required this.removalModeAllowed,
    required this.removalModeEnabled,
    required this.floatingButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
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
          itemIdsMarkedForConversion: markedUnitIdsForConversion,
          itemIdsMarkedForRemoval: itemIdsSelectedForRemoval,
          showMarkedItems: markedUnitsForConversionVisible,
          selectedItemId: selectedUnitId,
          disabledItemId: disabledUnitId,
          showSelectedItem: selectedUnitVisible,
          removalModeAllowed: removalModeAllowed,
          removalModeEnabled: removalModeEnabled,
          onItemTap: onUnitTap,
          onItemTapForRemoval: onUnitTapForRemoval,
          onItemLongPress: onUnitLongPress,
          itemsViewMode: appState.unitsViewMode,
          theme: appState.theme,
        ),
        floatingActionButton: floatingButton,
        onItemsRemove: onUnitsRemove,
      );
    });
  }
}
