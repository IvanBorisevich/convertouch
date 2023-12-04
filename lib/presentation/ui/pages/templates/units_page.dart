import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/menu_items_view/menu_items_view_bloc.dart';
import 'package:convertouch/presentation/bloc/menu_items_view/menu_items_view_event.dart';
import 'package:convertouch/presentation/ui/items_view/menu_items_view.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsPage extends StatelessWidget {
  final String pageTitle;
  final List<UnitModel> units;
  final void Function(IdNameItemModel)? onUnitTap;
  final List<Widget>? appBarRightWidgets;
  final bool markedUnitsForConversionVisible;
  final bool markUnitsOnTap;
  final List<int>? markedUnitIdsForConversion;
  final bool selectedUnitVisible;
  final int? selectedUnitId;
  final bool removalModeAllowed;
  final Widget? floatingButton;

  const ConvertouchUnitsPage({
    required this.pageTitle,
    required this.units,
    required this.onUnitTap,
    required this.appBarRightWidgets,
    required this.markedUnitsForConversionVisible,
    required this.markUnitsOnTap,
    required this.markedUnitIdsForConversion,
    required this.selectedUnitVisible,
    required this.selectedUnitId,
    required this.removalModeAllowed,
    required this.floatingButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return appBloc((appState) {
      return unitsViewModeBloc((viewModeState) {
        return ConvertouchPage(
          appState: appState,
          title: pageTitle,
          appBarRightWidgets: appBarRightWidgets,
          secondaryAppBar: ConvertouchSearchBar(
            placeholder: "Search units...",
            theme: appState.theme,
            iconViewMode: viewModeState.iconViewMode,
            pageViewMode: viewModeState.pageViewMode,
            onViewModeChange: () {
              BlocProvider.of<UnitsViewModeBloc>(context).add(
                ChangeMenuItemsView(
                  targetViewMode: viewModeState.iconViewMode,
                ),
              );
            },
          ),
          body: ConvertouchMenuItemsView(
            units,
            markedItemIds: markedUnitIdsForConversion,
            showMarkedItems: markedUnitsForConversionVisible,
            selectedItemId: selectedUnitId,
            showSelectedItem: selectedUnitVisible,
            markItemsOnTap: markUnitsOnTap,
            removalModeAllowed: removalModeAllowed,
            onItemTap: onUnitTap,
            viewMode: viewModeState.pageViewMode,
            theme: appState.theme,
          ),
          floatingActionButton: floatingButton,
        );
      });
    });
  }
}
