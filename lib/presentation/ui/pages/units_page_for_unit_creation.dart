import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_creation_page/unit_creation_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_creation_page/unit_creation_events.dart';
import 'package:convertouch/presentation/ui/pages/templates/units_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsPageForUnitCreation extends StatelessWidget {
  const ConvertouchUnitsPageForUnitCreation({super.key});

  @override
  Widget build(BuildContext context) {
    return appBloc((appState) {
      return unitsBlocForUnitCreation((pageState) {
        return ConvertouchUnitsPage(
          pageTitle: "Select Base Unit",
          units: pageState.units,
          appBarRightWidgets: const [],
          onUnitTap: (unit) {
            BlocProvider.of<UnitCreationBloc>(context).add(
              PrepareUnitCreation(
                unitGroup: pageState.unitGroup,
                baseUnit: unit as UnitModel,
              ),
            );
            Navigator.of(context).pop();
          },
          markedUnitsForConversionVisible: false,
          markUnitsOnTap: false,
          markedUnitIdsForConversion: null,
          selectedUnitVisible: true,
          selectedUnitId: pageState.currentSelectedBaseUnit?.id,
          removalModeAllowed: false,
          floatingButton: null,
        );
      });
    });
  }
}
