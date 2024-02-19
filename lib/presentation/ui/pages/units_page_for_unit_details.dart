import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc_for_unit_details.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/ui/pages/templates/units_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsPageForUnitDetails extends StatelessWidget {
  const ConvertouchUnitsPageForUnitDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return unitsBlocBuilderForUnitDetails((pageState) {
      return ConvertouchUnitsPage(
        pageTitle: "Select Argument Unit",
        customLeadingIcon: null,
        units: pageState.units,
        appBarRightWidgets: const [],
        onSearchStringChanged: (text) {
          BlocProvider.of<UnitsBlocForUnitDetails>(context).add(
            FetchUnitsForUnitDetails(
              unitGroup: pageState.unitGroup,
              selectedArgUnit: pageState.selectedArgUnit,
              currentEditedUnit: pageState.currentEditedUnit,
              searchString: text,
            ),
          );
        },
        onSearchReset: () {
          BlocProvider.of<UnitsBlocForUnitDetails>(context).add(
            FetchUnitsForUnitDetails(
              unitGroup: pageState.unitGroup,
              selectedArgUnit: pageState.selectedArgUnit,
              currentEditedUnit: pageState.currentEditedUnit,
              searchString: null,
            ),
          );
        },
        onUnitTap: (unit) {
          BlocProvider.of<UnitDetailsBloc>(context).add(
            ChangeArgumentUnitInUnitDetails(
              argumentUnit: unit as UnitModel,
            ),
          );
        },
        onUnitsRemove: null,
        onUnitTapForRemoval: null,
        onUnitLongPress: null,
        itemIdsSelectedForRemoval: const [],
        removalModeAllowed: false,
        removalModeEnabled: false,
        markedUnitsForConversionVisible: false,
        markedUnitIdsForConversion: null,
        selectedUnitVisible: true,
        selectedUnitId: pageState.selectedArgUnit?.id,
        disabledUnitId: pageState.currentEditedUnit?.id,
        floatingButton: null,
      );
    });
  }
}
