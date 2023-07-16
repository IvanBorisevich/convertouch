import 'package:convertouch/model/constant.dart';
import 'package:convertouch/presenter/bloc/units_conversion_bloc.dart';
import 'package:convertouch/presenter/bloc/units_menu_bloc.dart';
import 'package:convertouch/presenter/events/units_menu_events.dart';
import 'package:convertouch/presenter/states/units_conversion_states.dart';
import 'package:convertouch/presenter/states/units_menu_states.dart';
import 'package:convertouch/view/items_view/conversion_items_view.dart';
import 'package:convertouch/view/scaffold/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsConversionPage extends StatefulWidget {
  const ConvertouchUnitsConversionPage({super.key});

  @override
  State<ConvertouchUnitsConversionPage> createState() =>
      _ConvertouchUnitsConversionPageState();
}

class _ConvertouchUnitsConversionPageState
    extends State<ConvertouchUnitsConversionPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<UnitsMenuBloc, UnitsMenuState>(
        listener: (_, unitsFetched) {
          if (unitsFetched is UnitsFetched &&
              unitsFetched.navigationAction == NavigationAction.push) {
            Navigator.of(context).pushNamed(unitsPageId);
          }
        },
        child: BlocBuilder<UnitsConversionBloc, UnitsConversionState>(
            buildWhen: (prev, next) {
          return prev != next && next is ConversionInitialized;
        }, builder: (_, conversionInitialized) {
          if (conversionInitialized is ConversionInitialized) {
            return ConvertouchScaffold(
              body: ConvertouchConversionItemsView(
                  conversionInitialized.convertedUnitValues,
                  sourceUnitId: conversionInitialized.sourceUnitId,
                  sourceValue: conversionInitialized.sourceUnitValue,
                  unitGroup: conversionInitialized.unitGroup),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  BlocProvider.of<UnitsMenuBloc>(context).add(FetchUnits(
                      unitGroupId: conversionInitialized.unitGroup.id,
                      navigationAction: NavigationAction.push));
                },
                child: const Icon(Icons.add),
              ),
            );
          } else {
            return const SizedBox();
          }
        }));
  }
}
