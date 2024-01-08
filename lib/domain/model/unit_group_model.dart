import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';

class UnitGroupModel extends IdNameItemModel {
  final String? iconName;
  final ConversionType conversionType;
  final bool refreshable;

  const UnitGroupModel({
    super.id,
    required super.name,
    this.iconName,
    this.conversionType = ConversionType.static,
    this.refreshable = false,
    super.itemType = ItemType.unitGroup,
  });

  const UnitGroupModel.onlyId(
    int? id, {
    this.iconName,
    this.conversionType = ConversionType.static,
    this.refreshable = false,
  }) : super(
          id: id,
          name: '',
          itemType: ItemType.unitGroup,
        );

  @override
  List<Object?> get props => [
    id,
    name,
    itemType,
    iconName,
    conversionType,
    refreshable,
  ];

  @override
  String toString() {
    return 'UnitGroupModel{$name}';
  }
}
