import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';

class InputConversionModifyModel<T extends ConversionModifyDelta> {
  final OutputConversionModel conversion;
  final T delta;
  final bool rebuildConversion;

  const InputConversionModifyModel({
    required this.conversion,
    required this.delta,
    this.rebuildConversion = false,
  });
}

abstract class ConversionModifyDelta {
  const ConversionModifyDelta();
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
