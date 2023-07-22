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

  @override
  Widget build(BuildContext context) {
    final ItemClickAction? itemClickAction =
        ModalRoute.of(context)!.settings.arguments as ItemClickAction?;

    return unitsBloc((unitsFetched) {
      return ConvertouchScaffold(
        pageTitle: itemClickAction == ItemClickAction.select
            ? "Select Unit"
            : unitsFetched.unitGroup.name,
        appBarRightWidgets: [
          checkIcon(
            context,
            isVisible: itemClickAction == ItemClickAction.mark,
            isEnabled: unitsFetched.canMarkedUnitsBeSelected,
            onPressedFunc: () {
              BlocProvider.of<UnitsConversionBloc>(context).add(
                InitializeConversion(
                  targetUnitIds: unitsFetched.markedUnitIds!,
                  unitGroup: unitsFetched.unitGroup,
                ),
              );
            },
          )
        ],
        body: Column(
          children: [
            const ConvertouchSearchBar(placeholder: "Search units..."),
            Expanded(child: itemsViewModeBloc((itemsViewModeState) {
              return ConvertouchMenuItemsView(
                unitsFetched.units,
                markedItemIds: unitsFetched.markedUnitIdsForPage,
                viewMode: itemsViewModeState.pageViewMode,
                onItemTap: (item) {
                  switch (itemClickAction) {
                    case ItemClickAction.select:
                      BlocProvider.of<UnitCreationBloc>(context).add(
                        PrepareUnitCreation(
                          unitGroup: unitsFetched.unitGroup,
                          equivalentUnit: item as UnitModel,
                          markedUnitIds: unitsFetched.markedUnitIds,
                        ),
                      );
                      break;
                    case ItemClickAction.mark:
                    default:
                      BlocProvider.of<UnitsBloc>(context).add(FetchUnits(
                        unitGroupId: unitsFetched.unitGroup.id,
                        newMarkedUnitId: item.id,
                        markedUnitIds: unitsFetched.markedUnitIds,
                        forPage: unitsPageId,
                      ));
                      break;
                  }
                },
                markItemsOnTap: itemClickAction == ItemClickAction.mark,
              );
            })),
          ],
        ),
        floatingActionButton: Visibility(
          visible: itemClickAction != ItemClickAction.select,
          child: FloatingActionButton(
            onPressed: () {
              BlocProvider.of<UnitCreationBloc>(context).add(
                PrepareUnitCreation(
                  unitGroup: unitsFetched.unitGroup,
                  equivalentUnit: unitsFetched.selectedUnit,
                  markedUnitIds: unitsFetched.markedUnitIds,
                  initial: true,
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      );
    });
  }
}
