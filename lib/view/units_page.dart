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
  const ConvertouchUnitsPage(
      {this.unitsAddingEnabled = true,
      this.removalModeEnabled = false,
      super.key});

  final bool unitsAddingEnabled;
  final bool removalModeEnabled;

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
        pageTitle: unitsFetched.unitGroup.name,
        appBarRightWidgets: [
          checkIcon(
            context,
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
                markedItemIds: unitsFetched.markedUnitIds,
                viewMode: itemsViewModeState.pageViewMode,
                onItemTap: (item) {
                  switch (itemClickAction) {
                    case ItemClickAction.select:
                      BlocProvider.of<UnitCreationBloc>(context)
                          .add(PrepareUnitCreation(
                        unitGroup: unitsFetched.unitGroup,
                        unitForEquivalent: item as UnitModel,
                      ));
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
            visible: widget.unitsAddingEnabled,
            child: FloatingActionButton(
              onPressed: () {
                BlocProvider.of<UnitCreationBloc>(context)
                    .add(PrepareUnitCreation(
                  unitGroup: unitsFetched.unitGroup,
                  unitForEquivalent: unitsFetched.selectedUnit,
                  initial: true,
                ));
              },
              child: const Icon(Icons.add),
            )),
      );
    });
  }
}
