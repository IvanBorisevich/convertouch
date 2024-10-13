import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/ui/pages/templates/unit_groups_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitGroupsPageForUnitDetails extends StatelessWidget {
  const ConvertouchUnitGroupsPageForUnitDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final unitGroupsBloc =
        BlocProvider.of<UnitGroupsBlocForUnitDetails>(context);
    final unitGroupSelectionBloc =
        BlocProvider.of<ItemsSelectionBlocForUnitDetails>(context);
    final unitDetailsBloc = BlocProvider.of<UnitDetailsBloc>(context);

    return unitGroupsBlocBuilder(
      bloc: unitGroupsBloc,
      builderFunc: (pageState) {
        return itemsSelectionBlocBuilder(
            bloc: unitGroupSelectionBloc,
            builderFunc: (itemsSelectionState) {
              return ConvertouchUnitGroupsPage(
                pageTitle: "Group of New Unit",
                customLeadingIcon: null,
                unitGroups: pageState.unitGroups,
                onSearchStringChanged: (text) {
                  unitGroupsBloc.add(
                    FetchUnitGroups(
                      searchString: text,
                    ),
                  );
                },
                onSearchReset: () {
                  unitGroupsBloc.add(
                    const FetchUnitGroups(),
                  );
                },
                onUnitGroupTap: (unitGroup) {
                  unitDetailsBloc.add(
                    ChangeGroupInUnitDetails(
                      unitGroup: unitGroup,
                    ),
                  );
                },
                onUnitGroupTapForRemoval: null,
                onUnitGroupLongPress: null,
                onUnitGroupsRemove: null,
                appBarRightWidgets: const [],
                selectedUnitGroupVisible: true,
                selectedUnitGroupId: itemsSelectionState.selectedId,
                disabledUnitGroupIds: null,
                itemIdsSelectedForRemoval: const [],
                removalModeEnabled: false,
                removalModeAllowed: false,
                editableUnitGroupsVisible: false,
                floatingButton: null,
              );
            });
      },
    );
  }
}
