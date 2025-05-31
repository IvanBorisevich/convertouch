import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_model.dart';

class InputListValueSelectionModel {
  final String? value;
  final ConvertouchListType listType;
  final UnitModel? unit;

  const InputListValueSelectionModel({
    required this.value,
    required this.listType,
    this.unit,
  });
}
