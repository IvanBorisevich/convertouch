import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc_for_unit_details.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/ui/pages/templates/unit_groups_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitGroupsPageForUnitDetails extends StatelessWidget {
  const ConvertouchUnitGroupsPageForUnitDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return unitGroupsBlocBuilderForUnitDetails((pageState) {
      return ConvertouchUnitGroupsPage(
        pageTitle: "Group of New Unit",
        customLeadingIcon: null,
        unitGroups: pageState.unitGroups,
        onSearchStringChanged: (text) {
          BlocProvider.of<UnitGroupsBlocForUnitDetails>(context).add(
            FetchUnitGroupsForUnitDetails(
              currentUnitGroupInUnitDetails: pageState.unitGroupInUnitDetails!,
              searchString: text,
            ),
          );
        },
        onSearchReset: () {
          BlocProvider.of<UnitGroupsBlocForUnitDetails>(context).add(
            FetchUnitGroupsForUnitDetails(
              currentUnitGroupInUnitDetails: pageState.unitGroupInUnitDetails!,
              searchString: null,
            ),
          );
        },
        onUnitGroupTap: (unitGroup) {
          BlocProvider.of<UnitDetailsBloc>(context).add(
            ChangeGroupInUnitDetails(
              unitGroup: unitGroup as UnitGroupModel,
            ),
          );
        },
        onUnitGroupTapForRemoval: null,
        onUnitGroupLongPress: null,
        onUnitGroupsRemove: null,
        appBarRightWidgets: const [],
        selectedUnitGroupVisible: true,
        selectedUnitGroupId: pageState.unitGroupInUnitDetails?.id,
        disabledUnitGroupId: null,
        itemIdsSelectedForRemoval: const [],
        removalModeEnabled: false,
        removalModeAllowed: false,
        editableUnitGroupsVisible: false,
        floatingButton: null,
      );
    });
  }
}
