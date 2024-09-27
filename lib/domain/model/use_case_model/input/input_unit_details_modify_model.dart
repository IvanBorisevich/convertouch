import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

class InputUnitDetailsModifyModel<T> {
  final T delta;
  final UnitDetailsModel draft;
  final UnitDetailsModel saved;
  final UnitModel secondaryBaseUnit;

  const InputUnitDetailsModifyModel({
    required this.delta,
    required this.draft,
    required this.saved,
    this.secondaryBaseUnit = UnitModel.none,
  });
}
