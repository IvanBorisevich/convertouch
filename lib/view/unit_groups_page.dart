import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/presenter/bloc/unit_creation_bloc.dart';
import 'package:convertouch/presenter/bloc/units_bloc.dart';
import 'package:convertouch/presenter/events/unit_creation_events.dart';
import 'package:convertouch/presenter/events/units_events.dart';
import 'package:convertouch/view/items_view/menu_items_view.dart';
import 'package:convertouch/view/scaffold/bloc_wrappers.dart';
import 'package:convertouch/view/scaffold/navigation.dart';
import 'package:convertouch/view/scaffold/scaffold.dart';
import 'package:convertouch/view/scaffold/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitGroupsPage extends StatefulWidget {
  const ConvertouchUnitGroupsPage({super.key});

  @override
  State createState() => _ConvertouchUnitGroupsPageState();
}

class _ConvertouchUnitGroupsPageState extends State<ConvertouchUnitGroupsPage> {
  @override
  Widget build(BuildContext context) {
    return unitGroupsBloc((unitGroupsFetched) {
      return ConvertouchScaffold(
        pageTitle: unitGroupsFetched.action ==
                    ConvertouchAction.fetchUnitGroupsToSelectForConversion ||
                unitGroupsFetched.action ==
                    ConvertouchAction.fetchUnitGroupsToSelectForUnitCreation
            ? "Select Unit Group"
            : "Unit Groups",
        body: Column(
          children: [
            const ConvertouchSearchBar(placeholder: "Search unit groups..."),
            Expanded(
              child: itemsViewModeBloc((itemsMenuViewState) {
                return ConvertouchMenuItemsView(
                  unitGroupsFetched.unitGroups,
                  selectedItemId: unitGroupsFetched.selectedUnitGroupId,
                  showSelectedItem: unitGroupsFetched.action ==
                          ConvertouchAction
                              .fetchUnitGroupsToSelectForUnitCreation ||
                      unitGroupsFetched.action ==
                          ConvertouchAction
                              .fetchUnitGroupsToSelectForConversion,
                  viewMode: itemsMenuViewState.pageViewMode,
                  onItemTap: (item) {
                    switch (unitGroupsFetched.action) {
                      case ConvertouchAction
                          .fetchUnitGroupsToSelectForUnitCreation:
                        BlocProvider.of<UnitCreationBloc>(context).add(
                          PrepareUnitCreation(
                            unitGroup: item as UnitGroupModel,
                            markedUnits: unitGroupsFetched.markedUnits,
                            action: ConvertouchAction
                                .updateUnitGroupForUnitCreation,
                          ),
                        );
                        break;
                      case ConvertouchAction.fetchUnitGroupsInitially:
                      case ConvertouchAction
                          .fetchUnitGroupsToSelectForUnitsFetching:
                      default:
                        BlocProvider.of<UnitsBloc>(context).add(
                          FetchUnits(
                            unitGroupId: item.id,
                            action: ConvertouchAction.fetchUnitsToStartMark,
                          ),
                        );
                        break;
                    }
                  },
                );
              }),
            ),
          ],
        ),
        floatingActionButton: Visibility(
          visible: unitGroupsFetched.action !=
                  ConvertouchAction.fetchUnitGroupsToSelectForConversion &&
              unitGroupsFetched.action !=
                  ConvertouchAction.fetchUnitGroupsToSelectForUnitCreation,
          child: FloatingActionButton(
            onPressed: () {
              NavigationService.I.navigateTo(unitGroupCreationPageId);
            },
            child: const Icon(Icons.add),
          ),
        ),
      );
    });
  }
}
