import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/input/app_event.dart';
import 'package:convertouch/domain/model/input/unit_groups_events.dart';
import 'package:convertouch/domain/model/input/units_events.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/app_bloc.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/units_bloc.dart';
import 'package:convertouch/presentation/ui/pages/templates/unit_groups_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color_variation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitGroupsPageRegular extends StatelessWidget {
  const ConvertouchUnitGroupsPageRegular({super.key});

  @override
  Widget build(BuildContext context) {
    return appBloc((appState) {
      FloatingButtonColorVariation floatingButtonColor =
          unitGroupsPageFloatingButtonColors[appState.theme]!;

      return unitGroupsBloc((pageState) {
        return ConvertouchUnitGroupsPage(
          pageTitle: "Unit Groups",
          unitGroups: pageState.unitGroups,
          onSearchStringChanged: (text) {
            BlocProvider.of<UnitGroupsBloc>(context).add(
              FetchUnitGroups(searchString: text),
            );
          },
          onSearchReset: () {
            BlocProvider.of<UnitGroupsBloc>(context).add(
              const FetchUnitGroups(searchString: null),
            );
          },
          onUnitGroupTap: (unitGroup) {
            BlocProvider.of<UnitsBloc>(context).add(
              FetchUnits(
                unitGroup: unitGroup as UnitGroupModel,
                searchString: null,
              ),
            );
            Navigator.of(context).pushNamed(unitsPageRegular);
          },
          onUnitGroupTapForRemoval: (unitGroup) {
            BlocProvider.of<AppBloc>(context).add(
              SelectMenuItemForRemoval(
                itemId: unitGroup.id!,
                selectedItemIdsForRemoval: appState.selectedItemIdsForRemoval,
              ),
            );
          },
          onUnitGroupLongPress: (unitGroup) {
            if (!appState.removalMode) {
              BlocProvider.of<AppBloc>(context).add(
                SelectMenuItemForRemoval(
                  itemId: unitGroup.id!,
                ),
              );
            }
          },
          onUnitGroupsRemove: () {
            BlocProvider.of<UnitGroupsBloc>(context).add(
              RemoveUnitGroups(
                ids: appState.selectedItemIdsForRemoval,
              ),
            );
          },
          appBarRightWidgets: const [],
          selectedUnitGroupVisible: false,
          selectedUnitGroupId: null,
          itemIdsSelectedForRemoval: appState.selectedItemIdsForRemoval,
          removalModeEnabled: appState.removalMode,
          removalModeAllowed: true,
          floatingButton: ConvertouchFloatingActionButton.adding(
            onClick: () {
              Navigator.of(context).pushNamed(unitGroupCreationPage);
            },
            visible: true,
            background: floatingButtonColor.background,
            foreground: floatingButtonColor.foreground,
          ),
        );
      });
    });
  }
}
