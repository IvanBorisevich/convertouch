import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_events.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_details_page/unit_details_events.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_group_details_page/unit_group_details_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/ui/pages/templates/units_page.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/cancel_items_selection_icon.dart';
import 'package:convertouch/presentation/ui/widgets/floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsPageRegular extends StatelessWidget {
  const ConvertouchUnitsPageRegular({super.key});

  @override
  Widget build(BuildContext context) {
    final unitsBloc = BlocProvider.of<UnitsBloc>(context);
    final unitsSelectionBloc = BlocProvider.of<ItemsSelectionBloc>(context);
    final unitGroupDetailsBloc = BlocProvider.of<UnitGroupDetailsBloc>(context);
    final unitDetailsBloc = BlocProvider.of<UnitDetailsBloc>(context);

    return appBlocBuilder(
      builderFunc: (appState) {
        PageColorScheme pageColorScheme = pageColors[appState.theme]!;
        ConvertouchColorScheme floatingButtonColor =
            unitsPageFloatingButtonColors[appState.theme]!;
        ConvertouchColorScheme removalButtonColor =
            removalFloatingButtonColors[appState.theme]!;

        return unitsBlocBuilder(
          bloc: unitsBloc,
          builderFunc: (pageState) {
            return itemsSelectionBlocBuilder(
              bloc: unitsSelectionBloc,
              builderFunc: (itemsSelectionState) {
                return ConvertouchUnitsPage(
                  pageTitle: pageState.unitGroup.name,
                  units: pageState.units,
                  customLeadingIcon: itemsSelectionState.showCancelIcon
                      ? CancelItemsSelectionIcon(
                          bloc: unitsSelectionBloc,
                          pageColorScheme: pageColorScheme,
                        )
                      : null,
                  appBarRightWidgets: [
                    IconButton(
                      onPressed: () {
                        unitGroupDetailsBloc.add(
                          GetExistingUnitGroupDetails(
                            unitGroup: pageState.unitGroup,
                          ),
                        );
                      },
                      icon: Icon(
                        pageState.unitGroup.oob
                            ? Icons.info_outline_rounded
                            : Icons.edit_outlined,
                        color: pageColorScheme.appBar.foreground.regular,
                      ),
                    )
                  ],
                  onSearchStringChanged: (text) {
                    unitsBloc.add(
                      FetchUnits(
                        unitGroup: pageState.unitGroup,
                        searchString: text,
                      ),
                    );
                  },
                  onSearchReset: () {
                    unitsBloc.add(
                      FetchUnits(
                        unitGroup: pageState.unitGroup,
                      ),
                    );
                  },
                  onUnitTap: (unit) {
                    unitDetailsBloc.add(
                      GetExistingUnitDetails(
                        unit: unit,
                        unitGroup: pageState.unitGroup,
                      ),
                    );
                  },
                  onUnitTapForRemoval: (unit) {
                    unitsSelectionBloc.add(
                      SelectItem(
                        id: unit.id,
                      ),
                    );
                  },
                  onUnitLongPress: (unit) {
                    if (!itemsSelectionState.showCancelIcon) {
                      unitsSelectionBloc.add(
                        StartItemsMarking(
                          showCancelIcon: true,
                          previouslyMarkedIds: [unit.id],
                          excludedIds: pageState.units
                              .where((unit) => unit.oob)
                              .map((unit) => unit.id)
                              .toList(),
                        ),
                      );
                    }
                  },
                  onUnitsRemove: null,
                  itemIdsSelectedForRemoval: itemsSelectionState.markedIds,
                  removalModeAllowed: true,
                  removalModeEnabled: itemsSelectionState.showCancelIcon,
                  editableUnitsVisible: true,
                  markedUnitsForConversionVisible: false,
                  markedUnitIdsForConversion: null,
                  selectedUnitVisible: false,
                  selectedUnitId: null,
                  disabledUnitIds: null,
                  floatingButton: itemsSelectionState.showCancelIcon
                      ? ConvertouchFloatingActionButton.removal(
                          visible: itemsSelectionState.markedIds.isNotEmpty,
                          extraLabelText:
                              itemsSelectionState.markedIds.length.toString(),
                          colorScheme: removalButtonColor,
                          onClick: () {
                            unitsBloc.add(
                              RemoveUnits(
                                ids: itemsSelectionState.markedIds,
                                unitGroup: pageState.unitGroup,
                              ),
                            );
                          },
                        )
                      : ConvertouchFloatingActionButton.adding(
                          visible: !pageState.unitGroup.refreshable &&
                              pageState.unitGroup.conversionType !=
                                  ConversionType.formula,
                          onClick: () {
                            unitDetailsBloc.add(
                              GetNewUnitDetails(
                                unitGroup: pageState.unitGroup,
                              ),
                            );
                          },
                          colorScheme: floatingButtonColor,
                        ),
                );
              },
            );
          },
        );
      },
    );
  }
}
