import 'package:convertouch/model/constant.dart';
import 'package:convertouch/presenter/bloc/units_conversion_bloc.dart';
import 'package:convertouch/presenter/bloc/units_bloc.dart';
import 'package:convertouch/presenter/events/units_conversion_events.dart';
import 'package:convertouch/presenter/events/units_events.dart';
import 'package:convertouch/presenter/states/units_conversion_states.dart';
import 'package:convertouch/view/items_view/conversion_items_view.dart';
import 'package:convertouch/view/items_view/item/item.dart';
import 'package:convertouch/view/scaffold/scaffold.dart';
import 'package:convertouch/view/style/colors.dart';
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
    return unitsConversionBloc((conversionInitialized) {
      if (conversionInitialized is ConversionInitialized) {
        return ConvertouchScaffold(
          secondaryAppBar: ConvertouchItem.createItem(
            conversionInitialized.unitGroup,
            itemColors: unitGroupItemColorsInAppBar[ConvertouchUITheme.light]!,
          ).buildForList(),
          body: ConvertouchConversionItemsView(
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
                  action: ConvertouchAction.fetchUnitsToSelectForConversion,
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
          ),
          floatingActionButton: FloatingActionButton(
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
          ),
        );
      } else {
        return empty();
      }
    });
  }
}
