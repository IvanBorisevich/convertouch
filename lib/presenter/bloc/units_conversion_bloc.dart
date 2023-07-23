import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/model/entity/unit_value_model.dart';
import 'package:convertouch/presenter/events/units_conversion_events.dart';
import 'package:convertouch/presenter/states/units_conversion_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitsConversionBloc
    extends Bloc<UnitsConversionEvent, UnitsConversionState> {
  UnitsConversionBloc() : super(const UnitsConversionEmptyState());

  @override
  Stream<UnitsConversionState> mapEventToState(
      UnitsConversionEvent event) async* {
    if (event is InitializeConversion) {
      yield const ConversionInitializing();
      UnitModel inputUnit = event.inputUnit ?? event.conversionUnits[0];
      String inputValue = event.inputValue.isNotEmpty ? event.inputValue : "1";
      List<UnitValueModel> convertedUnitValues = _convertItems(inputUnit,
          inputValue, event.prevInputUnit, event.conversionUnits);

      yield ConversionInitialized(
        conversionItems: convertedUnitValues,
        sourceUnit: inputUnit,
        sourceUnitValue: inputValue,
        unitGroup: event.unitGroup,
      );
    } else if (event is ConvertUnitValue) {
      for (UnitValueModel conversionItem in event.conversionItems) {
        if (conversionItem.unit != event.inputUnit) {
          yield const UnitConverting();
          String convertedValue = _convertUnitValue(event.inputUnit,
              event.inputValue, conversionItem.unit);
          yield UnitConverted(
            unitValue: UnitValueModel(
              unit: conversionItem.unit,
              value: convertedValue,
            ),
          );
        }
      }
    }
  }

  List<UnitValueModel> _convertItems(UnitModel inputUnit, String inputValue,
      UnitModel? prevInputUnit, List<UnitModel> conversionUnits) {
    if (conversionUnits.isEmpty) {
      return [];
    }

    if (prevInputUnit != null) {
      int indexOfPrevInputUnit = conversionUnits.indexOf(prevInputUnit);
      conversionUnits[indexOfPrevInputUnit] = inputUnit;
    }

    return conversionUnits.map((unit) =>
        UnitValueModel(
          unit: unit,
          value: _convertUnitValue(inputUnit, inputValue, unit),
        )
    ).toList();
  }

  String _convertUnitValue(UnitModel inputUnit, String inputValue,
      UnitModel targetUnit) {
    return inputValue.isNotEmpty ? "1$inputValue" : "";
  }
}
