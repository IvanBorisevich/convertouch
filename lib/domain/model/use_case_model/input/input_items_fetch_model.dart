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

  Map<String, dynamic> toJson();
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

  @override
  Map<String, dynamic> toJson() {
    return {
      'parentItemId': parentItemId,
      'parentItemType': parentItemType.name,
    };
  }
}

class UnitGroupsFetchParams extends ItemsFetchParams {
  const UnitGroupsFetchParams();

  @override
  List<Object?> get props => [];

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
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

  @override
  Map<String, dynamic> toJson() {
    return {
      'parentItemId': parentItemId,
    };
  }
}

class ListValuesFetchParams extends ItemsFetchParams {
  final ConvertouchListType listType;
  final UnitModel? unit;

  const ListValuesFetchParams({
    required this.listType,
    this.unit,
  });

  @override
  List<Object?> get props => [
        listType,
        unit,
      ];

  @override
  Map<String, dynamic> toJson() {
    return {
      'listType': listType.id,
      'unit': unit?.toJson(),
    };
  }

  static ListValuesFetchParams? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    return ListValuesFetchParams(
      listType: ConvertouchListType.valueOf(json['listType'])!,
      unit: UnitModel.fromJson(json['unit']),
    );
  }
}
