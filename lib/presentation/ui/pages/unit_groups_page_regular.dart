import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/ui/pages/templates/unit_groups_page.dart';
import 'package:convertouch/presentation/ui/widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitGroupsPageRegular extends StatelessWidget {
  const ConvertouchUnitGroupsPageRegular({super.key});

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      ConvertouchColorScheme floatingButtonColor =
          unitGroupsPageFloatingButtonColors[appState.theme]!;
      ConvertouchColorScheme removalButtonColor =
          removalFloatingButtonColors[appState.theme]!;

      PageColorScheme pageColorScheme = pageColors[appState.theme]!;

      return unitGroupsBlocBuilder((pageState) {
        return ConvertouchUnitGroupsPage(
          pageTitle: "Unit Groups",
          customLeadingIcon: pageState.removalMode
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: pageColorScheme.appBar.foreground.regular,
                  ),
                  onPressed: () {
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
          disabledUnitGroupId: null,
          itemIdsSelectedForRemoval: pageState.markedIdsForRemoval,
          removalModeEnabled: pageState.removalMode,
          removalModeAllowed: true,
          editableUnitGroupsVisible: true,
          floatingButton: pageState.removalMode
              ? ConvertouchFloatingActionButton.removal(
                  visible: pageState.markedIdsForRemoval.isNotEmpty,
                  extraLabelText:
                      pageState.markedIdsForRemoval.length.toString(),
                  colorScheme: removalButtonColor,
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
                    BlocProvider.of<UnitGroupDetailsBloc>(context).add(
                      const GetNewUnitGroupDetails(),
                    );
                  },
                  visible: true,
                  colorScheme: floatingButtonColor,
                ),
        );
      });
    });
  }
}
