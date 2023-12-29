import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/input/unit_groups_events.dart';
import 'package:convertouch/domain/model/input/units_events.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/units_bloc.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/pages/templates/unit_groups_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color.dart';
import 'package:convertouch/presentation/ui/style/model/color_variation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitGroupsPageRegular extends StatelessWidget {
  const ConvertouchUnitGroupsPageRegular({super.key});

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      ButtonColorVariation floatingButtonColor =
          unitGroupsPageFloatingButtonColors[appState.theme]!;
      ButtonColorVariation removalButtonColor =
          removalFloatingButtonColors[appState.theme]!;
      ConvertouchScaffoldColor scaffoldColor = scaffoldColors[appState.theme]!;

      return unitGroupsBlocBuilder((pageState) {
        return ConvertouchUnitGroupsPage(
          pageTitle: "Unit Groups",
          customLeadingIcon: pageState.removalMode
              ? leadingIcon(
                  icon: Icons.clear,
                  color: scaffoldColor.regular,
                  onClick: () {
                    BlocProvider.of<UnitGroupsBloc>(context).add(
                      const DisableUnitGroupsRemovalMode(),
                    );
                  },
                )
              : null,
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
            BlocProvider.of<UnitGroupsBloc>(context).add(
              FetchUnitGroupsToMarkForRemoval(
                newMarkedId: unitGroup.id!,
                alreadyMarkedIds: pageState.markedIdsForRemoval,
                searchString: pageState.searchString,
              ),
            );
          },
          onUnitGroupLongPress: (unitGroup) {
            if (!pageState.removalMode) {
              BlocProvider.of<UnitGroupsBloc>(context).add(
                FetchUnitGroupsToMarkForRemoval(
                  newMarkedId: unitGroup.id!,
                  alreadyMarkedIds: pageState.markedIdsForRemoval,
                  searchString: pageState.searchString,
                ),
              );
            }
          },
          onUnitGroupsRemove: null,
          appBarRightWidgets: const [],
          selectedUnitGroupVisible: false,
          selectedUnitGroupId: null,
          itemIdsSelectedForRemoval: pageState.markedIdsForRemoval,
          removalModeEnabled: pageState.removalMode,
          removalModeAllowed: true,
          floatingButton: pageState.removalMode
              ? ConvertouchFloatingActionButton.removal(
                  visible: pageState.markedIdsForRemoval.isNotEmpty,
                  extraLabelText:
                      pageState.markedIdsForRemoval.length.toString(),
                  background: removalButtonColor.background,
                  foreground: removalButtonColor.foreground,
                  border: scaffoldColor.regular.backgroundColor,
                  onClick: () {
                    BlocProvider.of<UnitGroupsBloc>(context).add(
                      RemoveUnitGroups(
                        ids: pageState.markedIdsForRemoval,
                      ),
                    );
                  },
                )
              : ConvertouchFloatingActionButton.adding(
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
