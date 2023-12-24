import 'package:convertouch/domain/model/input/unit_creation_events.dart';
import 'package:convertouch/domain/model/input/units_events.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_creation_bloc.dart';
import 'package:convertouch/presentation/bloc/units_bloc_for_unit_creation.dart';
import 'package:convertouch/presentation/ui/pages/templates/units_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsPageForUnitCreation extends StatelessWidget {
  const ConvertouchUnitsPageForUnitCreation({super.key});

  @override
  Widget build(BuildContext context) {
    return unitsBlocBuilderForUnitCreation((pageState) {
      return ConvertouchUnitsPage(
        pageTitle: "Select Base Unit",
        units: pageState.units,
        appBarRightWidgets: const [],
        onSearchStringChanged: (text) {
          BlocProvider.of<UnitsBlocForUnitCreation>(context).add(
            FetchUnitsForUnitCreation(
              unitGroup: pageState.unitGroup!,
              currentSelectedBaseUnit: pageState.currentSelectedBaseUnit,
              searchString: text,
            ),
          );
        },
        onSearchReset: () {
          BlocProvider.of<UnitsBlocForUnitCreation>(context).add(
            FetchUnitsForUnitCreation(
              unitGroup: pageState.unitGroup!,
              currentSelectedBaseUnit: pageState.currentSelectedBaseUnit,
              searchString: null,
            ),
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
  }
}
