import 'package:convertouch/model/entity/unit_value_model.dart';
import 'package:convertouch/presenter/bloc/units_conversion_bloc.dart';
import 'package:convertouch/presenter/states/units_conversion_states.dart';
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
    return ConvertouchScaffold(
      body: BlocBuilder<UnitsConversionBloc, UnitsConversionState>(
        buildWhen: (prev, next) {
          return prev != next && next is ConversionInitialized;
        },
          builder: (_, unitsConverted) {
        if (unitsConverted is ConversionInitialized) {
          List<UnitValueModel> convertedItems =
              unitsConverted.convertedUnitValues;
          return ConvertouchConversionItemsView(convertedItems,
              sourceUnitId: unitsConverted.sourceUnitId,
              sourceValue: unitsConverted.sourceUnitValue,
              unitGroup: unitsConverted.unitGroup);
        } else {
          return const SizedBox();
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Navigator.of(context).pushNamed(unitsPageId);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
