import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/conversion_param_constants/clothing_size.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

abstract interface class ListValueRepository {
  const ListValueRepository();

  Future<Either<ConvertouchException, List<ListValueModel>>> get({
    required ConvertouchListType listType,
    String? searchString,
    required int pageNum,
    required int pageSize,
  });
}

final Map<ConvertouchListType, List<String>> listableSets = {
  ConvertouchListType.gender: Gender.values.map((e) => e.name).toList(),
  ConvertouchListType.garment: Garment.values.map((e) => e.name).toList(),
  ConvertouchListType.clothingSizeInter:
  ClothingSizeInter.values.map((e) => e.name).toList(),
  ConvertouchListType.clothingSizeUs: ObjectUtils.generateList(2, 24, 2)
    ..addAll(ObjectUtils.generateList(30, 50, 2)),
  ConvertouchListType.clothingSizeJp: ObjectUtils.generateList(7, 29, 2)
    ..addAll(ObjectUtils.generateList(32, 52, 2)),
  ConvertouchListType.clothingSizeFr: ObjectUtils.generateList(34, 56, 2)
    ..addAll(ObjectUtils.generateList(58, 60, 2)),
  ConvertouchListType.clothingSizeEu: ObjectUtils.generateList(34, 56, 2)
    ..addAll(ObjectUtils.generateList(58, 60, 2)),
  ConvertouchListType.clothingSizeRu: ObjectUtils.generateList(40, 62, 2),
  ConvertouchListType.clothingSizeIt: ObjectUtils.generateList(38, 60, 2),
  ConvertouchListType.clothingSizeUk: ObjectUtils.generateList(6, 50, 2),
};
