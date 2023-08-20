import 'package:convertouch/domain/constants.dart';
import 'package:convertouch/presentation/bloc/unit_groups/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/units/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_conversion/units_conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/units_conversion/units_conversion_events.dart';
import 'package:convertouch/presentation/bloc/units/units_events.dart';
import 'package:convertouch/presentation/bloc/units_conversion/units_conversion_states.dart';
import 'package:convertouch/presentation/pages/items_view/conversion_items_view.dart';
import 'package:convertouch/presentation/pages/items_view/item/item.dart';
import 'package:convertouch/presentation/pages/scaffold/scaffold.dart';
import 'package:convertouch/presentation/pages/style/colors.dart';
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
            onTap: () {
              BlocProvider.of<UnitGroupsBloc>(context).add(
                FetchUnitGroups(
                  selectedUnitGroupId: conversionInitialized.unitGroup.id,
                  markedUnits: conversionInitialized.conversionItems
                      .map((item) => item.unit)
                      .toList(),
                  action:
                      ConvertouchAction.fetchUnitGroupsToSelectForConversion,
                ),
              );
            },
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
            backgroundColor:
                conversionPageFloatingButtonColor[ConvertouchUITheme.light],
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
