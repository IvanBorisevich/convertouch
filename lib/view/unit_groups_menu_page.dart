import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/presenter/bloc/items_menu_view_bloc.dart';
import 'package:convertouch/presenter/bloc/units_conversion_bloc.dart';
import 'package:convertouch/presenter/bloc/unit_groups_menu_bloc.dart';
import 'package:convertouch/presenter/bloc/units_menu_bloc.dart';
import 'package:convertouch/presenter/states/items_menu_view_state.dart';
import 'package:convertouch/presenter/states/units_conversion_states.dart';
import 'package:convertouch/presenter/states/unit_groups_menu_states.dart';
import 'package:convertouch/presenter/states/units_menu_states.dart';
import 'package:convertouch/view/items_view/menu_items_view.dart';
import 'package:convertouch/view/scaffold/scaffold.dart';
import 'package:convertouch/view/scaffold/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitGroupsMenuPage extends StatelessWidget {
  const ConvertouchUnitGroupsMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UnitsMenuBloc, UnitsMenuState>(
      listener: (_, unitsMenuState) {
        if (unitsMenuState is UnitsFetched &&
            unitsMenuState.navigationAction == NavigationAction.push) {
          Navigator.of(context).pushNamed(unitsPageId);
        }
      },
      child: ConvertouchScaffold(
        pageTitle: "Unit Groups",
        appBarLeftWidget: _appBarLeftIcon(context),
        body: _body(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(unitGroupCreationPageId);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _appBarLeftIcon(BuildContext context) {
    return BlocBuilder<UnitsConversionBloc, UnitsConversionState>(
        buildWhen: (prev, next) {
      return prev != next && next is ConversionInitialized;
    }, builder: (_, convertedUnitsState) {
      bool isBackButtonActive = convertedUnitsState is ConversionInitialized &&
          convertedUnitsState.convertedUnitValues.isNotEmpty;
      return isBackButtonActive ? backIcon(context) : menuIcon(context);
    });
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        const ConvertouchSearchBar(placeholder: "Search unit groups..."),
        Expanded(
            child: BlocBuilder<UnitGroupsMenuBloc, UnitGroupsMenuState>(
                buildWhen: (prev, next) {
          return prev != next && next is UnitGroupsFetched;
        }, builder: (_, unitGroupsMenuState) {
          List<UnitGroupModel> unitGroups =
              unitGroupsMenuState is UnitGroupsFetched
                  ? unitGroupsMenuState.unitGroups
                  : [];
          return BlocBuilder<ItemsMenuViewBloc, ItemsMenuViewState>(
              builder: (_, itemsMenuViewState) {
            return ConvertouchMenuItemsView(
                unitGroups,
                viewMode: itemsMenuViewState.pageViewMode
            );
          });
        })),
      ],
    );
  }
}
