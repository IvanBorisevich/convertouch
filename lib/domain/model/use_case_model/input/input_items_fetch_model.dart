import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:equatable/equatable.dart';

class InputItemsFetchModel<P extends ItemsFetchParams> {
  final String? searchString;
  final int pageSize;
  final int pageNum;
  final P? params;

  const InputItemsFetchModel({
    this.searchString,
    required this.pageSize,
    required this.pageNum,
    this.params,
  });
}

abstract class ItemsFetchParams extends Equatable {
  const ItemsFetchParams();
}

class UnitsFetchParams extends ItemsFetchParams {
  final int parentItemId;
  final ItemType parentItemType;

  const UnitsFetchParams({
    required this.parentItemId,
    required this.parentItemType,
  });

  @override
  List<Object?> get props => [
        parentItemId,
        parentItemType,
      ];
}

class UnitGroupsFetchParams extends ItemsFetchParams {
  const UnitGroupsFetchParams();

  @override
  List<Object?> get props => [];
}

class ParamSetsFetchParams extends ItemsFetchParams {
  final int parentItemId;

  const ParamSetsFetchParams({
    required this.parentItemId,
  });

  @override
  List<Object?> get props => [
    parentItemId,
  ];
}

class DropdownItemsFetchParams extends ItemsFetchParams {
  final ConvertouchListType listType;
  final UnitModel? unit;

  const DropdownItemsFetchParams({
    required this.listType,
    this.unit,
  });

  @override
  List<Object?> get props => [
        listType,
        unit,
      ];
}
