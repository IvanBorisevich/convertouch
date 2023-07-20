import 'package:convertouch/model/constant.dart';
import 'package:convertouch/presenter/bloc/units_conversion_bloc.dart';
import 'package:convertouch/presenter/bloc/units_menu_bloc.dart';
import 'package:convertouch/presenter/events/units_conversion_events.dart';
import 'package:convertouch/presenter/events/units_menu_events.dart';
import 'package:convertouch/presenter/states/units_conversion_states.dart';
import 'package:convertouch/view/items_view/conversion_items_view.dart';
import 'package:convertouch/view/scaffold/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'scaffold/bloc.dart';

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
    return ConvertouchScaffold(
      body: wrapIntoUnitsConversionBloc((conversionInitialized) {
        if (conversionInitialized is ConversionInitialized) {
          return ConvertouchConversionItemsView(
            conversionInitialized.convertedUnitValues,
            sourceUnitId: conversionInitialized.sourceUnitId,
            sourceValue: conversionInitialized.sourceUnitValue,
            unitGroup: conversionInitialized.unitGroup,
            onItemTap: (item) {
              BlocProvider.of<UnitsMenuBloc>(context).add(FetchUnits(
                  unitGroupId: conversionInitialized.unitGroup.id,
                  triggeredBy: unitsConversionPageId));
            },
            onItemValueChanged: (item, value) {
              BlocProvider.of<UnitsConversionBloc>(context).add(
                  ConvertUnitValue(
                      inputValue: value,
                      inputUnitId: item.unit.id,
                      targetUnits: conversionInitialized.convertedUnitValues
                          .map((unitValue) => unitValue.unit)
                          .toList()));
            },
          );
        } else {
          return const SizedBox(width: 0, height: 0);
        }
      }),
      floatingActionButton:
          wrapIntoUnitsConversionBloc((conversionInitialized) {
        if (conversionInitialized is ConversionInitialized) {
          return FloatingActionButton(
            onPressed: () {
              BlocProvider.of<UnitsMenuBloc>(context).add(FetchUnits(
                  unitGroupId: conversionInitialized.unitGroup.id,
                  triggeredBy: unitsConversionPageId));
            },
            child: const Icon(Icons.add),
          );
        } else {
          return const SizedBox(height: 0, width: 0);
        }
      }),
    );
  }
}
