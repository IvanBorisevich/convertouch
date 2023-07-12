import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/presenter/bloc/units_conversion_bloc.dart';
import 'package:convertouch/presenter/bloc/units_menu_bloc.dart';
import 'package:convertouch/presenter/events/units_conversion_events.dart';
import 'package:convertouch/presenter/states/units_conversion_states.dart';
import 'package:convertouch/presenter/states/units_menu_states.dart';
import 'package:convertouch/view/items_view/menu_items_view.dart';
import 'package:convertouch/view/scaffold/scaffold.dart';
import 'package:convertouch/view/scaffold/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsMenuPage extends StatelessWidget {
  const ConvertouchUnitsMenuPage({super.key});

  static const int _minNumOfUnitsToSelect = 2;

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
      }, builder: (_, unitsMenuState) {
        if (unitsMenuState is UnitsFetched) {
          List<UnitModel> units = unitsMenuState.units;
          UnitGroupModel unitGroup = unitsMenuState.unitGroup;
          return ConvertouchScaffold(
            pageTitle: unitGroup.name,
            appBarLeftWidget: backIcon(context),
            appBarRightWidgets: [
              BlocBuilder<UnitsConversionBloc, UnitsConversionState>(
                  buildWhen: (prev, next) {
                return prev != next && next is UnitsConverted;
              }, builder: (_, convertedUnitsState) {
                bool isButtonEnabled = convertedUnitsState is UnitsConverted &&
                    convertedUnitsState.convertedUnitValues.length >=
                        _minNumOfUnitsToSelect;
                return checkIcon(context, isButtonEnabled, () {
                  BlocProvider.of<UnitsConversionBloc>(context).add(
                      ConvertUnitValue(
                          targetUnitIds: const [1, 2, 4],
                          unitGroup: unitGroup));
                });
              }),
            ],
            body: Column(
              children: [
                const ConvertouchSearchBar(placeholder: "Search units..."),
                Expanded(
                  child: ConvertouchMenuItemsView(units),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(unitCreationPageId, arguments: unitGroup);
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
