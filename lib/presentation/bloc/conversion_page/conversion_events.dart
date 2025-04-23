import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class ConversionEvent extends ConvertouchEvent {
  const ConversionEvent({
    super.onComplete,
  });
}

abstract class ModifyConversion extends ConversionEvent {
  const ModifyConversion({
    super.onComplete,
  });
}

class GetConversion extends ConversionEvent {
  final UnitGroupModel unitGroup;
  final void Function(ConversionModel)? processPrevConversion;

  const GetConversion({
    required this.unitGroup,
    this.processPrevConversion,
    super.onComplete,
  });

  @override
  List<Object?> get props => [
        unitGroup,
      ];

  @override
  String toString() {
    return 'GetConversion{unitGroup: $unitGroup}';
  }
}

class SaveConversion extends ConversionEvent {
  final ConversionModel conversion;

  const SaveConversion({
    required this.conversion,
  });

  @override
  String toString() {
    return 'SaveConversion{conversion: $conversion}';
  }
}

class ClearConversion extends ConversionEvent {
  const ClearConversion();

  @override
  String toString() {
    return 'ClearConversion{}';
  }
}

class EditConversionGroup extends ModifyConversion {
  final UnitGroupModel editedGroup;

  const EditConversionGroup({
    required this.editedGroup,
    super.onComplete,
  });

  @override
  List<Object?> get props => [
        editedGroup,
      ];

  @override
  String toString() {
    return 'EditConversionGroup{editedGroup: $editedGroup}';
  }
}

class AddUnitsToConversion extends ModifyConversion {
  final List<int> unitIds;

  const AddUnitsToConversion({
    required this.unitIds,
  });

  @override
  List<Object?> get props => [
        unitIds,
      ];

  @override
  String toString() {
    return 'AddUnitsToConversion{unitIds: $unitIds}';
  }
}

class EditConversionItemUnit extends ModifyConversion {
  final UnitModel editedUnit;

  const EditConversionItemUnit({
    required this.editedUnit,
  });

  @override
  List<Object?> get props => [
        editedUnit,
      ];

  @override
  String toString() {
    return 'EditConversionItemUnit{editedUnit: $editedUnit}';
  }
}

class EditConversionItemValue extends ModifyConversion {
  final String? newValue;
  final String? newDefaultValue;
  final int unitId;

  const EditConversionItemValue({
    required this.newValue,
    this.newDefaultValue,
    required this.unitId,
  });

  @override
  List<Object?> get props => [
        newValue,
        newDefaultValue,
        unitId,
      ];

  @override
  String toString() {
    return 'EditConversionItemValue{'
        'newValue: $newValue, '
        'newDefaultValue: $newDefaultValue, '
        'unitId: $unitId}';
  }
}

class UpdateConversionCoefficients extends ModifyConversion {
  final Map<String, double?> updatedUnitCoefs;

  const UpdateConversionCoefficients({
    required this.updatedUnitCoefs,
  });

  @override
  List<Object?> get props => [
        updatedUnitCoefs.entries,
      ];

  @override
  String toString() {
    return 'UpdateConversionCoefficients{updatedUnits: $updatedUnitCoefs}';
  }
}

class RemoveConversionItems extends ModifyConversion {
  final List<int> unitIds;

  const RemoveConversionItems({
    required this.unitIds,
  });

  @override
  List<Object?> get props => [
        unitIds,
      ];

  @override
  String toString() {
    return 'RemoveConversionItems{'
        'unitIds: $unitIds}';
  }
}

class ReplaceConversionItemUnit extends ModifyConversion {
  final UnitModel newUnit;
  final int oldUnitId;

  const ReplaceConversionItemUnit({
    required this.newUnit,
    required this.oldUnitId,
  });

  @override
  List<Object?> get props => [
        newUnit,
        oldUnitId,
      ];

  @override
  String toString() {
    return 'ReplaceConversionItemUnit{'
        'newUnit: $newUnit, '
        'oldUnitId: $oldUnitId}';
  }
}

class AddParamSetsToConversion extends ModifyConversion {
  final List<int> paramSetIds;

  const AddParamSetsToConversion({
    required this.paramSetIds,
  });

  @override
  List<Object?> get props => [
        paramSetIds,
      ];

  @override
  String toString() {
    return 'AddParamSetsToConversion{paramSetIds: $paramSetIds}';
  }
}

class RemoveSelectedParamSetFromConversion extends ModifyConversion {
  const RemoveSelectedParamSetFromConversion();

  @override
  String toString() {
    return 'RemoveSelectedParamSetFromConversion{}';
  }
}

class RemoveAllParamSetsFromConversion extends ModifyConversion {
  const RemoveAllParamSetsFromConversion();

  @override
  String toString() {
    return 'RemoveAllParamSetsFromConversion{}';
  }
}

class SelectParamSetInConversion extends ModifyConversion {
  final int newSelectedParamSetIndex;

  const SelectParamSetInConversion({
    required this.newSelectedParamSetIndex,
  });

  @override
  List<Object?> get props => [
        newSelectedParamSetIndex,
      ];

  @override
  String toString() {
    return 'SelectParamSetInConversion{'
        'newSelectedParamSetIndex: $newSelectedParamSetIndex}';
  }
}

class EditConversionParamValue extends ModifyConversion {
  final String? newValue;
  final String? newDefaultValue;
  final int paramId;
  final int paramSetId;

  const EditConversionParamValue({
    required this.newValue,
    this.newDefaultValue,
    required this.paramId,
    required this.paramSetId,
  });

  @override
  List<Object?> get props => [
        newValue,
        newDefaultValue,
        paramId,
        paramSetId,
      ];

  @override
  String toString() {
    return 'EditConversionParamValue{'
        'newValue: $newValue, '
        'newDefaultValue: $newDefaultValue, '
        'paramId: $paramId, '
        'paramSetId: $paramSetId}';
  }
}
