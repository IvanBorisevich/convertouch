import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/util/menu_page_util.dart';
import 'package:convertouch/presenter/bloc/units_conversion_bloc.dart';
import 'package:convertouch/presenter/bloc/units_menu_bloc.dart';
import 'package:convertouch/presenter/events/units_conversion_events.dart';
import 'package:convertouch/presenter/events/units_menu_events.dart';
import 'package:convertouch/presenter/states/units_conversion_states.dart';
import 'package:convertouch/view/items_view/menu_items_view.dart';
import 'package:convertouch/view/scaffold/bloc_wrappers.dart';
import 'package:convertouch/view/scaffold/scaffold.dart';
import 'package:convertouch/view/scaffold/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsMenuPage extends StatefulWidget {
  const ConvertouchUnitsMenuPage(
      {this.unitsAddingEnabled = true,
      this.removalModeEnabled = false,
      super.key});

  final bool unitsAddingEnabled;
  final bool removalModeEnabled;

  @override
  State createState() => _ConvertouchUnitsMenuPageState();
}

class _ConvertouchUnitsMenuPageState extends State<ConvertouchUnitsMenuPage> {
  static const int _minNumOfUnitsToSelect = 2;

  final List<int> _selectedUnitIds = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener<UnitsConversionBloc, UnitsConversionState>(
      listenWhen: (prev, next) {
        return prev != next && next.triggeredBy == unitsPageId;
      },
      listener: (_, convertedUnitsState) {
        if (convertedUnitsState is ConversionInitialized) {
          Navigator.of(context).pop();
        }
      },
      child: wrapIntoUnitsMenuBloc((unitsFetched) {
        return ConvertouchScaffold(
            pageTitle: unitsFetched.unitGroup.name,
            appBarRightWidgets: [
              wrapIntoUnitsConversionBloc((conversionInitialized) {
                return wrapIntoUnitsMenuBlocForItem((unitSelected) {
                  updateSelectedUnitIds(
                      _selectedUnitIds, unitSelected, conversionInitialized);
                  bool isButtonEnabled =
                      _selectedUnitIds.length >= _minNumOfUnitsToSelect;

                  return checkIcon(context, isButtonEnabled, () {
                    BlocProvider.of<UnitsConversionBloc>(context)
                        .add(InitializeConversion(
                      targetUnitIds: _selectedUnitIds,
                      unitGroup: unitsFetched.unitGroup,
                      triggeredBy: unitsPageId,
                    ));
                  });
                });
              }),
            ],
            body: Column(
              children: [
                const ConvertouchSearchBar(placeholder: "Search units..."),
                Expanded(
                  child: wrapIntoItemsMenuViewBloc((itemsMenuViewState) {
                    return ConvertouchMenuItemsView(
                      unitsFetched.units,
                      conversionUnitIds: _selectedUnitIds,
                      viewMode: itemsMenuViewState.pageViewMode,
                      onItemTap: (item) {
                        BlocProvider.of<UnitsMenuBloc>(context)
                            .add(SelectUnit(unitId: item.id));
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
                  Navigator.of(context).pushNamed(unitCreationPageId);
                },
                child: const Icon(Icons.add),
              ),
            ));
      }),
    );
  }
}
