import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

class InputConversionModifyModel<T extends ConversionModifyDelta> {
  final ConversionModel conversion;
  final T delta;

  const InputConversionModifyModel({
    required this.conversion,
    required this.delta,
  });
}

abstract class ConversionModifyDelta {
  final bool recalculateUnitValues;

  const ConversionModifyDelta({
    required this.recalculateUnitValues,
  });
}

abstract class ConversionUnitValuesModifyDelta extends ConversionModifyDelta {
  const ConversionUnitValuesModifyDelta({
    required super.recalculateUnitValues,
  });
}

abstract class ConversionParamsModifyDelta extends ConversionModifyDelta {
  const ConversionParamsModifyDelta({
    required super.recalculateUnitValues,
  });
}

abstract class ConversionSingleUnitModifyDelta
    extends ConversionUnitValuesModifyDelta {
  final int unitId;

  const ConversionSingleUnitModifyDelta({
    required this.unitId,
    required super.recalculateUnitValues,
  });
}

abstract class ConversionSingleParamModifyDelta
    extends ConversionParamsModifyDelta {
  final int paramId;
  final int paramSetId;

  const ConversionSingleParamModifyDelta({
    required this.paramId,
    required this.paramSetId,
    required super.recalculateUnitValues,
  });
}

class AddUnitsToConversionDelta extends ConversionUnitValuesModifyDelta {
  final List<int> unitIds;

  const AddUnitsToConversionDelta({
    required this.unitIds,
    super.recalculateUnitValues = true,
  });
}

class EditConversionGroupDelta extends ConversionModifyDelta {
  final UnitGroupModel editedGroup;

  const EditConversionGroupDelta({
    required this.editedGroup,
    super.recalculateUnitValues = false,
  });
}

class EditConversionUnitDelta extends ConversionUnitValuesModifyDelta {
  final UnitModel editedUnit;

  const EditConversionUnitDelta({
    required this.editedUnit,
    super.recalculateUnitValues = true,
  });
}

class EditConversionUnitValueDelta extends ConversionSingleUnitModifyDelta {
  final ValueModel? newValue;
  final ValueModel? newDefaultValue;

  const EditConversionUnitValueDelta({
    required this.newValue,
    required this.newDefaultValue,
    required super.unitId,
    super.recalculateUnitValues = true,
  });

  factory EditConversionUnitValueDelta.raw({
    dynamic newValue,
    dynamic newDefaultValue,
    required int unitId,
    bool recalculateUnitValues = true,
  }) {
    return EditConversionUnitValueDelta(
      newValue: ValueModel.any(newValue),
      newDefaultValue: ValueModel.any(newDefaultValue),
      unitId: unitId,
      recalculateUnitValues: recalculateUnitValues,
    );
  }
}

class ReplaceConversionItemUnitDelta extends ConversionSingleUnitModifyDelta {
  final UnitModel newUnit;
  final RecalculationOnUnitChange recalculationMode;

  const ReplaceConversionItemUnitDelta({
    required this.newUnit,
    required super.unitId,
    required this.recalculationMode,
    required super.recalculateUnitValues,
  });
}

class UpdateConversionCoefficientsDelta
    extends ConversionUnitValuesModifyDelta {
  final DynamicCoefficientsModel newCoefficients;

  const UpdateConversionCoefficientsDelta({
    required this.newCoefficients,
    super.recalculateUnitValues = true,
  });
}

class RemoveConversionItemsDelta extends ConversionUnitValuesModifyDelta {
  final List<int> unitIds;

  const RemoveConversionItemsDelta({
    required this.unitIds,
    super.recalculateUnitValues = false,
  });
}

class AddParamSetsDelta extends ConversionParamsModifyDelta {
  final List<int> paramSetIds;

  const AddParamSetsDelta({
    this.paramSetIds = const [],
    super.recalculateUnitValues = false,
  });
}

class SelectParamSetDelta extends ConversionParamsModifyDelta {
  final int newSelectedParamSetIndex;

  const SelectParamSetDelta({
    required this.newSelectedParamSetIndex,
    super.recalculateUnitValues = true,
  });
}

class EditConversionParamValueDelta extends ConversionSingleParamModifyDelta {
  final ValueModel? newValue;
  final ValueModel? newDefaultValue;

  const EditConversionParamValueDelta({
    required this.newValue,
    required this.newDefaultValue,
    required super.paramId,
    required super.paramSetId,
    super.recalculateUnitValues = true,
  });

  factory EditConversionParamValueDelta.raw({
    dynamic newValue,
    dynamic newDefaultValue,
    required int paramId,
    required int paramSetId,
    bool recalculateUnitValues = true,
  }) {
    return EditConversionParamValueDelta(
      newValue: ValueModel.any(newValue),
      newDefaultValue: ValueModel.any(newDefaultValue),
      paramId: paramId,
      paramSetId: paramSetId,
      recalculateUnitValues: recalculateUnitValues,
    );
  }
}

class ReplaceConversionParamUnitDelta extends ConversionSingleParamModifyDelta {
  final UnitModel newUnit;

  const ReplaceConversionParamUnitDelta({
    required this.newUnit,
    required super.paramId,
    required super.paramSetId,
    super.recalculateUnitValues = true,
  });
}

class RemoveParamSetsDelta extends ConversionParamsModifyDelta {
  final bool allOptional;

  const RemoveParamSetsDelta._({
    required this.allOptional,
    super.recalculateUnitValues = true,
  });

  const RemoveParamSetsDelta.current({bool recalculateUnitValues = true})
      : this._(
          allOptional: false,
          recalculateUnitValues: recalculateUnitValues,
        );

  const RemoveParamSetsDelta.all({bool recalculateUnitValues = true})
      : this._(
          allOptional: true,
          recalculateUnitValues: recalculateUnitValues,
        );
}

class ToggleCalculableParamDelta extends ConversionSingleParamModifyDelta {
  const ToggleCalculableParamDelta({
    required super.paramId,
    required super.paramSetId,
    super.recalculateUnitValues = false,
  });
}
