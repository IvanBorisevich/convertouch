import 'package:convertouch/domain/model/conversion_rule_form_model.dart';
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
  final ConversionRuleFormModel conversionRule;
  final UnitModel resultUnit;

  const UnitDetailsModel({
    required this.unitGroup,
    this.draftUnitData = UnitModel.none,
    this.savedUnitData = UnitModel.none,
    this.existingUnit = false,
    this.editMode = false,
    this.unitGroupChanged = false,
    this.deltaDetected = false,
    required this.conversionRule,
    this.resultUnit = UnitModel.none,
  });

  UnitDetailsModel copyWith({
    UnitGroupModel? unitGroup,
    UnitModel? draftUnit,
    UnitModel? savedUnit,
    ConversionRuleFormModel? conversionRule,
  }) {
    return UnitDetailsModel(
      editMode: editMode,
      existingUnit: existingUnit,
      unitGroupChanged: unitGroupChanged,
      deltaDetected: deltaDetected,
      unitGroup: unitGroup ?? this.unitGroup,
      draftUnitData: draftUnit ?? draftUnitData,
      savedUnitData: savedUnit ?? savedUnitData,
      conversionRule: conversionRule ?? this.conversionRule,
      resultUnit: resultUnit,
    );
  }

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
