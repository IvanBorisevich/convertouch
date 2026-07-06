import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

typedef ParamSetValueChangedCallback = void Function(ConversionModel);

class InputConversionModifyModel<T extends ConversionModifyDelta> {
  final ConversionModel conversion;
  final T delta;
  final ParamSetValueChangedCallback? ifParamSetFilled;
  final ParamSetValueChangedCallback? ifParamSetFilledPartiallyOrEmpty;

  const InputConversionModifyModel({
    required this.conversion,
    required this.delta,
    this.ifParamSetFilled,
    this.ifParamSetFilledPartiallyOrEmpty,
  });
}

abstract interface class ConversionModifyDelta {
  const ConversionModifyDelta();

  bool get recalculateUnitValues;
}

abstract class EditItemValueDelta implements ConversionModifyDelta {
  final ValueModel? newValue;
  final ValueModel? newDefaultValue;

  const EditItemValueDelta({
    required this.newValue,
    required this.newDefaultValue,
  });
}

abstract class ReplaceItemUnitDelta implements ConversionModifyDelta {
  final UnitModel newUnit;
  final RecalculationOnUnitChange recalculationMode;

  const ReplaceItemUnitDelta({
    required this.newUnit,
    this.recalculationMode = RecalculationOnUnitChange.currentValue,
  });
}

abstract interface class ConversionUnitValuesModifyDelta
    implements ConversionModifyDelta {
  const ConversionUnitValuesModifyDelta();
}

abstract interface class ConversionParamsModifyDelta
    implements ConversionModifyDelta {
  const ConversionParamsModifyDelta();
}

class AddUnitsToConversionDelta implements ConversionUnitValuesModifyDelta {
  final List<int> unitIds;

  const AddUnitsToConversionDelta({
    required this.unitIds,
  });

  @override
  bool get recalculateUnitValues => true;
}

class EditConversionGroupDelta implements ConversionModifyDelta {
  final UnitGroupModel editedGroup;

  const EditConversionGroupDelta({
    required this.editedGroup,
  });

  @override
  bool get recalculateUnitValues => false;
}

class EditConversionUnitDelta implements ConversionUnitValuesModifyDelta {
  final UnitModel editedUnit;

  const EditConversionUnitDelta({
    required this.editedUnit,
  });

  @override
  bool get recalculateUnitValues => false;
}

class EditConversionUnitValueDelta extends EditItemValueDelta
    implements ConversionUnitValuesModifyDelta {
  final int unitId;

  const EditConversionUnitValueDelta({
    required super.newValue,
    required super.newDefaultValue,
    required this.unitId,
  });

  factory EditConversionUnitValueDelta.raw({
    dynamic newValue,
    dynamic newDefaultValue,
    required int unitId,
  }) {
    return EditConversionUnitValueDelta(
      newValue: ValueModel.any(newValue),
      newDefaultValue: ValueModel.any(newDefaultValue),
      unitId: unitId,
    );
  }

  @override
  bool get recalculateUnitValues => true;
}

class ReplaceConversionItemUnitDelta extends ReplaceItemUnitDelta
    implements ConversionUnitValuesModifyDelta {
  final int unitId;

  const ReplaceConversionItemUnitDelta({
    required super.newUnit,
    required super.recalculationMode,
    required this.unitId,
  });

  @override
  bool get recalculateUnitValues =>
      recalculationMode == RecalculationOnUnitChange.otherValues;
}

class UpdateConversionCoefficientsDelta
    implements ConversionUnitValuesModifyDelta {
  final DynamicCoefficientsModel newCoefficients;

  const UpdateConversionCoefficientsDelta({
    required this.newCoefficients,
  });

  @override
  bool get recalculateUnitValues => true;
}

class RemoveConversionItemsDelta implements ConversionUnitValuesModifyDelta {
  final List<int> unitIds;

  const RemoveConversionItemsDelta({
    required this.unitIds,
  });

  @override
  bool get recalculateUnitValues => false;
}

class AddParamSetsDelta implements ConversionParamsModifyDelta {
  final List<int> paramSetIds;
  final bool fetchListValues;

  const AddParamSetsDelta({
    this.paramSetIds = const [],
    this.fetchListValues = true,
  });

  @override
  bool get recalculateUnitValues => false;
}

class SelectParamSetDelta implements ConversionParamsModifyDelta {
  final int newSelectedParamSetIndex;

  const SelectParamSetDelta({
    required this.newSelectedParamSetIndex,
  });

  @override
  bool get recalculateUnitValues => true;
}

class EditConversionParamValueDelta extends EditItemValueDelta
    implements ConversionParamsModifyDelta {
  final int paramId;
  final int paramSetId;

  const EditConversionParamValueDelta({
    required super.newValue,
    required super.newDefaultValue,
    required this.paramId,
    required this.paramSetId,
  });

  factory EditConversionParamValueDelta.raw({
    dynamic newValue,
    dynamic newDefaultValue,
    required int paramId,
    required int paramSetId,
  }) {
    return EditConversionParamValueDelta(
      newValue: ValueModel.any(newValue),
      newDefaultValue: ValueModel.any(newDefaultValue),
      paramId: paramId,
      paramSetId: paramSetId,
    );
  }

  @override
  bool get recalculateUnitValues => true;
}

class ReplaceConversionParamUnitDelta extends ReplaceItemUnitDelta
    implements ConversionParamsModifyDelta {
  final int paramId;
  final int paramSetId;

  const ReplaceConversionParamUnitDelta({
    required super.newUnit,
    required this.paramId,
    required this.paramSetId,
  });

  @override
  bool get recalculateUnitValues => false;
}

class RemoveParamSetsDelta implements ConversionParamsModifyDelta {
  final bool allOptional;

  const RemoveParamSetsDelta._({
    required this.allOptional,
  });

  const RemoveParamSetsDelta.current()
      : this._(
          allOptional: false,
        );

  const RemoveParamSetsDelta.all()
      : this._(
          allOptional: true,
        );

  @override
  bool get recalculateUnitValues => true;
}

class ToggleCalculableParamDelta extends ConversionParamsModifyDelta {
  final int paramId;
  final int paramSetId;

  const ToggleCalculableParamDelta({
    required this.paramId,
    required this.paramSetId,
  });

  @override
  bool get recalculateUnitValues => false;
}

class RefreshParamListValuesDelta extends ConversionParamsModifyDelta {
  final int paramId;

  const RefreshParamListValuesDelta({
    required this.paramId,
  });

  @override
  bool get recalculateUnitValues => false;
}
