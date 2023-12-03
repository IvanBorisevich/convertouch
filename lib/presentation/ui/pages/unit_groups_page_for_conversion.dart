import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_states.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/ui/pages/templates/unit_groups_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitGroupsPageForConversion extends StatelessWidget {
  const ConvertouchUnitGroupsPageForConversion({super.key});

  @override
  Widget build(BuildContext context) {
    return appBloc((appState) {
      return unitGroupsBlocForConversion((pageState) {
        String pageTitle = "Unit Groups";
        bool selectedUnitGroupVisible = false;
        int? selectedUnitGroupId;

        if (pageState is UnitGroupsFetchedForFirstAddingToConversion) {
          pageTitle = "Select Group";
        } else if (pageState is UnitGroupsFetchedForChangeInConversion) {
          pageTitle = "Change Group";
          selectedUnitGroupVisible = true;
          selectedUnitGroupId = pageState.currentUnitGroupInConversion.id;
        }

        return ConvertouchUnitGroupsPage(
          pageTitle: pageTitle,
          unitGroups: pageState.unitGroups,
          onUnitGroupTap: (item) {
            BlocProvider.of<UnitsBlocForConversion>(context).add(
              FetchUnitsToMarkForConversion(
                unitGroup: item as UnitGroupModel,
              ),
            );
            Navigator.of(context).pushNamed(unitsPageForConversion);
          },
          appBarRightWidgets: const [],
          selectedUnitGroupVisible: selectedUnitGroupVisible,
          selectedUnitGroupId: selectedUnitGroupId,
          removalModeAllowed: false,
          floatingButton: null,
        );
      });
    });
  }
}
