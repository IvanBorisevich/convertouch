import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/app/app_bloc.dart';
import 'package:convertouch/presentation/bloc/app/app_events.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_creation/unit_creation_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_creation/unit_creation_events.dart';
import 'package:convertouch/presentation/bloc/units/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units/units_events.dart';
import 'package:convertouch/presentation/bloc/units_conversion/units_conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/units_conversion/units_conversion_events.dart';
import 'package:convertouch/presentation/pages/items_view/menu_items_view.dart';
import 'package:convertouch/presentation/pages/scaffold/scaffold.dart';
import 'package:convertouch/presentation/pages/scaffold/search_bar.dart';
import 'package:convertouch/presentation/pages/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsPage extends StatefulWidget {
  const ConvertouchUnitsPage({super.key});

  @override
  State createState() => _ConvertouchUnitsPageState();
}

class _ConvertouchUnitsPageState extends State<ConvertouchUnitsPage> {
  late ConvertouchAction? action;

  @override
  Widget build(BuildContext context) {
    action = ModalRoute.of(context)!.settings.arguments as ConvertouchAction?;

    return appBloc((appState) {
      return unitsBloc((unitsFetched) {
        return ConvertouchScaffold(
            pageTitle: [
              ConvertouchAction.fetchUnitsToSelectForConversion,
              ConvertouchAction.fetchUnitsToSelectForUnitCreation,
            ].contains(action)
                ? "Select Unit"
                : unitsFetched.unitGroup.name,
            appBarRightWidgets: [
              checkIcon(
                context,
                isVisible: [
                  ConvertouchAction.fetchUnitsToStartMark,
                  ConvertouchAction.fetchUnitsToContinueMark,
                ].contains(action),
                isEnabled: unitsFetched.useMarkedUnitsInConversion,
                onPressedFunc: () {
                  BlocProvider.of<UnitsConversionBloc>(context).add(
                    InitializeConversion(
                      inputValue: unitsFetched.inputValue ?? 1,
                      inputUnit: unitsFetched.selectedUnit,
                      conversionUnits: unitsFetched.markedUnits,
                      unitGroup: unitsFetched.unitGroup,
                    ),
                  );
                },
                color: scaffoldColor[ConvertouchUITheme.light]!,
              ),
            ],
            secondaryAppBar: const ConvertouchSearchBar(
              placeholder: "Search units...",
            ),
            body: itemsViewModeBloc((itemsViewModeState) {
              return ConvertouchMenuItemsView(
                unitsFetched.units,
                markedItems: unitsFetched.markedUnits,
                showMarkedItems: action !=
                    ConvertouchAction.fetchUnitsToSelectForUnitCreation,
                selectedItemId: unitsFetched.selectedUnit?.id,
                showSelectedItem: [
                  ConvertouchAction.fetchUnitsToSelectForUnitCreation,
                  ConvertouchAction.fetchUnitsToSelectForConversion,
                ].contains(action),
                viewMode: itemsViewModeState.pageViewMode,
                markItemsOnTap: [
                  ConvertouchAction.fetchUnitsToStartMark,
                  ConvertouchAction.fetchUnitsToContinueMark,
                ].contains(action),
                removalModeAllowed: [
                  ConvertouchAction.fetchUnitsToStartMark,
                  ConvertouchAction.fetchUnitsToContinueMark,
                ].contains(action),
                onItemTap: (item) {
                  switch (action) {
                    case ConvertouchAction.fetchUnitsToSelectForUnitCreation:
                      BlocProvider.of<UnitCreationBloc>(context).add(
                        PrepareUnitCreation(
                          unitGroup: unitsFetched.unitGroup,
                          equivalentUnit: item as UnitModel,
                          markedUnits: unitsFetched.markedUnits,
                          action: ConvertouchAction
                              .updateEquivalentUnitForUnitCreation,
                        ),
                      );
                      break;
                    case ConvertouchAction.fetchUnitsToSelectForConversion:
                      BlocProvider.of<UnitsConversionBloc>(context).add(
                        InitializeConversion(
                          inputUnit: item as UnitModel,
                          inputValue: unitsFetched.inputValue,
                          prevInputUnit: unitsFetched.selectedUnit,
                          unitGroup: unitsFetched.unitGroup,
                          conversionUnits: unitsFetched.markedUnits,
                        ),
                      );
                      break;
                    case ConvertouchAction.fetchUnitsToStartMark:
                    case ConvertouchAction.fetchUnitsToContinueMark:
                    default:
                      BlocProvider.of<UnitsBloc>(context).add(
                        FetchUnits(
                          inputValue: unitsFetched.inputValue,
                          unitGroupId: unitsFetched.unitGroup.id!,
                          newMarkedUnit: item as UnitModel,
                          markedUnits: unitsFetched.markedUnits,
                          action: ConvertouchAction.fetchUnitsToContinueMark,
                        ),
                      );
                      break;
                  }
                },
              );
            }),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                BlocProvider.of<UnitCreationBloc>(context).add(
                  PrepareUnitCreation(
                    unitGroup: unitsFetched.unitGroup,
                    equivalentUnit: unitsFetched.selectedUnit,
                    markedUnits: unitsFetched.markedUnits,
                    action: ConvertouchAction.initUnitCreationParams,
                  ),
                );
              },
              backgroundColor:
                  unitsPageFloatingButtonColor[ConvertouchUITheme.light],
              elevation: 0,
              child: const Icon(Icons.add),
            ),
            floatingActionButtonVisible: ![
              ConvertouchAction.fetchUnitsToSelectForConversion,
              ConvertouchAction.fetchUnitsToSelectForUnitCreation,
            ].contains(action),
            onFloatingButtonForRemovalClick: () {
              BlocProvider.of<UnitsBloc>(context).add(
                RemoveUnits(
                  ids: appState.selectedItemIdsForRemoval,
                  unitGroup: unitsFetched.unitGroup,
                  markedUnits: unitsFetched.markedUnits,
                ),
              );
              // BlocProvider.of<UnitsConversionBloc>(context).add(
              //   InitializeConversion(
              //     conversionUnits: unitsFetched.markedUnits,
              //     unitGroup: unitsFetched.unitGroup,
              //     inputValue: unitsFetched.inputValue,
              //     inputUnit: unitsFetched.selectedUnit,
              //   ),
              // );
              BlocProvider.of<AppBloc>(context).add(
                const DisableRemovalMode(),
              );
            });
      });
    });
  }
}
