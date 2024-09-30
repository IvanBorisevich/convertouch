import 'package:convertouch/domain/model/conversion_rule_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:equatable/equatable.dart';

class UnitDetailsModel extends Equatable {
  static const int unitCodeMaxLength = 5;

  final UnitGroupModel unitGroup;
  final UnitModel draftUnitData;
  final UnitModel savedUnitData;
  final bool editMode;
  final bool unitGroupChanged;
  final ConversionRule conversionRule;
  final UnitModel unitToSave;

  const UnitDetailsModel({
    required this.unitGroup,
    this.draftUnitData = UnitModel.none,
    this.savedUnitData = UnitModel.none,
    this.editMode = false,
    this.unitGroupChanged = false,
    this.conversionRule = ConversionRule.none,
    this.unitToSave = UnitModel.none,
  });

  UnitDetailsModel.coalesce(
    UnitDetailsModel model, {
    UnitGroupModel? unitGroup,
    UnitModel? draftUnit,
    UnitModel? savedUnit,
    ConversionRule? conversionRule,
  }) : this(
          editMode: model.editMode,
          unitGroupChanged: model.unitGroupChanged,
          unitGroup: unitGroup ?? model.unitGroup,
          draftUnitData: draftUnit ?? model.draftUnitData,
          savedUnitData: savedUnit ?? model.savedUnitData,
          conversionRule: conversionRule ?? model.conversionRule,
          unitToSave: model.unitToSave,
        );

  @override
  List<Object?> get props => [
        unitGroup,
        draftUnitData,
        savedUnitData,
        editMode,
        unitGroupChanged,
        conversionRule,
        unitToSave,
      ];

  @override
  String toString() {
    return 'UnitDetailsModel{'
        'unitGroup: $unitGroup, '
        'draft: $draftUnitData, '
        'saved: $savedUnitData, '
        'unitGroupChanged: $unitGroupChanged, '
        'unitToSave: $unitToSave}';
  }
}
