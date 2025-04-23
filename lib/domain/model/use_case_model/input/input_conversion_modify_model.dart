import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

class InputConversionModifyModel<T extends ConversionModifyDelta> {
  final ConversionModel conversion;
  final T delta;
  final bool rebuildConversion;

  const InputConversionModifyModel({
    required this.conversion,
    required this.delta,
    this.rebuildConversion = true,
  });
}

abstract class ConversionModifyDelta {
  const ConversionModifyDelta();
}

class AddUnitsToConversionDelta extends ConversionModifyDelta {
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

class EditConversionItemUnitDelta extends ConversionModifyDelta {
  final UnitModel editedUnit;

  const EditConversionItemUnitDelta({
    required this.editedUnit,
  });
}

class EditConversionItemValueDelta extends ConversionModifyDelta {
  final String? newValue;
  final String? newDefaultValue;
  final int unitId;

  const EditConversionItemValueDelta({
    required this.newValue,
    required this.newDefaultValue,
    required this.unitId,
  });
}

class UpdateConversionCoefficientsDelta extends ConversionModifyDelta {
  final Map<String, double?> updatedUnitCoefs;

  const UpdateConversionCoefficientsDelta({
    required this.updatedUnitCoefs,
  });
}

class RemoveConversionItemsDelta extends ConversionModifyDelta {
  final List<int> unitIds;

  const RemoveConversionItemsDelta({
    required this.unitIds,
  });
}

class ReplaceConversionItemUnitDelta extends ConversionModifyDelta {
  final UnitModel newUnit;
  final int oldUnitId;

  const ReplaceConversionItemUnitDelta({
    required this.newUnit,
    required this.oldUnitId,
  });
}

class AddParamSetsDelta extends ConversionModifyDelta {
  final List<int> paramSetIds;
  final bool initial;

  const AddParamSetsDelta({
    this.paramSetIds = const [],
    this.initial = false,
  });
}

class SelectParamSetDelta extends ConversionModifyDelta {
  final int newSelectedParamSetIndex;

  const SelectParamSetDelta({
    required this.newSelectedParamSetIndex,
  });
}

class EditConversionParamValueDelta extends ConversionModifyDelta {
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

class ReplaceConversionParamUnitDelta extends ConversionModifyDelta {
  final UnitModel newUnit;
  final int paramId;
  final int paramSetId;

  const ReplaceConversionParamUnitDelta({
    required this.newUnit,
    required this.paramId,
    required this.paramSetId,
  });
}

class RemoveParamSetsDelta extends ConversionModifyDelta {
  final bool allOptional;

  const RemoveParamSetsDelta.current() : allOptional = false;

  const RemoveParamSetsDelta.all() : allOptional = true;
}
