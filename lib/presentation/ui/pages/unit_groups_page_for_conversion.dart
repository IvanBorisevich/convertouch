import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
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
    return unitGroupsBlocBuilderForConversion((pageState) {
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

      return MultiBlocListener(
        listeners: [
          unitGroupsBlocListener([
            StateHandler<UnitGroupsFetched>((state) {
              if (state.removedIds.isNotEmpty ||
                  state.modifiedUnitGroup != null) {
                if (pageState is UnitGroupsFetchedForFirstAddingToConversion) {
                  BlocProvider.of<UnitGroupsBlocForConversion>(context).add(
                    FetchUnitGroupsForFirstAddingToConversion(
                      searchString: pageState.searchString,
                    ),
                  );
                } else if (pageState
                    is UnitGroupsFetchedForChangeInConversion) {
                  BlocProvider.of<UnitGroupsBlocForConversion>(context).add(
                    FetchUnitGroupsForChangeInConversion(
                      currentUnitGroupInConversion:
                          pageState.currentUnitGroupInConversion,
                      searchString: pageState.searchString,
                    ),
                  );
                }
              }
            }),
          ]),
        ],
        child: ConvertouchUnitGroupsPage(
          pageTitle: pageTitle,
          customLeadingIcon: null,
          unitGroups: pageState.unitGroups,
          onSearchStringChanged: (text) {
            if (pageState is UnitGroupsFetchedForFirstAddingToConversion) {
              BlocProvider.of<UnitGroupsBlocForConversion>(context).add(
                FetchUnitGroupsForFirstAddingToConversion(
                  searchString: text,
                ),
              );
            } else if (pageState is UnitGroupsFetchedForChangeInConversion) {
              BlocProvider.of<UnitGroupsBlocForConversion>(context).add(
                FetchUnitGroupsForChangeInConversion(
                  currentUnitGroupInConversion:
                      pageState.currentUnitGroupInConversion,
                  searchString: text,
                ),
              );
            }
          },
          onSearchReset: () {
            if (pageState is UnitGroupsFetchedForFirstAddingToConversion) {
              BlocProvider.of<UnitGroupsBlocForConversion>(context).add(
                const FetchUnitGroupsForFirstAddingToConversion(
                  searchString: null,
                ),
              );
            } else if (pageState is UnitGroupsFetchedForChangeInConversion) {
              BlocProvider.of<UnitGroupsBlocForConversion>(context).add(
                FetchUnitGroupsForChangeInConversion(
                  currentUnitGroupInConversion:
                      pageState.currentUnitGroupInConversion,
                  searchString: null,
                ),
              );
            }
          },
          onUnitGroupTap: (unitGroup) {
            BlocProvider.of<UnitsBlocForConversion>(context).add(
              FetchUnitsToMarkForConversion(
                unitGroup: unitGroup as UnitGroupModel,
                searchString: null,
              ),
            );
            Navigator.of(context).pushNamed(
              PageName.unitsPageForConversion.name,
            );
          },
          onUnitGroupTapForRemoval: null,
          onUnitGroupLongPress: null,
          onUnitGroupsRemove: null,
          itemIdsSelectedForRemoval: const [],
          appBarRightWidgets: const [],
          selectedUnitGroupVisible: selectedUnitGroupVisible,
          selectedUnitGroupId: selectedUnitGroupId,
          disabledUnitGroupId: null,
          removalModeEnabled: false,
          removalModeAllowed: false,
          floatingButton: null,
        ),
      );
    });
  }
}
