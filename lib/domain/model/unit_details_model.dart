import 'package:convertouch/domain/model/conversion_rule_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:equatable/equatable.dart';

class UnitDetailsModel extends Equatable {
  static const int unitCodeMaxLength = 5;

  final UnitGroupModel unitGroup;
  final UnitModel draftUnitData;
  final UnitModel savedUnitData;
  final bool existingUnit;
  final bool editMode;
  final bool unitGroupChanged;
  final bool deltaDetected;
  final ConversionRule conversionRule;
  final UnitModel resultUnit;

  const UnitDetailsModel({
    required this.unitGroup,
    this.draftUnitData = UnitModel.none,
    this.savedUnitData = UnitModel.none,
    this.existingUnit = false,
    this.editMode = false,
    this.unitGroupChanged = false,
    this.deltaDetected = false,
    this.conversionRule = ConversionRule.none,
    this.resultUnit = UnitModel.none,
  });

  UnitDetailsModel.coalesce(
    UnitDetailsModel saved, {
    UnitGroupModel? unitGroup,
    UnitModel? draftUnit,
    UnitModel? savedUnit,
    ConversionRule? conversionRule,
  }) : this(
          editMode: saved.editMode,
          existingUnit: saved.existingUnit,
          unitGroupChanged: saved.unitGroupChanged,
          deltaDetected: saved.deltaDetected,
          unitGroup: unitGroup ?? saved.unitGroup,
          draftUnitData: draftUnit ?? saved.draftUnitData,
          savedUnitData: savedUnit ?? saved.savedUnitData,
          conversionRule: conversionRule ?? saved.conversionRule,
          resultUnit: saved.resultUnit,
        );

  @override
  List<Object?> get props => [
        unitGroup,
        draftUnitData,
        savedUnitData,
        existingUnit,
        editMode,
        unitGroupChanged,
        deltaDetected,
        conversionRule,
        resultUnit,
      ];

  @override
  String toString() {
    return 'UnitDetailsModel{'
        'unitGroup: $unitGroup, '
        'draftUnitData: $draftUnitData, '
        'savedUnitData: $savedUnitData, '
        'existingUnit: $existingUnit, '
        'editMode: $editMode, '
        'unitGroupChanged: $unitGroupChanged, '
        'deltaDetected: $deltaDetected, '
        'conversionRule: $conversionRule, '
        'resultUnit: $resultUnit}';
  }
}
