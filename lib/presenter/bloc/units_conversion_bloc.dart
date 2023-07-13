import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/model/entity/unit_value_model.dart';
import 'package:convertouch/presenter/bloc/units_menu_bloc.dart';
import 'package:convertouch/presenter/events/units_conversion_events.dart';
import 'package:convertouch/presenter/states/units_conversion_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitsConversionBloc
    extends Bloc<UnitsConversionEvent, UnitsConversionState> {
  UnitsConversionBloc() : super(const UnitsConversionEmptyState());

  @override
  Stream<UnitsConversionState> mapEventToState(
      UnitsConversionEvent event) async* {
    if (event is ConvertUnitValue) {
      yield const UnitsConverting();
      int inputUnitId =
          event.inputUnitId != 0 ? event.inputUnitId : event.targetUnitIds[0];
      UnitModel? inputUnit = getUnit(inputUnitId);
      String inputValue = event.inputValue.isNotEmpty ? event.inputValue : "1";
      List<UnitValueModel> convertedUnitValues = [];
      if (inputUnit != null) {
        List<UnitModel> targetUnits = getUnits(event.targetUnitIds);
        convertedUnitValues = _convertItems(UnitValueModel(inputUnit, inputValue), targetUnits);
      }
      yield UnitsConverted(
        convertedUnitValues: convertedUnitValues,
        sourceUnitId: inputUnitId,
        sourceUnitValue: inputValue,
        unitGroup: event.unitGroup,
      );
    }
  }

  List<UnitValueModel> _convertItems(
      UnitValueModel inputUnitValue, List<UnitModel> targetUnits) {
    if (targetUnits.isEmpty) {
      return [];
    }
    List<UnitValueModel> convertedItems = [];
    for (var i = 0; i < targetUnits.length; i++) {
      convertedItems.add(UnitValueModel(targetUnits[i], '1'));
    }
    return convertedItems;
  }
}
