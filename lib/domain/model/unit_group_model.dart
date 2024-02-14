import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class UnitGroupModel extends IdNameItemModel {
  static const UnitGroupModel none = UnitGroupModel._();

  final String? iconName;
  final ConversionType conversionType;
  final bool refreshable;

  const UnitGroupModel({
    super.id,
    required super.name,
    this.iconName,
    this.conversionType = ConversionType.static,
    this.refreshable = false,
    super.oob,
    super.itemType = ItemType.unitGroup,
  });

  const UnitGroupModel.onlyId(
    int? id, {
    this.iconName,
    this.conversionType = ConversionType.static,
    this.refreshable = false,
    super.oob,
  }) : super(
          id: id,
          name: '',
          itemType: ItemType.unitGroup,
        );

  UnitGroupModel.coalesce(
    UnitGroupModel savedUnitGroup, {
    int? id,
    String? name,
    String? iconName,
  }) : this(
          id: ObjectUtils.coalesce(
            what: savedUnitGroup.id,
            patchWith: id,
          ),
          name: ObjectUtils.coalesce(
                what: savedUnitGroup.name,
                patchWith: name,
              ) ??
              "",
          iconName: ObjectUtils.coalesce(
            what: savedUnitGroup.iconName,
            patchWith: iconName,
          ),
          conversionType: savedUnitGroup.conversionType,
          refreshable: savedUnitGroup.refreshable,
          oob: savedUnitGroup.oob,
        );

  const UnitGroupModel._()
      : this(
          name: "",
        );

  @override
  List<Object?> get props => [
        id,
        name,
        itemType,
        iconName,
        conversionType,
        refreshable,
        oob,
      ];

  @override
  String toString() {
    return 'UnitGroupModel{$name}';
  }
}
