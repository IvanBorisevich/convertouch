import 'package:convertouch/model/constant.dart';
import 'package:convertouch/presenter/bloc/units_menu_bloc.dart';
import 'package:convertouch/presenter/events/units_menu_events.dart';
import 'package:convertouch/presenter/states/units_menu_states.dart';
import 'package:convertouch/view/items_view/menu_items_view.dart';
import 'package:convertouch/view/scaffold/bloc_wrappers.dart';
import 'package:convertouch/view/scaffold/scaffold.dart';
import 'package:convertouch/view/scaffold/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitGroupsMenuPage extends StatelessWidget {
  const ConvertouchUnitGroupsMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UnitsMenuBloc, UnitsMenuState>(
      listenWhen: (prev, next) {
        return prev != next && next.triggeredBy == unitGroupsPageId;
      },
      listener: (_, unitsFetched) {
        if (unitsFetched is UnitsFetched) {
          Navigator.of(context).pushNamed(unitsPageId);
        }
      },
      child: ConvertouchScaffold(
        pageTitle: "Unit Groups",
        body: Column(
          children: [
            const ConvertouchSearchBar(placeholder: "Search unit groups..."),
            Expanded(
              child: wrapIntoUnitGroupsMenuBloc((unitGroupsFetched) {
                return wrapIntoItemsMenuViewBloc((itemsMenuViewState) {
                  return ConvertouchMenuItemsView(unitGroupsFetched.unitGroups,
                      viewMode: itemsMenuViewState.pageViewMode,
                      onItemTap: (item) {
                        BlocProvider.of<UnitsMenuBloc>(context).add(FetchUnits(
                            unitGroupId: item.id, triggeredBy: unitGroupsPageId));
                      },
                  );
                });
              }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(unitGroupCreationPageId);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
