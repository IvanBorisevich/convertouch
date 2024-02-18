import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_states.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_states.dart';
import 'package:convertouch/presentation/ui/pages/templates/units_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/style/color/color_set.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsPageForConversion extends StatelessWidget {
  const ConvertouchUnitsPageForConversion({super.key});

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      ButtonColorSet floatingButtonColor =
          unitsPageFloatingButtonColors[appState.theme]!;

      return unitsBlocBuilderForConversion((pageState) {
        return MultiBlocListener(
          listeners: [
            unitGroupsBlocListener(
              handlers: [
                StateHandler<UnitGroupsFetched>((state) {
                  if (state.removedIds.contains(pageState.unitGroup.id)) {
                    Navigator.of(context).pop();
                  }
                }),
              ],
            ),
            unitsBlocListener(
              handlers: [
                StateHandler<UnitsFetched>((state) {
                  if (state.removedIds.isNotEmpty ||
                      state.modifiedUnit != null) {
                    if (pageState is UnitsFetchedToMarkForConversion) {
                      BlocProvider.of<UnitsBlocForConversion>(context).add(
                        FetchUnitsToMarkForConversion(
                          unitGroup: pageState.unitGroup,
                          unitsAlreadyMarkedForConversion:
                              pageState.unitsMarkedForConversion,
                          searchString: pageState.searchString,
                        ),
                      );
                    } else if (pageState is UnitsFetchedForChangeInConversion) {
                      BlocProvider.of<UnitsBlocForConversion>(context).add(
                        FetchUnitsForChangeInConversion(
                          currentSelectedUnit: pageState.selectedUnit,
                          unitGroup: pageState.unitGroup,
                          unitsInConversion: pageState.unitsMarkedForConversion,
                          searchString: pageState.searchString,
                        ),
                      );
                    }
                  }
                }),
              ],
            ),
          ],
          child: ConvertouchUnitsPage(
            pageTitle: pageState is UnitsFetchedForChangeInConversion
                ? 'Change Unit'
                : 'Add Units To Conversion',
            customLeadingIcon: null,
            units: pageState.units,
            onSearchStringChanged: (text) {
              if (pageState is UnitsFetchedToMarkForConversion) {
                BlocProvider.of<UnitsBlocForConversion>(context).add(
                  FetchUnitsToMarkForConversion(
                    unitGroup: pageState.unitGroup,
                    unitsAlreadyMarkedForConversion:
                        pageState.unitsMarkedForConversion,
                    currentSourceConversionItem:
                        pageState.currentSourceConversionItem,
                    searchString: text,
                  ),
                );
              } else if (pageState is UnitsFetchedForChangeInConversion) {
                BlocProvider.of<UnitsBlocForConversion>(context).add(
                  FetchUnitsForChangeInConversion(
                    currentSelectedUnit: pageState.selectedUnit,
                    unitGroup: pageState.unitGroup,
                    unitsInConversion: pageState.unitsMarkedForConversion,
                    currentSourceConversionItem:
                        pageState.currentSourceConversionItem,
                    searchString: text,
                  ),
                );
              }
            },
            onSearchReset: () {
              if (pageState is UnitsFetchedToMarkForConversion) {
                BlocProvider.of<UnitsBlocForConversion>(context).add(
                  FetchUnitsToMarkForConversion(
                    unitGroup: pageState.unitGroup,
                    unitsAlreadyMarkedForConversion:
                        pageState.unitsMarkedForConversion,
                    currentSourceConversionItem:
                        pageState.currentSourceConversionItem,
                    searchString: null,
                  ),
                );
              } else if (pageState is UnitsFetchedForChangeInConversion) {
                BlocProvider.of<UnitsBlocForConversion>(context).add(
                  FetchUnitsForChangeInConversion(
                    currentSelectedUnit: pageState.selectedUnit,
                    unitGroup: pageState.unitGroup,
                    unitsInConversion: pageState.unitsMarkedForConversion,
                    currentSourceConversionItem:
                        pageState.currentSourceConversionItem,
                    searchString: null,
                  ),
                );
              }
            },
            onUnitTap: (unit) {
              if (pageState is UnitsFetchedToMarkForConversion) {
                BlocProvider.of<UnitsBlocForConversion>(context).add(
                  FetchUnitsToMarkForConversion(
                    unitGroup: pageState.unitGroup,
                    unitsAlreadyMarkedForConversion:
                        pageState.unitsMarkedForConversion,
                    unitNewlyMarkedForConversion: unit as UnitModel,
                    currentSourceConversionItem:
                        pageState.currentSourceConversionItem,
                    searchString: pageState.searchString,
                  ),
                );
              } else if (pageState is UnitsFetchedForChangeInConversion &&
                  pageState.unitsMarkedForConversion
                      .none((markedUnit) => markedUnit.id == unit.id)) {
                BlocProvider.of<ConversionBloc>(context).add(
                  RebuildConversionAfterUnitReplacement(
                    oldUnit: pageState.selectedUnit,
                    newUnit: unit as UnitModel,
                    conversionParams: InputConversionModel(
                      unitGroup: pageState.unitGroup,
                      sourceConversionItem:
                          pageState.currentSourceConversionItem,
                      targetUnits: pageState.unitsMarkedForConversion,
                    ),
                  ),
                );
                Navigator.of(context).pop();
              }
            },
            onUnitTapForRemoval: null,
            onUnitLongPress: null,
            onUnitsRemove: null,
            itemIdsSelectedForRemoval: const [],
            removalModeAllowed: false,
            removalModeEnabled: false,
            appBarRightWidgets: const [],
            markedUnitsForConversionVisible: true,
            markedUnitIdsForConversion: pageState.unitsMarkedForConversion
                .map((unit) => unit.id!)
                .toList(),
            selectedUnitVisible: pageState is UnitsFetchedForChangeInConversion,
            selectedUnitId: pageState is UnitsFetchedForChangeInConversion
                ? pageState.selectedUnit.id
                : null,
            disabledUnitId: null,
            floatingButton: ConvertouchFloatingActionButton(
              icon: Icons.check_outlined,
              visible: pageState is UnitsFetchedToMarkForConversion
                  ? pageState.allowUnitsToBeAddedToConversion
                  : false,
              onClick: () {
                BlocProvider.of<ConversionBloc>(context).add(
                  BuildConversion(
                    conversionParams: InputConversionModel(
                      unitGroup: pageState.unitGroup,
                      sourceConversionItem:
                          pageState.currentSourceConversionItem,
                      targetUnits: pageState.unitsMarkedForConversion,
                    ),
                  ),
                );
                Navigator.of(context).popUntil(
                  (route) => route.isFirst,
                );
              },
              colorSet: floatingButtonColor,
            ),
          ),
        );
      });
    });
  }
}
