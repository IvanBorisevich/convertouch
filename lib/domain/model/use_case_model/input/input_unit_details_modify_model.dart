import 'package:convertouch/domain/model/unit_details_model.dart';

class InputUnitDetailsModifyModel<T> {
  final UnitDetailsModel draft;
  final UnitDetailsModel saved;
  final T delta;

  const InputUnitDetailsModifyModel({
    required this.draft,
    required this.saved,
    required this.delta,
  });
}
