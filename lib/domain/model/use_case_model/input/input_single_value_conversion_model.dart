import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

class InputSingleValueConversionModel {
  final UnitGroupModel unitGroup;
  final UnitModel tgtUnit;
  final ConversionUnitValueModel srcItem;

  const InputSingleValueConversionModel({
    required this.unitGroup,
    required this.srcItem,
    required this.tgtUnit,
  });
}
