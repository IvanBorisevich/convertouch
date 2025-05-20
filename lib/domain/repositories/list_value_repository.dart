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
    double? coefficient,
  });

  Future<Either<ConvertouchException, ListValueModel?>> getDefault({
    required ConvertouchListType listType,
    double? coefficient,
  });

  Future<Either<ConvertouchException, bool>> belongsToList({
    required String? value,
    required ConvertouchListType listType,
    double? coefficient,
  });
}

const Map<ConvertouchListType, List<String> Function({double? c})>
    listableSets = {
  ConvertouchListType.person: _persons,
  ConvertouchListType.garment: _garments,
  ConvertouchListType.clothingSizeInter: _clothingSizesInter,
  ConvertouchListType.clothingSizeUs: _clothingSizesUs,
  ConvertouchListType.clothingSizeJp: _clothingSizesJp,
  ConvertouchListType.clothingSizeFr: _clothingSizesFr,
  ConvertouchListType.clothingSizeEu: _clothingSizesEu,
  ConvertouchListType.clothingSizeRu: _clothingSizesRu,
  ConvertouchListType.clothingSizeIt: _clothingSizesIt,
  ConvertouchListType.clothingSizeUk: _clothingSizesUk,
  ConvertouchListType.clothingSizeDe: _clothingSizesDe,
  ConvertouchListType.clothingSizeEs: _clothingSizesEs,
  ConvertouchListType.ringSizeUs: _ringSizesUs,
  ConvertouchListType.ringSizeFr: _ringSizesFr,
  ConvertouchListType.barbellBarWeight: _barbellBarWeightsKg,
};

List<String> _persons({double? c}) => Person.values.map((e) => e.name).toList();

List<String> _garments({double? c}) =>
    Garment.values.map((e) => e.name).toList();

List<String> _clothingSizesInter({double? c}) => [
      "XXS",
      "XS",
      "S",
      "M",
      "L",
      "XL",
      "XXL",
      "3XL",
    ];

List<String> _clothingSizesUs({double? c}) => [
      ...ObjectUtils.generateList(2, 14, 2),
      ...ObjectUtils.generateList(28, 42, 2),
    ];

List<String> _clothingSizesJp({double? c}) => [
      'S',
      'M',
      'L',
      'LL',
      '3L',
      '4L',
      '5L',
      '6L',
    ];

List<String> _clothingSizesFr({double? c}) => [
      ...ObjectUtils.generateList(34, 48, 2),
    ];

List<String> _clothingSizesEu({double? c}) => [
      ...ObjectUtils.generateList(34, 56, 2),
    ];

List<String> _clothingSizesRu({double? c}) => [
      ...ObjectUtils.generateList(40, 56, 2),
    ];

List<String> _clothingSizesIt({double? c}) => [
      ...ObjectUtils.generateList(38, 56, 2),
    ];

List<String> _clothingSizesUk({double? c}) => [
      ...ObjectUtils.generateList(6, 18, 2),
      ...ObjectUtils.generateList(26, 40, 2),
    ];

List<String> _clothingSizesDe({double? c}) => [
      ...ObjectUtils.generateList(32, 56, 2),
    ];

List<String> _clothingSizesEs({double? c}) => [
      ...ObjectUtils.generateList(34, 48, 2),
    ];

List<String> _ringSizesUs({double? c}) => [
      ...ObjectUtils.generateList(3, 15, 0.5),
    ];

List<String> _ringSizesFr({double? c}) => [
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
    ].map((e) => e.toString()).toList();

List<String> _barbellBarWeightsKg({double? c}) => [
      ...ObjectUtils.generateList(10, 20, 25, multiplier: c),
    ];
