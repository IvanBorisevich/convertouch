import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

class InputConversionModifyModel<T extends ConversionModifyDelta> {
  final ConversionModel conversion;
  final T delta;

  const InputConversionModifyModel({
    required this.conversion,
    required this.delta,
  });
}

abstract class ConversionModifyDelta {
  const ConversionModifyDelta();

  bool get recalculateUnitValues => true;
}

abstract class ConversionUnitValuesModifyDelta extends ConversionModifyDelta {
  const ConversionUnitValuesModifyDelta();
}

abstract class ConversionParamsModifyDelta extends ConversionModifyDelta {
  const ConversionParamsModifyDelta();
}

abstract class ConversionSingleParamModifyDelta
    extends ConversionParamsModifyDelta {
  final int paramId;
  final int paramSetId;

  const ConversionSingleParamModifyDelta({
    required this.paramId,
    required this.paramSetId,
  });
}

class AddUnitsToConversionDelta extends ConversionUnitValuesModifyDelta {
  final List<int> unitIds;

  const AddUnitsToConversionDelta({
    required this.unitIds,
  });
}

class EditConversionGroupDelta extends ConversionModifyDelta {
  final UnitGroupModel editedGroup;

  const EditConversionGroupDelta({
    required this.editedGroup,
  });

  @override
  bool get recalculateUnitValues => false;
}

class EditConversionItemUnitDelta extends ConversionUnitValuesModifyDelta {
  final UnitModel editedUnit;

  const EditConversionItemUnitDelta({
    required this.editedUnit,
  });
}

class EditConversionItemValueDelta extends ConversionUnitValuesModifyDelta {
  final String? newValue;
  final String? newDefaultValue;
  final int unitId;

  const EditConversionItemValueDelta({
    required this.newValue,
    required this.newDefaultValue,
    required this.unitId,
  });
}

class UpdateConversionCoefficientsDelta
    extends ConversionUnitValuesModifyDelta {
  final Map<String, double?> updatedUnitCoefs;

  const UpdateConversionCoefficientsDelta({
    required this.updatedUnitCoefs,
  });
}

class RemoveConversionItemsDelta extends ConversionUnitValuesModifyDelta {
  final List<int> unitIds;

  const RemoveConversionItemsDelta({
    required this.unitIds,
  });

  @override
  bool get recalculateUnitValues => false;
}

class ReplaceConversionItemUnitDelta extends ConversionUnitValuesModifyDelta {
  final UnitModel newUnit;
  final int oldUnitId;
  final RecalculationOnUnitChange recalculationMode;

  const ReplaceConversionItemUnitDelta({
    required this.newUnit,
    required this.oldUnitId,
    required this.recalculationMode,
  });

  @override
  bool get recalculateUnitValues =>
      recalculationMode == RecalculationOnUnitChange.otherValues;
}

class AddParamSetsDelta extends ConversionParamsModifyDelta {
  final List<int> paramSetIds;

  const AddParamSetsDelta({
    this.paramSetIds = const [],
  });
}

class SelectParamSetDelta extends ConversionParamsModifyDelta {
  final int newSelectedParamSetIndex;

  const SelectParamSetDelta({
    required this.newSelectedParamSetIndex,
  });
}

class EditConversionParamValueDelta extends ConversionSingleParamModifyDelta {
  final String? newValue;
  final String? newDefaultValue;

  const EditConversionParamValueDelta({
    required this.newValue,
    required this.newDefaultValue,
    required super.paramId,
    required super.paramSetId,
  });
}

class ReplaceConversionParamUnitDelta extends ConversionSingleParamModifyDelta {
  final UnitModel newUnit;

  const ReplaceConversionParamUnitDelta({
    required this.newUnit,
    required super.paramId,
    required super.paramSetId,
  });
}

class RemoveParamSetsDelta extends ConversionParamsModifyDelta {
  final bool allOptional;

  const RemoveParamSetsDelta.current() : allOptional = false;

  const RemoveParamSetsDelta.all() : allOptional = true;
}

class ToggleCalculableParamDelta extends ConversionSingleParamModifyDelta {
  const ToggleCalculableParamDelta({
    required super.paramId,
    required super.paramSetId,
  });
}

abstract class FetchMoreListValuesOfItemDelta extends ConversionModifyDelta {
  const FetchMoreListValuesOfItemDelta();
}

class FetchMoreListValuesOfParamDelta extends FetchMoreListValuesOfItemDelta {
  final int paramId;

  const FetchMoreListValuesOfParamDelta({
    required this.paramId,
  });

  @override
  bool get recalculateUnitValues => false;
}

class FetchMoreListValuesOfConversionItemDelta
    extends FetchMoreListValuesOfItemDelta {
  final int unitId;

  const FetchMoreListValuesOfConversionItemDelta({
    required this.unitId,
  });

  @override
  bool get recalculateUnitValues => false;
}
