import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:equatable/equatable.dart';

class InputItemsFetchModel<P extends ItemsFetchParams> {
  final String? searchString;
  final int pageSize;
  final int pageNum;
  final P? fetchParams;

  const InputItemsFetchModel({
    this.searchString,
    required this.pageSize,
    required this.pageNum,
    this.fetchParams,
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

  @override
  String toString() {
    return 'UnitsFetchParams{parentItemId: $parentItemId}';
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

  @override
  String toString() {
    return 'UnitGroupsFetchParams{}';
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

  @override
  String toString() {
    return 'ParamSetsFetchParams{parentItemId: $parentItemId}';
  }
}

class ListValuesFetchParams extends ItemsFetchParams {
  final String itemId;
  final ConvertouchListType listType;
  final String? conversionGroupName;
  final UnitModel? unit;
  final ConversionParamSetValueModel? params;

  const ListValuesFetchParams({
    required this.itemId,
    required this.listType,
    this.unit,
    this.conversionGroupName,
    this.params,
  });

  @override
  List<Object?> get props => [
        itemId,
        listType,
        unit,
        conversionGroupName,
        params,
      ];

  @override
  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'listType': listType.id,
      'unit': unit?.toJson(),
      'conversionGroupName': conversionGroupName,
      'params': params?.toJson(),
    };
  }

  static ListValuesFetchParams? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    return ListValuesFetchParams(
      itemId: json['itemId'] ?? -1,
      listType: ConvertouchListType.valueOf(json['listType'])!,
      unit: UnitModel.fromJson(json['unit']),
      conversionGroupName: json['groupName'],
      params: ConversionParamSetValueModel.fromJson(json['params']),
    );
  }

  @override
  String toString() {
    return 'ListValuesFetchParams{itemId: $itemId, listType: $listType}';
  }
}
