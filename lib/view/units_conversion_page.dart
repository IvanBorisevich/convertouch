import 'package:convertouch/model/constant.dart';
import 'package:convertouch/presenter/bloc/units_conversion_bloc.dart';
import 'package:convertouch/presenter/bloc/units_bloc.dart';
import 'package:convertouch/presenter/events/units_conversion_events.dart';
import 'package:convertouch/presenter/events/units_events.dart';
import 'package:convertouch/presenter/states/units_conversion_states.dart';
import 'package:convertouch/view/items_view/conversion_items_view.dart';
import 'package:convertouch/view/scaffold/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'scaffold/bloc_wrappers.dart';

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
      body: unitsConversionBloc((conversionInitialized) {
        if (conversionInitialized is ConversionInitialized) {
          return ConvertouchConversionItemsView(
            conversionInitialized.conversionItems,
            sourceUnitId: conversionInitialized.sourceUnit.id,
            sourceValue: conversionInitialized.sourceUnitValue,
            unitGroup: conversionInitialized.unitGroup,
            onItemTap: (item) {
              BlocProvider.of<UnitsBloc>(context).add(
                FetchUnits(
                  unitGroupId: conversionInitialized.unitGroup.id,
                  markedUnits: conversionInitialized.conversionItems
                      .map((item) => item.unit)
                      .toList(),
                  inputValue: item.value,
                  selectedUnit: item.unit,
                  action: ConvertouchAction.fetchUnitsToSelectForConversion
                ),
              );
            },
            onItemValueChanged: (item, value) {
              BlocProvider.of<UnitsConversionBloc>(context).add(
                ConvertUnitValue(
                  inputValue: value,
                  inputUnit: item.unit,
                  conversionItems: conversionInitialized.conversionItems,
                ),
              );
            },
          );
        } else {
          return const SizedBox(width: 0, height: 0);
        }
      }),
      floatingActionButton: unitsConversionBloc((conversionInitialized) {
        if (conversionInitialized is ConversionInitialized) {
          return FloatingActionButton(
            onPressed: () {
              BlocProvider.of<UnitsBloc>(context).add(
                FetchUnits(
                  unitGroupId: conversionInitialized.unitGroup.id,
                  markedUnits: conversionInitialized.conversionItems
                      .map((item) => item.unit)
                      .toList(),
                  inputValue: conversionInitialized.sourceUnitValue,
                  action: ConvertouchAction.fetchUnitsToStartMark,
                ),
              );
            },
            backgroundColor: const Color(0xFF6793BE),
            elevation: 0,
            child: const Icon(Icons.add),
          );
        } else {
          return const SizedBox(height: 0, width: 0);
        }
      }),
    );
  }
}
