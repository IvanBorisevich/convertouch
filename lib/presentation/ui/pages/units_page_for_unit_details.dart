import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/ui/pages/basic_page.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/menu_items_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsPageForUnitDetails extends StatelessWidget {
  const ConvertouchUnitsPageForUnitDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final itemsSelectionBloc =
        BlocProvider.of<ItemsSelectionBlocForUnitDetails>(context);
    final unitsBloc = BlocProvider.of<UnitsBlocForUnitDetails>(context);
    final unitDetailsBloc = BlocProvider.of<UnitDetailsBloc>(context);

    return itemsSelectionBlocBuilder(
      bloc: itemsSelectionBloc,
      builderFunc: (itemsSelectionState) {
        return ConvertouchPage(
          title: "Select Argument Unit",
          body: ConvertouchMenuItemsView(
            itemsListBloc: unitsBloc,
            pageName: PageName.unitsPageForUnitDetails,
            viewModeSettingKey: SettingKey.unitsViewMode,
            searchBarPlaceholder: "Search units...",
            onItemTap: (unit) {
              unitDetailsBloc.add(
                ChangeArgumentUnitInUnitDetails(
                  argumentUnit: unit,
                ),
              );
            },
            onItemTapForRemoval: null,
            onItemLongPress: null,
            checkedItemIds: const [],
            disabledItemIds: itemsSelectionState.excludedIds,
            selectedItemId: itemsSelectionState.selectedId,
            editableItemsVisible: false,
            checkableItemsVisible: true,
            removalModeEnabled: false,
          ),
        );
      },
    );
  }
}
