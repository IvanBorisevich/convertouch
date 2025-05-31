import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

class InputConversionModifyModel<T extends ConversionModifyDelta> {
  final ConversionModel conversion;
  final T delta;
  final bool recalculateUnitValues;

  const InputConversionModifyModel({
    required this.conversion,
    required this.delta,
    this.recalculateUnitValues = true,
  });
}

abstract class ConversionModifyDelta {
  const ConversionModifyDelta();
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
}

class ReplaceConversionItemUnitDelta extends ConversionUnitValuesModifyDelta {
  final UnitModel newUnit;
  final int oldUnitId;

  const ReplaceConversionItemUnitDelta({
    required this.newUnit,
    required this.oldUnitId,
  });
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
