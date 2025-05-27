import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/utils/conversion_rules/clothes_size.dart';
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
  ConvertouchListType.clothesSizeInter: _clothesSizesInter,
  ConvertouchListType.clothesSizeUs: _clothesSizesUs,
  ConvertouchListType.clothesSizeJp: _clothesSizesJp,
  ConvertouchListType.clothesSizeFr: _clothesSizesFr,
  ConvertouchListType.clothesSizeEu: _clothesSizesEu,
  ConvertouchListType.clothesSizeRu: _clothesSizesRu,
  ConvertouchListType.clothesSizeIt: _clothesSizesIt,
  ConvertouchListType.clothesSizeUk: _clothesSizesUk,
  ConvertouchListType.clothesSizeDe: _clothesSizesDe,
  ConvertouchListType.clothesSizeEs: _clothesSizesEs,
  ConvertouchListType.ringSizeUs: _ringSizesUs,
  ConvertouchListType.ringSizeUk: _ringSizesUk,
  ConvertouchListType.ringSizeDe: _ringSizesDe,
  ConvertouchListType.ringSizeEs: _ringSizesEs,
  ConvertouchListType.ringSizeFr: _ringSizesFr,
  ConvertouchListType.ringSizeRu: _ringSizesRu,
  ConvertouchListType.ringSizeIt: _ringSizesIt,
  ConvertouchListType.ringSizeJp: _ringSizesJp,
  ConvertouchListType.barbellBarWeight: _barbellBarWeightsKg,
};

List<String> _persons({double? c}) => Person.values.map((e) => e.name).toList();

List<String> _garments({double? c}) =>
    Garment.values.map((e) => e.name).toList();

List<String> _clothesSizesInter({double? c}) => [
      "XXS",
      "XS",
      "S",
      "M",
      "L",
      "XL",
      "XXL",
      "3XL",
    ];

List<String> _clothesSizesUs({double? c}) => [
      ...ObjectUtils.generateNumList(2, 14, step: 2),
      ...ObjectUtils.generateNumList(28, 42, step: 2),
    ];

List<String> _clothesSizesJp({double? c}) => [
      'S',
      'M',
      'L',
      'LL',
      '3L',
      '4L',
      '5L',
      '6L',
    ];

List<String> _clothesSizesFr({double? c}) => [
      ...ObjectUtils.generateNumList(34, 48, step: 2),
    ];

List<String> _clothesSizesEu({double? c}) => [
      ...ObjectUtils.generateNumList(34, 56, step: 2),
    ];

List<String> _clothesSizesRu({double? c}) => [
      ...ObjectUtils.generateNumList(40, 56, step: 2),
    ];

List<String> _clothesSizesIt({double? c}) => [
      ...ObjectUtils.generateNumList(38, 56, step: 2),
    ];

List<String> _clothesSizesUk({double? c}) => [
      ...ObjectUtils.generateNumList(6, 18, step: 2),
      ...ObjectUtils.generateNumList(26, 40, step: 2),
    ];

List<String> _clothesSizesDe({double? c}) => [
      ...ObjectUtils.generateNumList(32, 56, step: 2),
    ];

List<String> _clothesSizesEs({double? c}) => [
      ...ObjectUtils.generateNumList(34, 48, step: 2),
    ];

List<String> _ringSizesUs({double? c}) => [
      ...ObjectUtils.generateNumList(3, 15, step: 0.5, fractionDigits: 1),
    ];

List<String> _ringSizesUk({double? c}) => [
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z',
      'Z+2',
      'Z+3',
      'Z+4',
      'Z+5',
    ];

List<String> _ringSizesDe({double? c}) => ObjectUtils.fromNumList([
      44,
      47,
      48,
      49,
      51,
      52,
      53,
      54,
      56,
      57,
      58,
      60,
      61,
      62,
      64,
      65,
      66,
      68,
      69,
      70,
      72,
      73,
      74,
    ]);

List<String> _ringSizesEs({double? c}) => ObjectUtils.fromNumList([
      4,
      6.5,
      8,
      9.5,
      10.5,
      12,
      13.5,
      14.5,
      16,
      17,
      18.5,
      20,
      21,
      22.5,
      23.5,
      25,
      26,
      27.5,
      29,
      30,
      32,
      33,
      34.5,
      35,
    ]);

List<String> _ringSizesFr({double? c}) => ObjectUtils.fromNumList([
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
    ]);

List<String> _ringSizesRu({double? c}) => _ringSizesFr(c: c);

List<String> _ringSizesIt({double? c}) => ObjectUtils.fromNumList([
      4,
      5.5,
      7,
      8,
      9,
      10,
      11,
      12.5,
      14,
      15,
      16,
      17.5,
      19,
      20,
      21.5,
      23,
      24,
      25,
      26.5,
      28,
      28.5,
      32,
      33,
      35
    ]);

List<String> _ringSizesJp({double? c}) => [
      ...ObjectUtils.fromNumList([4, 5, 7, 8, 9, 10, 11]),
      ...ObjectUtils.generateNumList(13, 20),
      ...ObjectUtils.generateNumList(22, 23),
      ...ObjectUtils.fromNumList([24, 25, 26, 27]),
    ];

List<String> _barbellBarWeightsKg({double? c}) => [
      ...ObjectUtils.generateNumList(10, 20, step: 10, divisor: c),
    ];
