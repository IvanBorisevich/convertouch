import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/utils/conversion_rules/clothing_size.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

abstract interface class ListValueRepository {
  const ListValueRepository();

  Future<Either<ConvertouchException, List<ListValueModel>>> search({
    required ConvertouchListType listType,
    String? searchString,
    required int pageNum,
    required int pageSize,
  });

  Future<Either<ConvertouchException, ListValueModel?>> getDefault({
    required ConvertouchListType listType,
  });

  Future<Either<ConvertouchException, bool>> belongsToList({
    required String? value,
    required ConvertouchListType listType,
  });
}

final Map<ConvertouchListType, List<String>> listableSets = {
  ConvertouchListType.gender: Gender.values.map((e) => e.name).toList(),
  ConvertouchListType.garment: Garment.values.map((e) => e.name).toList(),
  ConvertouchListType.clothingSizeInter: [
    "XXS",
    "XS",
    "S",
    "M",
    "L",
    "X",
    "XL",
    "XX",
    "XXL",
    "3X",
    "3XL",
  ],
  ConvertouchListType.clothingSizeUs: ObjectUtils.generateList(0, 24, 2)
    ..addAll(ObjectUtils.generateList(30, 50, 2)),
  ConvertouchListType.clothingSizeJp: ObjectUtils.generateList(3, 29, 2)
    ..addAll(ObjectUtils.generateList(32, 52, 2)),
  ConvertouchListType.clothingSizeFr: ObjectUtils.generateList(30, 56, 2)
    ..addAll(ObjectUtils.generateList(58, 60, 2)),
  ConvertouchListType.clothingSizeEu: ObjectUtils.generateList(32, 56, 2)
    ..addAll(ObjectUtils.generateList(58, 60, 2)),
  ConvertouchListType.clothingSizeRu: ObjectUtils.generateList(38, 62, 2),
  ConvertouchListType.clothingSizeIt: ObjectUtils.generateList(36, 60, 2),
  ConvertouchListType.clothingSizeUk: ObjectUtils.generateList(4, 50, 2),
  ConvertouchListType.ringSizeUs: ObjectUtils.generateList(3, 15, 0.5),
  ConvertouchListType.ringSizeFr: [
    44,
    46.5,
    48,
    49.5,
    50.5,
    52,
    53,
    54.5,
    55.5,
    57,
    58,
    59.5,
    61,
    62,
    63.5,
    64.5,
    66,
    67,
    68.5,
    69.5,
    71,
    72.5,
    73.5,
    75
  ].map((e) => e.toString()).toList(),
};
