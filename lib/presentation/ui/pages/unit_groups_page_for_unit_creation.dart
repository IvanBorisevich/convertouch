import 'package:convertouch/domain/model/input/items_search_events.dart';
import 'package:convertouch/domain/model/input/unit_creation_events.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/items_search_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_creation_bloc.dart';
import 'package:convertouch/presentation/ui/pages/templates/unit_groups_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitGroupsPageForUnitCreation extends StatelessWidget {
  const ConvertouchUnitGroupsPageForUnitCreation({super.key});

  @override
  Widget build(BuildContext context) {
    return unitGroupsBlocForUnitCreation((pageState) {
      return unitGroupsSearchBlocForUnitCreation((foundUnitGroups) {
        return ConvertouchUnitGroupsPage(
          pageTitle: "Group of New Unit",
          unitGroups: foundUnitGroups ?? pageState.unitGroups,
          onSearchStringChanged: (text) {
            BlocProvider.of<UnitGroupsSearchBlocForUnitCreation>(context).add(
              SearchUnitGroups(searchString: text),
            );
          },
          onUnitGroupTap: (unitGroup) {
            BlocProvider.of<UnitCreationBloc>(context).add(
              PrepareUnitCreation(
                unitGroup: unitGroup as UnitGroupModel,
                baseUnit: null,
              ),
            );
            Navigator.of(context).pop();
          },
          onUnitGroupTapForRemoval: null,
          onUnitGroupLongPress: null,
          onUnitGroupsRemove: null,
          appBarRightWidgets: const [],
          selectedUnitGroupVisible: true,
          selectedUnitGroupId: pageState.unitGroupInUnitCreation?.id,
          itemIdsSelectedForRemoval: const [],
          removalModeEnabled: false,
          removalModeAllowed: false,
          floatingButton: null,
        );
      });
    });
  }
}
