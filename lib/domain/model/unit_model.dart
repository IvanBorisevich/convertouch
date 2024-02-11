import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class UnitModel extends IdNameItemModel {
  static const UnitModel none = UnitModel._();

  final String code;
  final double? coefficient;
  final String? symbol;
  final int unitGroupId;

  const UnitModel({
    super.id,
    required super.name,
    required this.code,
    this.coefficient,
    this.symbol,
    this.unitGroupId = -1,
    super.oob,
  }) : super(
          itemType: ItemType.unit,
        );

  const UnitModel._()
      : this(
          name: "",
          code: "",
        );

  const UnitModel.onlyId(int id)
      : this(
          id: id,
          name: "",
          code: "",
        );

  UnitModel.coalesce(
    UnitModel currentModel, {
    int? id,
    String? name,
    String? code,
    double? coefficient,
    String? symbol,
    int? unitGroupId,
  }) : this(
          id: ObjectUtils.coalesce(
            what: currentModel.id,
            patchWith: id,
          ),
          name: ObjectUtils.coalesce(
                what: currentModel.name,
                patchWith: name,
              ) ??
              "",
          code: ObjectUtils.coalesce(
                what: currentModel.code,
                patchWith: code,
              ) ??
              "",
          coefficient: ObjectUtils.coalesce(
            what: currentModel.coefficient,
            patchWith: coefficient,
          ),
          symbol: ObjectUtils.coalesce(
            what: currentModel.symbol,
            patchWith: symbol,
          ),
          unitGroupId: ObjectUtils.coalesce(
                what: currentModel.unitGroupId,
                patchWith: unitGroupId,
              ) ??
              -1,
        );

  bool get empty => this == none;

  bool get notEmpty => this != none;

  bool get named => name.isNotEmpty;

  bool get unnamed => name.isEmpty;

  @override
  List<Object?> get props => [
        id,
        name,
        itemType,
        coefficient,
        code,
        symbol,
        unitGroupId,
        oob,
      ];

  @override
  String toString() {
    if (this == UnitModel.none) {
      return "UnitModel.none";
    }
    return 'UnitModel{'
        'id: $id, $code, $name, c: $coefficient, groupId: $unitGroupId}';
  }
}
