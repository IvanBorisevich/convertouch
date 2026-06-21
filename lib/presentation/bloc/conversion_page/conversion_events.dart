import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class ConversionEvent extends ConvertouchEvent {
  final bool rebuildUnitValues;

  final void Function(
    ConversionModel, {
    ConvertouchException? info,
  })? onConversionUpdated;

  const ConversionEvent({
    this.onConversionUpdated,
    super.onError,
    required this.rebuildUnitValues,
  });
}

abstract class ModifyConversion extends ConversionEvent {
  const ModifyConversion({
    super.onConversionUpdated,
    super.onError,
    required super.rebuildUnitValues,
  });
}

class GetConversion extends ConversionEvent {
  final UnitGroupModel unitGroup;
  final void Function(ConversionModel)? processPrevConversion;
  final void Function(ConversionModel?)? processCurrentConversion;

  const GetConversion({
    required this.unitGroup,
    this.processPrevConversion,
    this.processCurrentConversion,
  }) : super(rebuildUnitValues: true);

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
    super.onError,
    super.onConversionUpdated,
  }) : super(rebuildUnitValues: false);

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
    super.onConversionUpdated,
  }) : super(rebuildUnitValues: true);

  @override
  String toString() {
    return 'CleanupConversion{'
        'keepParams: $keepParams}';
  }
}

class EditConversionGroup extends ModifyConversion {
  final UnitGroupModel editedGroup;

  const EditConversionGroup({
    required this.editedGroup,
    super.onError,
    super.onConversionUpdated,
  }) : super(rebuildUnitValues: false);

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
    super.onError,
    super.onConversionUpdated,
  }) : super(rebuildUnitValues: true);

  @override
  List<Object?> get props => [
        unitIds,
      ];

  @override
  String toString() {
    return 'AddUnitsToConversion{unitIds: $unitIds}';
  }
}

class EditConversionUnit extends ModifyConversion {
  final UnitModel editedUnit;

  const EditConversionUnit({
    required this.editedUnit,
    super.onError,
    super.onConversionUpdated,
  }) : super(rebuildUnitValues: false);

  @override
  List<Object?> get props => [
        editedUnit,
      ];

  @override
  String toString() {
    return 'EditConversionUnit{editedUnit: $editedUnit}';
  }
}

class EditConversionUnitValue extends ModifyConversion {
  final ValueModel? newValue;
  final ValueModel? newDefaultValue;
  final int unitId;

  const EditConversionUnitValue({
    required this.newValue,
    this.newDefaultValue,
    required this.unitId,
    super.onError,
    super.onConversionUpdated,
  }) : super(rebuildUnitValues: false);

  @override
  List<Object?> get props => [
        newValue,
        newDefaultValue,
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

class UpdateConversionCoefficients extends ModifyConversion {
  final DynamicCoefficientsModel newCoefficients;

  const UpdateConversionCoefficients({
    required this.newCoefficients,
    super.onError,
  }) : super(rebuildUnitValues: false);

  @override
  List<Object?> get props => [
        newCoefficients,
      ];

  @override
  String toString() {
    return 'UpdateConversionCoefficients{newCoefficients: $newCoefficients}';
  }
}

class RemoveConversionItems extends ModifyConversion {
  final List<int> unitIds;

  const RemoveConversionItems({
    required this.unitIds,
    super.onError,
  }) : super(rebuildUnitValues: true);

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
  final RecalculationOnUnitChange recalculationMode;

  const ReplaceConversionItemUnit({
    required this.newUnit,
    required this.oldUnitId,
    required this.recalculationMode,
    super.onConversionUpdated,
    super.onError,
  }) : super(rebuildUnitValues: false);

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

class AddParamSetsToConversion extends ModifyConversion {
  final List<int> paramSetIds;

  const AddParamSetsToConversion({
    required this.paramSetIds,
    super.onConversionUpdated,
    super.onError,
  }) : super(rebuildUnitValues: false);

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
  const RemoveSelectedParamSetFromConversion({
    super.onError,
  }) : super(rebuildUnitValues: false);

  @override
  String toString() {
    return 'RemoveSelectedParamSetFromConversion{}';
  }
}

class RemoveAllParamSetsFromConversion extends ModifyConversion {
  const RemoveAllParamSetsFromConversion({
    super.onError,
  }) : super(rebuildUnitValues: false);

  @override
  String toString() {
    return 'RemoveAllParamSetsFromConversion{}';
  }
}

class SelectParamSetInConversion extends ModifyConversion {
  final int newSelectedParamSetIndex;

  const SelectParamSetInConversion({
    required this.newSelectedParamSetIndex,
    super.onError,
  }) : super(rebuildUnitValues: false);

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
  final ValueModel? newValue;
  final ValueModel? newDefaultValue;
  final int paramId;
  final int paramSetId;

  const EditConversionParamValue({
    required this.newValue,
    this.newDefaultValue,
    required this.paramId,
    required this.paramSetId,
    super.onError,
    super.onConversionUpdated,
  }) : super(rebuildUnitValues: false);

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

class ReplaceConversionParamUnit extends ModifyConversion {
  final UnitModel newUnit;
  final int paramId;
  final int paramSetId;

  const ReplaceConversionParamUnit({
    required this.newUnit,
    required this.paramId,
    required this.paramSetId,
    super.onConversionUpdated,
    super.onError,
  }) : super(rebuildUnitValues: false);

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

class ToggleCalculableParam extends ModifyConversion {
  final int paramId;
  final int paramSetId;

  const ToggleCalculableParam({
    required this.paramId,
    required this.paramSetId,
    super.onError,
  }) : super(rebuildUnitValues: false);

  @override
  List<Object?> get props => [
        paramId,
        paramSetId,
      ];
}
