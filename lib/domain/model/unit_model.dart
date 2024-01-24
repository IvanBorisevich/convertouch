import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';

class UnitModel extends IdNameItemModel {
  final double? coefficient;
  final String code;
  final String? symbol;
  final int unitGroupId;

  const UnitModel({
    super.id,
    required super.name,
    this.coefficient,
    required this.code,
    this.symbol,
    required this.unitGroupId,
  }) : super(
          itemType: ItemType.unit,
        );

  const UnitModel.onlyId(
    int id, {
    this.coefficient,
    this.code = '',
    this.symbol,
    this.unitGroupId = -1,
  }) : super(
          id: id,
          name: '',
          itemType: ItemType.unit,
        );

  @override
  List<Object?> get props => [
    id,
    name,
    itemType,
    coefficient,
    code,
    symbol,
    unitGroupId,
  ];

  @override
  String toString() {
    return 'UnitModel{$name, c=$coefficient}';
  }
}
