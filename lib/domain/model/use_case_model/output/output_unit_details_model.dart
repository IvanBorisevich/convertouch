import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

class OutputUnitDetailsModel {
  final UnitDetailsModel draft;
  final UnitDetailsModel saved;
  final UnitModel? unitToSave;
  final UnitModel secondaryBaseUnit;
  final bool editMode;
  final bool unitGroupChanged;
  final bool conversionConfigVisible;
  final bool conversionConfigEditable;
  final String? conversionDescription;
  final String? note;

  const OutputUnitDetailsModel({
    required this.draft,
    required this.saved,
    required this.unitToSave,
    this.secondaryBaseUnit = UnitModel.none,
    this.editMode = false,
    this.unitGroupChanged = false,
    this.conversionConfigVisible = false,
    this.conversionConfigEditable = false,
    this.conversionDescription,
    this.note,
  });
}
