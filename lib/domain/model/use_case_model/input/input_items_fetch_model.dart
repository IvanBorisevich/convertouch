import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_model.dart';

class InputItemsFetchModel<P extends ItemsFetchParams> {
  final String? searchString;
  final int parentItemId;
  final int pageSize;
  final int pageNum;
  final ConvertouchListType? listType;
  final ItemType? parentItemType;
  final P? params;

  const InputItemsFetchModel({
    this.searchString,
    this.parentItemId = -1,
    required this.pageSize,
    required this.pageNum,
    this.listType,
    this.parentItemType,
    this.params,
  });
}

abstract class ItemsFetchParams {
  const ItemsFetchParams();
}

class UnitsFetchParams extends ItemsFetchParams {
  const UnitsFetchParams();
}

class UnitGroupsFetchParams extends ItemsFetchParams {
  const UnitGroupsFetchParams();
}

class ParamSetsFetchParams extends ItemsFetchParams {
  const ParamSetsFetchParams();
}

class DropdownItemsFetchParams extends ItemsFetchParams {
  final UnitModel? unit;

  const DropdownItemsFetchParams({
    this.unit,
  });
}
