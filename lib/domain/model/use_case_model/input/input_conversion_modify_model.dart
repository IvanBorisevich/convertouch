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

abstract class ConversionParamValuesModifyDelta extends ConversionModifyDelta {
  const ConversionParamValuesModifyDelta();
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

class AddParamSetsDelta extends ConversionParamValuesModifyDelta {
  final List<int> paramSetIds;
  final bool initial;

  const AddParamSetsDelta({
    this.paramSetIds = const [],
    this.initial = false,
  });
}

class SelectParamSetDelta extends ConversionParamValuesModifyDelta {
  final int newSelectedParamSetIndex;

  const SelectParamSetDelta({
    required this.newSelectedParamSetIndex,
  });
}

class EditConversionParamValueDelta extends ConversionParamValuesModifyDelta {
  final String? newValue;
  final String? newDefaultValue;
  final int paramId;
  final int paramSetId;

  const EditConversionParamValueDelta({
    required this.newValue,
    required this.newDefaultValue,
    required this.paramId,
    required this.paramSetId,
  });
}

class ReplaceConversionParamUnitDelta extends ConversionParamValuesModifyDelta {
  final UnitModel newUnit;
  final int paramId;
  final int paramSetId;

  const ReplaceConversionParamUnitDelta({
    required this.newUnit,
    required this.paramId,
    required this.paramSetId,
  });
}

class RemoveParamSetsDelta extends ConversionParamValuesModifyDelta {
  final bool allOptional;

  const RemoveParamSetsDelta.current() : allOptional = false;

  const RemoveParamSetsDelta.all() : allOptional = true;
}
