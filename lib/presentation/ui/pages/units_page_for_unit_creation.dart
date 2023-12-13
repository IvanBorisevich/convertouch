import 'package:convertouch/domain/model/input/items_search_events.dart';
import 'package:convertouch/domain/model/input/unit_creation_events.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/items_search_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_creation_bloc.dart';
import 'package:convertouch/presentation/ui/pages/templates/units_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsPageForUnitCreation extends StatelessWidget {
  const ConvertouchUnitsPageForUnitCreation({super.key});

  @override
  Widget build(BuildContext context) {
    return unitsBlocForUnitCreation((pageState) {
      return unitsSearchBlocForUnitCreation((foundUnits) {
        return ConvertouchUnitsPage(
          pageTitle: "Select Base Unit",
          units: foundUnits ?? pageState.units,
          appBarRightWidgets: const [],
          onSearchStringChanged: (text) {
            BlocProvider.of<UnitsSearchBlocForUnitCreation>(context).add(
              SearchUnits(
                searchString: text,
                unitGroupId: pageState.unitGroup!.id!,
              ),
            );
          },
          onSearchReset: () {
            BlocProvider.of<UnitsSearchBlocForUnitCreation>(context).add(
              const ResetSearch(),
            );
          },
          onUnitTap: (unit) {
            BlocProvider.of<UnitCreationBloc>(context).add(
              PrepareUnitCreation(
                unitGroup: pageState.unitGroup,
                baseUnit: unit as UnitModel,
              ),
            );
            Navigator.of(context).pop();
          },
          onUnitsRemove: null,
          onUnitTapForRemoval: null,
          onUnitLongPress: null,
          itemIdsSelectedForRemoval: const [],
          removalModeAllowed: false,
          removalModeEnabled: false,
          markedUnitsForConversionVisible: false,
          markUnitsOnTap: false,
          markedUnitIdsForConversion: null,
          selectedUnitVisible: true,
          selectedUnitId: pageState.currentSelectedBaseUnit?.id,
          floatingButton: null,
        );
      });
    });
  }
}
