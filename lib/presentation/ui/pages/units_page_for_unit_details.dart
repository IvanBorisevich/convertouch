import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_events.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/ui/pages/templates/units_page.dart';
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

    return unitsBlocBuilder(
      bloc: unitsBloc,
      builderFunc: (pageState) {
        return itemsSelectionBlocBuilder(
          bloc: itemsSelectionBloc,
          builderFunc: (itemsSelectionState) {
            return ConvertouchUnitsPage(
              pageTitle: "Select Argument Unit",
              customLeadingIcon: null,
              units: pageState.units,
              appBarRightWidgets: const [],
              onSearchStringChanged: (text) {
                unitsBloc.add(
                  FetchUnits(
                    unitGroup: pageState.unitGroup,
                    searchString: text,
                  ),
                );
              },
              onSearchReset: () {
                unitsBloc.add(
                  FetchUnits(
                    unitGroup: pageState.unitGroup,
                    // selectedArgUnit: pageState.selectedArgUnit,
                    // unitIdBeingEdited: pageState.currentEditedUnitId,
                  ),
                );
              },
              onUnitTap: (unit) {
                itemsSelectionBloc.add(
                  SelectItem(id: unit.id),
                );
                unitDetailsBloc.add(
                  ChangeArgumentUnitInUnitDetails(
                    argumentUnit: unit,
                  ),
                );
              },
              onUnitsRemove: null,
              onUnitTapForRemoval: null,
              onUnitLongPress: null,
              itemIdsSelectedForRemoval: const [],
              removalModeAllowed: false,
              removalModeEnabled: false,
              editableUnitsVisible: false,
              markedUnitsForConversionVisible: false,
              markedUnitIdsForConversion: null,
              selectedUnitVisible: true,
              selectedUnitId: itemsSelectionState.selectedId,
              disabledUnitIds: itemsSelectionState.excludedIds,
              floatingButton: null,
            );
          },
        );
      },
    );
  }
}
