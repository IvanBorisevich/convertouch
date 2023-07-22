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

class ConvertouchUnitGroupsPage extends StatelessWidget {
  const ConvertouchUnitGroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ItemClickAction? itemClickAction =
      ModalRoute.of(context)!.settings.arguments as ItemClickAction?;

    return ConvertouchScaffold(
      pageTitle: "Unit Groups",
      body: Column(
        children: [
          const ConvertouchSearchBar(placeholder: "Search unit groups..."),
          Expanded(
            child: unitGroupsBloc((unitGroupsFetched) {
              return itemsViewModeBloc((itemsMenuViewState) {
                return ConvertouchMenuItemsView(
                  unitGroupsFetched.unitGroups,
                  markedItemIds: unitGroupsFetched.markedUnitGroupIds,
                  viewMode: itemsMenuViewState.pageViewMode,
                  onItemTap: (item) {
                    switch (itemClickAction) {
                      case ItemClickAction.select:
                        BlocProvider.of<UnitCreationBloc>(context).add(
                          PrepareUnitCreation(unitGroup: item as UnitGroupModel)
                        );
                        break;
                      case ItemClickAction.fetch:
                      default:
                        BlocProvider.of<UnitsBloc>(context).add(
                            FetchUnits(unitGroupId: item.id));
                        break;
                    }
                  },
                );
              });
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NavigationService.I.navigateTo(unitGroupCreationPageId);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
