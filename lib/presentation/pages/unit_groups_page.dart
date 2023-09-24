import 'package:convertouch/domain/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/unit_creation/unit_creation_bloc.dart';
import 'package:convertouch/presentation/bloc/units/units_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_creation/unit_creation_events.dart';
import 'package:convertouch/presentation/bloc/units/units_events.dart';
import 'package:convertouch/presentation/pages/items_view/menu_items_view.dart';
import 'package:convertouch/presentation/pages/scaffold/bloc_wrappers.dart';
import 'package:convertouch/presentation/pages/scaffold/navigation_service.dart';
import 'package:convertouch/presentation/pages/scaffold/scaffold.dart';
import 'package:convertouch/presentation/pages/scaffold/search_bar.dart';
import 'package:convertouch/presentation/pages/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitGroupsPage extends StatefulWidget {
  const ConvertouchUnitGroupsPage({super.key});

  @override
  State createState() => _ConvertouchUnitGroupsPageState();
}

class _ConvertouchUnitGroupsPageState extends State<ConvertouchUnitGroupsPage> {
  late ConvertouchAction? action;

  @override
  Widget build(BuildContext context) {
    action = ModalRoute.of(context)!.settings.arguments as ConvertouchAction?;
    return unitGroupsBloc((unitGroupsFetched) {
      return ConvertouchScaffold(
        pageTitle:
            action == ConvertouchAction.fetchUnitGroupsToSelectForConversion ||
                    action ==
                        ConvertouchAction.fetchUnitGroupsToSelectForUnitCreation
                ? "Select Unit Group"
                : "Unit Groups",
        secondaryAppBar: ConvertouchSearchBar(
          placeholder: "Search unit groups...",
          colors: searchBarColors[ConvertouchUITheme.light]!,
        ),
        body: itemsViewModeBloc((itemsMenuViewState) {
          return ConvertouchMenuItemsView(
            unitGroupsFetched.unitGroups,
            selectedItemId: unitGroupsFetched.selectedUnitGroupId,
            showSelectedItem: action ==
                    ConvertouchAction.fetchUnitGroupsToSelectForUnitCreation ||
                action ==
                    ConvertouchAction.fetchUnitGroupsToSelectForConversion,
            viewMode: itemsMenuViewState.pageViewMode,
            onItemTap: (item) {
              switch (action) {
                case ConvertouchAction.fetchUnitGroupsToSelectForUnitCreation:
                  BlocProvider.of<UnitCreationBloc>(context).add(
                    PrepareUnitCreation(
                      unitGroup: item as UnitGroupModel,
                      markedUnits: unitGroupsFetched.markedUnits,
                      action: ConvertouchAction.updateUnitGroupForUnitCreation,
                    ),
                  );
                  break;
                case ConvertouchAction.fetchUnitGroupsInitially:
                case ConvertouchAction.fetchUnitGroupsToSelectForUnitsFetching:
                default:
                  BlocProvider.of<UnitsBloc>(context).add(
                    FetchUnits(
                      unitGroupId: item.id!,
                      action: ConvertouchAction.fetchUnitsToStartMark,
                    ),
                  );
                  break;
              }
            },
          );
        }),
        floatingActionButton: Visibility(
          visible: action !=
                  ConvertouchAction.fetchUnitGroupsToSelectForConversion &&
              action !=
                  ConvertouchAction.fetchUnitGroupsToSelectForUnitCreation,
          child: FloatingActionButton(
            onPressed: () {
              NavigationService.I.navigateTo(unitGroupCreationPageId);
            },
            backgroundColor:
                unitGroupsPageFloatingButtonColor[ConvertouchUITheme.light],
            elevation: 0,
            child: const Icon(Icons.add),
          ),
        ),
      );
    });
  }
}
