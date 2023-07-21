import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/model/entity/unit_value_model.dart';
import 'package:convertouch/presenter/bloc/units_bloc.dart';
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
      int inputUnitId =
          event.inputUnitId != 0 ? event.inputUnitId : event.targetUnitIds[0];
      UnitModel? inputUnit = getUnit(inputUnitId);
      String inputValue = event.inputValue.isNotEmpty ? event.inputValue : "1";
      List<UnitValueModel> convertedUnitValues = [];
      if (inputUnit != null) {
        List<UnitModel> targetUnits = getUnits(event.targetUnitIds);
        convertedUnitValues = _convertItems(UnitValueModel(
            unit: inputUnit,
            value: inputValue
        ), targetUnits);
      }
      yield ConversionInitialized(
        convertedUnitValues: convertedUnitValues,
        sourceUnitId: inputUnitId,
        sourceUnitValue: inputValue,
        unitGroup: event.unitGroup
      );
    } else if (event is ConvertUnitValue) {
      for (UnitModel targetUnit in event.targetUnits) {
        if (targetUnit.id != event.inputUnitId) {
          yield const UnitConverting();
          String targetValue =
              event.inputValue.isNotEmpty ? "1${event.inputValue}" : "";
          yield UnitConverted(
              unitValue: UnitValueModel(unit: targetUnit, value: targetValue)
          );
        }
      }
    }
  }

  List<UnitValueModel> _convertItems(
      UnitValueModel inputUnitValue, List<UnitModel> targetUnits) {
    if (targetUnits.isEmpty) {
      return [];
    }
    List<UnitValueModel> convertedItems = [];
    for (var i = 0; i < targetUnits.length; i++) {
      convertedItems.add(UnitValueModel(unit: targetUnits[i], value: '1'));
    }
    return convertedItems;
  }
}
