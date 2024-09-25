import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

class OutputUnitDetailsModel {
  final UnitDetailsModel draft;
  final UnitDetailsModel saved;
  final UnitModel? unitToSave;
  final bool editMode;
  final bool conversionConfigEditable;
  final bool unitGroupChanged;
  final String? conversionDescription;
  final String? note;

  const OutputUnitDetailsModel({
    required this.draft,
    required this.saved,
    required this.unitToSave,
    this.editMode = false,
    this.conversionConfigEditable = false,
    this.unitGroupChanged = false,
    this.conversionDescription,
    this.note,
  });
}
