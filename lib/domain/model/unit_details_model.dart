import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:equatable/equatable.dart';

class UnitDetailsModel extends Equatable {
  static const UnitDetailsModel empty = UnitDetailsModel();
  static const int unitCodeMaxLength = 4;

  final UnitGroupModel? unitGroup;
  final UnitModel unit;
  final ValueModel value;
  final UnitModel argUnit;
  final ValueModel argValue;

  const UnitDetailsModel({
    this.unitGroup,
    this.unit = UnitModel.none,
    this.value = ValueModel.none,
    this.argUnit = UnitModel.none,
    this.argValue = ValueModel.none,
  });

  UnitDetailsModel.coalesce(
    UnitDetailsModel currentModel, {
    UnitGroupModel? unitGroup,
    UnitModel? unit,
    ValueModel? value,
    UnitModel? argUnit,
    ValueModel? argValue,
  }) : this(
          unitGroup: ObjectUtils.coalesce(
            what: currentModel.unitGroup,
            patchWith: unitGroup,
          ),
          unit: ObjectUtils.coalesce(
                what: currentModel.unit,
                patchWith: unit,
              ) ??
              UnitModel.none,
          value: ObjectUtils.coalesce(
                what: currentModel.value,
                patchWith: value,
              ) ??
              ValueModel.none,
          argUnit: ObjectUtils.coalesce(
                what: currentModel.argUnit,
                patchWith: argUnit,
              ) ??
              UnitModel.none,
          argValue: ObjectUtils.coalesce(
                what: currentModel.argValue,
                patchWith: argValue,
              ) ??
              ValueModel.none,
        );

  @override
  List<Object?> get props => [
        unitGroup,
        unit,
        value,
        argUnit,
        argValue,
      ];

  @override
  String toString() {
    return 'UnitDetailsModel{'
        'unitGroup: $unitGroup, '
        'unit: $unit, '
        'value: $value, '
        'argUnit: $argUnit, '
        'argValue: $argValue}';
  }
}
