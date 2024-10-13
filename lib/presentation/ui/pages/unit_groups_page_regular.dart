import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_events.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/ui/pages/templates/unit_groups_page.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitGroupsPageRegular extends StatelessWidget {
  const ConvertouchUnitGroupsPageRegular({super.key});

  @override
  Widget build(BuildContext context) {
    final unitGroupsBloc = BlocProvider.of<UnitGroupsBloc>(context);
    final unitsBloc = BlocProvider.of<UnitsBloc>(context);
    final unitGroupDetailsBloc = BlocProvider.of<UnitGroupDetailsBloc>(context);
    final itemsSelectionBloc = BlocProvider.of<ItemsSelectionBloc>(context);
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);

    return appBlocBuilder(builderFunc: (appState) {
      ConvertouchColorScheme floatingButtonColor =
          unitGroupsPageFloatingButtonColors[appState.theme]!;
      ConvertouchColorScheme removalButtonColor =
          removalFloatingButtonColors[appState.theme]!;

      PageColorScheme pageColorScheme = pageColors[appState.theme]!;

      return unitGroupsBlocBuilder(
        bloc: unitGroupsBloc,
        builderFunc: (pageState) {
          return itemsSelectionBlocBuilder(
            bloc: itemsSelectionBloc,
            builderFunc: (itemsSelectionState) {
              return ConvertouchUnitGroupsPage(
                pageTitle: "Unit Groups",
                customLeadingIcon: itemsSelectionState.showCancelIcon
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: pageColorScheme.appBar.foreground.regular,
                        ),
                        onPressed: () {
                          itemsSelectionBloc.add(
                            const CancelItemsMarking(),
                          );
                        },
                      )
                    : null,
                unitGroups: pageState.unitGroups,
                onSearchStringChanged: (text) {
                  unitGroupsBloc.add(
                    FetchUnitGroups(searchString: text),
                  );
                },
                onSearchReset: () {
                  unitGroupsBloc.add(
                    const FetchUnitGroups(searchString: null),
                  );
                },
                onUnitGroupTap: (unitGroup) {
                  unitsBloc.add(
                    FetchUnits(
                      unitGroup: unitGroup,
                    ),
                  );
                  navigationBloc.add(
                    const NavigateToPage(
                      pageName: PageName.unitsPageRegular,
                    ),
                  );
                },
                onUnitGroupTapForRemoval: (unitGroup) {
                  itemsSelectionBloc.add(
                    SelectItem(id: unitGroup.id),
                  );
                },
                onUnitGroupLongPress: (unitGroup) {
                  if (!itemsSelectionState.showCancelIcon) {
                    itemsSelectionBloc.add(
                      StartItemsMarking(
                        showCancelIcon: true,
                        previouslyMarkedIds: [unitGroup.id],
                        excludedIds: pageState.unitGroups
                            .where((gr) => gr.oob)
                            .map((gr) => gr.id)
                            .toList(),
                      ),
                    );
                  }
                },
                onUnitGroupsRemove: null,
                appBarRightWidgets: const [],
                selectedUnitGroupVisible: false,
                selectedUnitGroupId: null,
                disabledUnitGroupIds: null,
                itemIdsSelectedForRemoval: itemsSelectionState.markedIds,
                removalModeEnabled: itemsSelectionState.showCancelIcon,
                removalModeAllowed: true,
                editableUnitGroupsVisible: true,
                floatingButton: itemsSelectionState.showCancelIcon
                    ? ConvertouchFloatingActionButton.removal(
                        visible: itemsSelectionState.markedIds.isNotEmpty,
                        extraLabelText:
                            itemsSelectionState.markedIds.length.toString(),
                        colorScheme: removalButtonColor,
                        onClick: () {
                          unitGroupsBloc.add(
                            RemoveUnitGroups(
                              ids: itemsSelectionState.markedIds,
                            ),
                          );
                        },
                      )
                    : ConvertouchFloatingActionButton.adding(
                        onClick: () {
                          unitGroupDetailsBloc.add(
                            const GetNewUnitGroupDetails(),
                          );
                        },
                        visible: true,
                        colorScheme: floatingButtonColor,
                      ),
              );
            },
          );
        },
      );
    });
  }
}
