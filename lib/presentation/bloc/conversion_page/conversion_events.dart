import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class ConversionEvent extends ConvertouchEvent {
  final void Function(
    ConversionModel, {
    ConvertouchException? info,
  })? doAfter;

  const ConversionEvent({
    this.doAfter,
    super.onError,
  });
}

abstract class ConversionParamsEvent extends ConversionEvent {
  const ConversionParamsEvent({
    super.onError,
    super.doAfter,
  });
}

class GetOrBuildConversion extends ConversionEvent {
  final UnitGroupModel unitGroup;
  final void Function(ConversionModel)? processPrevConversion;
  final void Function(ConversionModel)? processCurrentConversion;

  const GetOrBuildConversion({
    required this.unitGroup,
    this.processPrevConversion,
    this.processCurrentConversion,
  });

  @override
  List<Object?> get props => [
        unitGroup,
      ];

  @override
  String toString() {
    return 'GetOrBuildConversion{unitGroup: $unitGroup}';
  }
}

class SaveConversion extends ConversionEvent {
  final ConversionModel conversion;

  const SaveConversion({
    required this.conversion,
    super.onError,
  });

  @override
  String toString() {
    return 'SaveConversion{conversion: $conversion}';
  }
}

class CleanupConversion extends ConversionEvent {
  final bool keepParams;

  const CleanupConversion({
    required this.keepParams,
    super.onError,
    super.doAfter,
  });

  @override
  String toString() {
    return 'CleanupConversion{'
        'keepParams: $keepParams}';
  }
}

class MoveConversionUnitValue extends ConversionEvent {
  final int oldIndex;
  final int newIndex;

  const MoveConversionUnitValue({
    required this.oldIndex,
    required this.newIndex,
    super.doAfter,
  });

  @override
  List<Object?> get props => [
        oldIndex,
        newIndex,
      ];

  @override
  String toString() {
    return 'MoveConversionUnitValue{'
        'oldIndex: $oldIndex, '
        'newIndex: $newIndex}';
  }
}

class EditConversionGroup extends ConversionEvent {
  final UnitGroupModel editedGroup;

  const EditConversionGroup({
    required this.editedGroup,
    super.onError,
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

class AddUnitsToConversion extends ConversionEvent {
  final List<int> unitIds;

  const AddUnitsToConversion({
    required this.unitIds,
    super.onError,
    super.doAfter,
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

class EditConversionUnit extends ConversionEvent {
  final UnitModel editedUnit;

  const EditConversionUnit({
    required this.editedUnit,
    super.onError,
    super.doAfter,
  });

  @override
  List<Object?> get props => [
        editedUnit,
      ];

  @override
  String toString() {
    return 'EditConversionUnit{editedUnit: $editedUnit}';
  }
}

class EditConversionUnitValue extends ConversionEvent {
  final ValueModel? newValue;
  final ValueModel? newDefaultValue;
  final ListValuesFetchResult? listValues;
  final int unitId;

  const EditConversionUnitValue({
    required this.newValue,
    this.newDefaultValue,
    this.listValues,
    required this.unitId,
    super.onError,
    super.doAfter,
  });

  @override
  List<Object?> get props => [
        newValue,
        newDefaultValue,
        listValues,
        unitId,
      ];

  @override
  String toString() {
    return 'EditConversionUnitValue{'
        'newValue: $newValue, '
        'newDefaultValue: $newDefaultValue, '
        'unitId: $unitId}';
  }
}

class UpdateConversionCoefficients extends ConversionEvent {
  final DynamicCoefficientsModel newCoefficients;

  const UpdateConversionCoefficients({
    required this.newCoefficients,
    super.onError,
    super.doAfter,
  });

  @override
  List<Object?> get props => [
        newCoefficients,
      ];

  @override
  String toString() {
    return 'UpdateConversionCoefficients{newCoefficients: $newCoefficients}';
  }
}

class RemoveConversionItems extends ConversionEvent {
  final List<int> unitIds;

  const RemoveConversionItems({
    required this.unitIds,
    super.onError,
    super.doAfter,
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

class ReplaceConversionItemUnit extends ConversionEvent {
  final UnitModel newUnit;
  final int oldUnitId;
  final RecalculationOnUnitChange recalculationMode;

  const ReplaceConversionItemUnit({
    required this.newUnit,
    required this.oldUnitId,
    required this.recalculationMode,
    super.doAfter,
    super.onError,
  });

  @override
  List<Object?> get props => [
        newUnit,
        oldUnitId,
        recalculationMode,
      ];

  @override
  String toString() {
    return 'ReplaceConversionItemUnit{'
        'newUnit: $newUnit, '
        'oldUnitId: $oldUnitId, '
        'recalculationMode: $recalculationMode}';
  }
}

class AddParamSetsToConversion extends ConversionParamsEvent {
  final List<int> paramSetIds;
  final bool fetchListValues;

  const AddParamSetsToConversion({
    required this.paramSetIds,
    required this.fetchListValues,
    super.doAfter,
    super.onError,
  });

  @override
  List<Object?> get props => [
        paramSetIds,
        fetchListValues,
      ];

  @override
  String toString() {
    return 'AddParamSetsToConversion{paramSetIds: $paramSetIds}';
  }
}

class RemoveSelectedParamSetFromConversion extends ConversionParamsEvent {
  const RemoveSelectedParamSetFromConversion({
    super.doAfter,
    super.onError,
  });

  @override
  String toString() {
    return 'RemoveSelectedParamSetFromConversion{}';
  }
}

class RemoveAllParamSetsFromConversion extends ConversionParamsEvent {
  const RemoveAllParamSetsFromConversion({
    super.doAfter,
    super.onError,
  });

  @override
  String toString() {
    return 'RemoveAllParamSetsFromConversion{}';
  }
}

class SelectParamSetInConversion extends ConversionParamsEvent {
  final int newSelectedParamSetIndex;

  const SelectParamSetInConversion({
    required this.newSelectedParamSetIndex,
    super.onError,
    super.doAfter,
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

class EditConversionParamValue extends ConversionParamsEvent {
  final ValueModel? newValue;
  final ValueModel? newDefaultValue;
  final ListValuesFetchResult? listValues;
  final int paramId;
  final int paramSetId;

  const EditConversionParamValue({
    required this.newValue,
    this.newDefaultValue,
    this.listValues,
    required this.paramId,
    required this.paramSetId,
    super.onError,
    super.doAfter,
  });

  @override
  List<Object?> get props => [
        newValue,
        newDefaultValue,
        listValues,
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

class ReplaceConversionParamUnit extends ConversionParamsEvent {
  final UnitModel newUnit;
  final int paramId;
  final int paramSetId;

  const ReplaceConversionParamUnit({
    required this.newUnit,
    required this.paramId,
    required this.paramSetId,
    super.doAfter,
    super.onError,
  });

  @override
  List<Object?> get props => [
        newUnit,
        paramId,
        paramSetId,
      ];

  @override
  String toString() {
    return 'ReplaceConversionParamUnit{'
        'newUnit: $newUnit, '
        'paramId: $paramId, '
        'paramSetId: $paramSetId}';
  }
}

class ToggleCalculableParam extends ConversionParamsEvent {
  final int paramId;
  final int paramSetId;

  const ToggleCalculableParam({
    required this.paramId,
    required this.paramSetId,
    super.doAfter,
    super.onError,
  });

  @override
  List<Object?> get props => [
        paramId,
        paramSetId,
      ];

  @override
  String toString() {
    return 'ToggleCalculableParam{'
        'paramId: $paramId, '
        'paramSetId: $paramSetId}';
  }
}
