import 'package:convertouch/domain/entities/unit_entity.dart';
import 'package:convertouch/domain/entities/unit_value_entity.dart';
import 'package:convertouch/presentation/bloc/units_conversion/units_conversion_events.dart';
import 'package:convertouch/presentation/bloc/units_conversion/units_conversion_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitsConversionBloc
    extends Bloc<UnitsConversionEvent, UnitsConversionState> {
  UnitsConversionBloc() : super(const UnitsConversionEmptyState());

  @override
  Stream<UnitsConversionState> mapEventToState(
      UnitsConversionEvent event) async* {
    if (event is InitializeConversion) {
      yield const ConversionInitializing();
      UnitEntity inputUnit = event.inputUnit ?? event.conversionUnits[0];
      String inputValue = event.inputValue.isNotEmpty ? event.inputValue : "1";
      List<UnitValueEntity> convertedUnitValues = _convertItems(inputUnit,
          inputValue, event.prevInputUnit, event.conversionUnits);

      yield ConversionInitialized(
        conversionItems: convertedUnitValues,
        sourceUnit: inputUnit,
        sourceUnitValue: inputValue,
        unitGroup: event.unitGroup,
      );
    } else if (event is ConvertUnitValue) {
      for (UnitValueEntity conversionItem in event.conversionItems) {
        if (conversionItem.unit != event.inputUnit) {
          yield const UnitConverting();
          String convertedValue = _convertUnitValue(event.inputUnit,
              event.inputValue, conversionItem.unit);
          yield UnitConverted(
            unitValue: UnitValueEntity(
              unit: conversionItem.unit,
              value: convertedValue,
            ),
          );
        }
      }
    }
  }

  List<UnitValueEntity> _convertItems(UnitEntity inputUnit, String inputValue,
      UnitEntity? prevInputUnit, List<UnitEntity> conversionUnits) {
    if (conversionUnits.isEmpty) {
      return [];
    }

    if (prevInputUnit != null) {
      int indexOfPrevInputUnit = conversionUnits.indexOf(prevInputUnit);
      conversionUnits[indexOfPrevInputUnit] = inputUnit;
    }

    return conversionUnits.map((unit) =>
        UnitValueEntity(
          unit: unit,
          value: _convertUnitValue(inputUnit, inputValue, unit),
        )
    ).toList();
  }

  String _convertUnitValue(UnitEntity inputUnit, String inputValue,
      UnitEntity targetUnit) {
    return inputValue.isNotEmpty ? "1$inputValue" : "";
  }
}
