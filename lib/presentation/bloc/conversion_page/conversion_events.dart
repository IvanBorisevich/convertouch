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
  final bool rebuildUnitValues;
  final bool rebuildParams;

  final void Function(
    ConversionModel, {
    ConvertouchException? info,
  })? onConversionUpdated;

  const ConversionEvent({
    this.onConversionUpdated,
    super.onError,
    required this.rebuildUnitValues,
    required this.rebuildParams,
  });
}

class GetUpdatedConversion extends ConversionEvent {
  final Future<ConversionModel> Function(ConversionModel) mappingFunc;

  const GetUpdatedConversion({
    required this.mappingFunc,
  }) : super(rebuildUnitValues: false, rebuildParams: false);

  @override
  List<Object?> get props => [
        mappingFunc,
      ];

  @override
  String toString() {
    return 'GetUpdatedConversion{}';
  }
}

class GetOrBuildConversion extends ConversionEvent {
  final UnitGroupModel unitGroup;
  final void Function(ConversionModel)? processPrevConversion;
  final void Function(ConversionModel?)? processCurrentConversion;
  final void Function(ConversionParamValueModel)? onParamValueUpdated;

  const GetOrBuildConversion({
    required this.unitGroup,
    this.processPrevConversion,
    this.processCurrentConversion,
    this.onParamValueUpdated,
  }) : super(rebuildUnitValues: true, rebuildParams: true);

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
    super.onConversionUpdated,
  }) : super(rebuildUnitValues: false, rebuildParams: false);

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
  }) : super(rebuildUnitValues: true, rebuildParams: !keepParams);

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
    super.onError,
    super.onConversionUpdated,
  }) : super(rebuildUnitValues: true, rebuildParams: false);

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
    super.onConversionUpdated,
  }) : super(rebuildUnitValues: false, rebuildParams: false);

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
    super.onConversionUpdated,
  }) : super(rebuildUnitValues: true, rebuildParams: false);

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
    super.onConversionUpdated,
  }) : super(rebuildUnitValues: false, rebuildParams: false);

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
  final int unitId;

  const EditConversionUnitValue({
    required this.newValue,
    this.newDefaultValue,
    required this.unitId,
    super.onError,
    super.onConversionUpdated,
  }) : super(rebuildUnitValues: false, rebuildParams: false);

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

class UpdateConversionCoefficients extends ConversionEvent {
  final DynamicCoefficientsModel newCoefficients;

  const UpdateConversionCoefficients({
    required this.newCoefficients,
    super.onError,
  }) : super(rebuildUnitValues: false, rebuildParams: false);

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
  }) : super(rebuildUnitValues: true, rebuildParams: false);

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
    super.onConversionUpdated,
    super.onError,
  }) : super(rebuildUnitValues: false, rebuildParams: false);

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

class AddParamSetsToConversion extends ConversionEvent {
  final List<int> paramSetIds;

  const AddParamSetsToConversion({
    required this.paramSetIds,
    super.onConversionUpdated,
    super.onError,
  }) : super(rebuildUnitValues: false, rebuildParams: true);

  @override
  List<Object?> get props => [
        paramSetIds,
      ];

  @override
  String toString() {
    return 'AddParamSetsToConversion{paramSetIds: $paramSetIds}';
  }
}

class RemoveSelectedParamSetFromConversion extends ConversionEvent {
  const RemoveSelectedParamSetFromConversion({
    super.onError,
  }) : super(rebuildUnitValues: false, rebuildParams: true);

  @override
  String toString() {
    return 'RemoveSelectedParamSetFromConversion{}';
  }
}

class RemoveAllParamSetsFromConversion extends ConversionEvent {
  const RemoveAllParamSetsFromConversion({
    super.onError,
  }) : super(rebuildUnitValues: false, rebuildParams: true);

  @override
  String toString() {
    return 'RemoveAllParamSetsFromConversion{}';
  }
}

class SelectParamSetInConversion extends ConversionEvent {
  final int newSelectedParamSetIndex;

  const SelectParamSetInConversion({
    required this.newSelectedParamSetIndex,
    super.onError,
  }) : super(rebuildUnitValues: false, rebuildParams: true);

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

class EditConversionParamValue extends ConversionEvent {
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
  }) : super(rebuildUnitValues: false, rebuildParams: false);

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

class ReplaceConversionParamUnit extends ConversionEvent {
  final UnitModel newUnit;
  final int paramId;
  final int paramSetId;

  const ReplaceConversionParamUnit({
    required this.newUnit,
    required this.paramId,
    required this.paramSetId,
    super.onConversionUpdated,
    super.onError,
  }) : super(rebuildUnitValues: false, rebuildParams: false);

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

class ToggleCalculableParam extends ConversionEvent {
  final int paramId;
  final int paramSetId;

  const ToggleCalculableParam({
    required this.paramId,
    required this.paramSetId,
    super.onConversionUpdated,
    super.onError,
  }) : super(rebuildUnitValues: false, rebuildParams: false);

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

class RefreshParamListValues extends ConversionEvent {
  final int paramId;
  final void Function(ConversionParamValueModel)? onParamValueUpdated;

  const RefreshParamListValues({
    required this.paramId,
    this.onParamValueUpdated,
  }) : super(rebuildUnitValues: false, rebuildParams: false);

  @override
  List<Object?> get props => [
        paramId,
      ];

  @override
  String toString() {
    return 'RefreshParamListValues{paramId: $paramId}';
  }
}
