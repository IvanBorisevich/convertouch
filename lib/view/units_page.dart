import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/model/util/menu_page_util.dart';
import 'package:convertouch/presenter/bloc/unit_creation_bloc.dart';
import 'package:convertouch/presenter/bloc/units_conversion_bloc.dart';
import 'package:convertouch/presenter/bloc/units_bloc.dart';
import 'package:convertouch/presenter/events/unit_creation_events.dart';
import 'package:convertouch/presenter/events/units_conversion_events.dart';
import 'package:convertouch/presenter/events/units_events.dart';
import 'package:convertouch/presenter/states/units_states.dart';
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
  static const int _minNumOfUnitsToSelect = 2;

  final List<int> _highlightedUnitIds = [];

  @override
  Widget build(BuildContext context) {
    final ActionTypeOnItemClick? actionOnItemSelect =
      ModalRoute.of(context)!.settings.arguments as ActionTypeOnItemClick?;

    return unitsBloc((unitsFetched) {
      return ConvertouchScaffold(
        pageTitle: unitsFetched.unitGroup.name,
        appBarRightWidgets: [
          unitsBlocForItem((unitSelected) {
            int? newSelectedUnitId =
                unitSelected is UnitSelected ? unitSelected.unitId : null;
            updateSelectedUnitIds(_highlightedUnitIds, newSelectedUnitId,
                unitsFetched.conversionUnitIds);
            bool isButtonEnabled =
                _highlightedUnitIds.length >= _minNumOfUnitsToSelect;

            return checkIcon(context, isButtonEnabled, () {
              BlocProvider.of<UnitsConversionBloc>(context).add(
                  InitializeConversion(
                      targetUnitIds: _highlightedUnitIds,
                      unitGroup: unitsFetched.unitGroup));
            });
          })
        ],
        body: Column(
          children: [
            const ConvertouchSearchBar(placeholder: "Search units..."),
            Expanded(
              child: itemsViewModeBloc((itemsViewModeState) {
                return ConvertouchMenuItemsView(
                  unitsFetched.units,
                  highlightedItemIds: _highlightedUnitIds,
                  viewMode: itemsViewModeState.pageViewMode,
                  onItemTap: (item) {
                    switch (actionOnItemSelect) {
                      case ActionTypeOnItemClick.select:
                        BlocProvider.of<UnitCreationBloc>(context).add(
                          PrepareUnitCreation(
                            unitGroup: unitsFetched.unitGroup,
                            unitForEquivalent: item as UnitModel,
                          )
                        );
                        break;
                      case ActionTypeOnItemClick.markForSelection:
                      default:
                        BlocProvider.of<UnitsBloc>(context)
                            .add(SelectUnit(unitId: item.id));
                        break;
                    }
                  },
                );
              }),
            ),
          ],
        ),
        floatingActionButton: Visibility(
            visible: widget.unitsAddingEnabled,
            child: FloatingActionButton(
              onPressed: () {
                BlocProvider.of<UnitCreationBloc>(context).add(
                    PrepareUnitCreation(
                      unitGroup: unitsFetched.unitGroup,
                      unitForEquivalent: unitsFetched.units.isNotEmpty
                          ? unitsFetched.units[0]
                          : null,
                      initial: true,
                    )
                );
              },
              child: const Icon(Icons.add),
            )),
      );
    });
  }
}
