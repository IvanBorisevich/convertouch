import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/util/menu_page_util.dart';
import 'package:convertouch/presenter/bloc/items_menu_view_bloc.dart';
import 'package:convertouch/presenter/bloc/units_conversion_bloc.dart';
import 'package:convertouch/presenter/bloc/units_menu_bloc.dart';
import 'package:convertouch/presenter/events/units_conversion_events.dart';
import 'package:convertouch/presenter/states/items_menu_view_state.dart';
import 'package:convertouch/presenter/states/units_conversion_states.dart';
import 'package:convertouch/presenter/states/units_menu_states.dart';
import 'package:convertouch/view/items_view/menu_items_view.dart';
import 'package:convertouch/view/scaffold/scaffold.dart';
import 'package:convertouch/view/scaffold/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsMenuPage extends StatefulWidget {
  const ConvertouchUnitsMenuPage({super.key});

  @override
  State createState() => _ConvertouchUnitsMenuPageState();
}

class _ConvertouchUnitsMenuPageState extends State<ConvertouchUnitsMenuPage> {
  static const int _minNumOfUnitsToSelect = 2;

  final List<int> _selectedUnitIds = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener<UnitsConversionBloc, UnitsConversionState>(
      listener: (_, convertedUnitsState) {
        if (convertedUnitsState is UnitsConverted) {
          Navigator.of(context).pop();
        }
      },
      child:
          BlocBuilder<UnitsMenuBloc, UnitsMenuState>(buildWhen: (prev, next) {
        return prev != next && next is UnitsFetched;
      }, builder: (_, unitsFetched) {
        if (unitsFetched is UnitsFetched) {
          return ConvertouchScaffold(
            pageTitle: unitsFetched.unitGroup.name,
            appBarLeftWidget: backIcon(context),
            appBarRightWidgets: [
              BlocBuilder<UnitsConversionBloc, UnitsConversionState>(
                  buildWhen: (prev, next) {
                return prev != next && next is UnitsConverted;
              }, builder: (_, unitsConverted) {
                return BlocBuilder<UnitsMenuBloc, UnitsMenuState>(
                    buildWhen: (prev, next) {
                  return prev != next && next is UnitSelected;
                }, builder: (_, unitSelected) {
                  updateSelectedUnitIds(
                      _selectedUnitIds, unitSelected, unitsConverted);
                  bool isButtonEnabled =
                      _selectedUnitIds.length >= _minNumOfUnitsToSelect;

                  return checkIcon(context, isButtonEnabled, () {
                    BlocProvider.of<UnitsConversionBloc>(context).add(
                        ConvertUnitValue(
                            targetUnitIds: _selectedUnitIds,
                            unitGroup: unitsFetched.unitGroup));
                  });
                });
              }),
            ],
            body: Column(
              children: [
                const ConvertouchSearchBar(placeholder: "Search units..."),
                Expanded(
                  child: BlocBuilder<ItemsMenuViewBloc, ItemsMenuViewState>(
                    builder: (_, itemsMenuViewState) {
                      return ConvertouchMenuItemsView(
                        unitsFetched.units,
                        selectedItemIds: _selectedUnitIds,
                        viewMode: itemsMenuViewState.viewMode
                      );
                    }),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(unitCreationPageId,
                    arguments: unitsFetched.unitGroup);
              },
              child: const Icon(Icons.add),
            ),
          );
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}
