import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/presenter/bloc/unit_creation_bloc.dart';
import 'package:convertouch/presenter/bloc/units_conversion_bloc.dart';
import 'package:convertouch/presenter/bloc/units_bloc.dart';
import 'package:convertouch/presenter/events/unit_creation_events.dart';
import 'package:convertouch/presenter/events/units_conversion_events.dart';
import 'package:convertouch/presenter/events/units_events.dart';
import 'package:convertouch/view/items_view/menu_items_view.dart';
import 'package:convertouch/view/scaffold/bloc_wrappers.dart';
import 'package:convertouch/view/scaffold/scaffold.dart';
import 'package:convertouch/view/scaffold/search_bar.dart';
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
    action =
        ModalRoute.of(context)!.settings.arguments as ConvertouchAction?;

    return unitsBloc((unitsFetched) {
      return ConvertouchScaffold(
        pageTitle: action == ConvertouchAction.fetchUnitsToSelectForConversion
                || action == ConvertouchAction.fetchUnitsToSelectForUnitCreation
            ? "Select Unit"
            : unitsFetched.unitGroup.name,
        appBarRightWidgets: [
          checkIcon(
            context,
            isVisible: action == ConvertouchAction.fetchUnitsToStartMark ||
                action == ConvertouchAction.fetchUnitsToContinueMark,
            isEnabled: unitsFetched.useMarkedUnitsInConversion,
            onPressedFunc: () {
              BlocProvider.of<UnitsConversionBloc>(context).add(
                InitializeConversion(
                  inputValue: unitsFetched.inputValue,
                  inputUnit: unitsFetched.selectedUnit,
                  conversionUnits: unitsFetched.markedUnits!,
                  unitGroup: unitsFetched.unitGroup,
                ),
              );
            },
          ),
        ],
        body: Column(
          children: [
            const ConvertouchSearchBar(placeholder: "Search units..."),
            Expanded(child: itemsViewModeBloc((itemsViewModeState) {
              return ConvertouchMenuItemsView(
                unitsFetched.units,
                markedItems: unitsFetched.markedUnits,
                showMarkedItems: action !=
                    ConvertouchAction.fetchUnitsToSelectForUnitCreation,
                selectedItemId: unitsFetched.selectedUnit?.id,
                showSelectedItem: action ==
                        ConvertouchAction.fetchUnitsToSelectForUnitCreation ||
                    action == ConvertouchAction.fetchUnitsToSelectForConversion,
                viewMode: itemsViewModeState.pageViewMode,
                markItemsOnTap:
                    action == ConvertouchAction.fetchUnitsToStartMark ||
                        action == ConvertouchAction.fetchUnitsToContinueMark,
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
                          conversionUnits: unitsFetched.markedUnits!,
                        ),
                      );
                      break;
                    case ConvertouchAction.fetchUnitsToStartMark:
                    case ConvertouchAction.fetchUnitsToContinueMark:
                    default:
                      BlocProvider.of<UnitsBloc>(context).add(
                        FetchUnits(
                          unitGroupId: unitsFetched.unitGroup.id,
                          newMarkedUnit: item as UnitModel,
                          markedUnits: unitsFetched.markedUnits,
                          action: ConvertouchAction.fetchUnitsToContinueMark,
                        ),
                      );
                      break;
                  }
                },
              );
            })),
          ],
        ),
        floatingActionButton: Visibility(
          visible:
              action != ConvertouchAction.fetchUnitsToSelectForConversion &&
                  action != ConvertouchAction.fetchUnitsToSelectForUnitCreation,
          child: FloatingActionButton(
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
            backgroundColor: const Color(0xFF5499DA),
            elevation: 0,
            child: const Icon(Icons.add),
          ),
        ),
      );
    });
  }
}
