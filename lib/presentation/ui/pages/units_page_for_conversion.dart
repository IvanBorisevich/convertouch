import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_bloc.dart';
import 'package:convertouch/presentation/bloc/common/items_selection/items_selection_events.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_bloc.dart';
import 'package:convertouch/presentation/bloc/common/navigation/navigation_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/ui/pages/templates/units_page.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsPageForConversion extends StatelessWidget {
  const ConvertouchUnitsPageForConversion({super.key});

  @override
  Widget build(BuildContext context) {
    final unitsBloc = BlocProvider.of<UnitsBlocForConversion>(context);
    final unitsSelectionBloc =
        BlocProvider.of<ItemsSelectionBlocForConversion>(context);
    final conversionBloc = BlocProvider.of<ConversionBloc>(context);
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);

    return appBlocBuilder(
      builderFunc: (appState) {
        ConvertouchColorScheme floatingButtonColor =
            unitsPageFloatingButtonColors[appState.theme]!;

        return unitsBlocBuilder(
          bloc: unitsBloc,
          builderFunc: (pageState) {
            return itemsSelectionBlocBuilder(
              bloc: unitsSelectionBloc,
              builderFunc: (itemsSelectionState) {
                return ConvertouchUnitsPage(
                  pageTitle: itemsSelectionState.singleItemSelectionMode
                      ? 'Change Unit'
                      : 'Add Units To Conversion',
                  customLeadingIcon: null,
                  units: pageState.units,
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
                    unitsSelectionBloc.add(
                      SelectItem(
                        id: unit.id,
                      ),
                    );
                    if (itemsSelectionState.singleItemSelectionMode) {
                      conversionBloc.add(
                        ReplaceConversionItemUnit(
                          newUnit: unit,
                          oldUnitId: itemsSelectionState.selectedId!,
                        ),
                      );
                      navigationBloc.add(const NavigateBack());
                    }
                  },
                  onUnitTapForRemoval: null,
                  onUnitLongPress: null,
                  onUnitsRemove: null,
                  itemIdsSelectedForRemoval: const [],
                  removalModeAllowed: false,
                  removalModeEnabled: false,
                  editableUnitsVisible: false,
                  appBarRightWidgets: const [],
                  markedUnitsForConversionVisible: true,
                  markedUnitIdsForConversion: itemsSelectionState.markedIds,
                  selectedUnitVisible:
                      itemsSelectionState.singleItemSelectionMode,
                  selectedUnitId: itemsSelectionState.selectedId,
                  disabledUnitIds: itemsSelectionState.excludedIds,
                  floatingButton: ConvertouchFloatingActionButton(
                    icon: Icons.check_outlined,
                    visible: itemsSelectionState.canMarkedItemsBeSelected,
                    onClick: () {
                      conversionBloc.add(
                        AddUnitsToConversion(
                          unitIds: itemsSelectionState.markedIds,
                        ),
                      );
                      navigationBloc.add(const NavigateBack());
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
