import 'dart:math';

import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/repositories/list_value_repository.dart';
import 'package:convertouch/domain/utils/conversion_rules/clothes_size.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class ListValueRepositoryImpl implements ListValueRepository {
  const ListValueRepositoryImpl();

  @override
  Future<Either<ConvertouchException, List<ListValueModel>>> search({
    required ConvertouchListType listType,
    String? searchString,
    required int pageNum,
    required int pageSize,
    UnitModel? unit,
  }) async {
    List<ListValueModel>? fullList = _listValues[listType]?.call(unit: unit);

    if (fullList == null) {
      return const Right([]);
    }

    int end = min((pageNum + 1) * pageSize, fullList.length);
    List<ListValueModel> result = fullList.sublist(pageNum * pageSize, end);

    return Right(result);
  }

  @override
  Future<Either<ConvertouchException, ListValueModel?>> getDefault({
    required ConvertouchListType listType,
    UnitModel? unit,
  }) async {
    return Right(
      listType.preselected
          ? _listValues[listType]?.call(unit: unit).firstOrNull
          : null,
    );
  }

  @override
  Future<Either<ConvertouchException, bool>> belongsToList({
    required String? value,
    required ConvertouchListType listType,
    UnitModel? unit,
  }) async {
    if (value == null) {
      return const Right(true);
    }

    bool belongs =
        _listValues[listType]?.call(unit: unit).any((v) => v.value == value) ??
            false;

    return Right(belongs);
  }

  @override
  Future<Either<ConvertouchException, ListValueModel?>> getByStrValue({
    required ConvertouchListType listType,
    required String? value,
    UnitModel? unit,
  }) async {
    if (value == null) {
      return const Right(null);
    }

    ListValueModel? result = _listValues[listType]
        ?.call(unit: unit)
        .firstWhereOrNull((v) => v.value == value);

    return Right(result);
  }
}

const Map<ConvertouchListType, List<ListValueModel> Function({UnitModel? unit})>
    _listValues = {
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
  ConvertouchListType.barbellBarWeight: _barbellBarWeights,
};

String _defaultMap<T>(T value) => value.toString();

List<ListValueModel> _wrapList<T>(
  List<T> src, {
  String Function(T)? valueMap,
  String Function(T)? altValueMap,
}) {
  return src.map((v) {
    String value = (valueMap ?? _defaultMap).call(v);
    String? alt = altValueMap?.call(v);

    return ListValueModel(
      value: value,
      alt: alt,
    );
  }).toList();
}

List<ListValueModel> _persons({UnitModel? unit}) => _wrapList(
      Person.values,
      valueMap: (v) => v.name,
    );

List<ListValueModel> _garments({UnitModel? unit}) => _wrapList(
      Garment.values,
      valueMap: (v) => v.name,
    );

List<ListValueModel> _clothesSizesInter({UnitModel? unit}) => _wrapList([
      "XXS",
      "XS",
      "S",
      "M",
      "L",
      "XL",
      "XXL",
      "3XL",
    ]);

List<ListValueModel> _clothesSizesUs({UnitModel? unit}) => _wrapList([
      ...ObjectUtils.generateNumList(2, 14, step: 2),
      ...ObjectUtils.generateNumList(28, 42, step: 2),
    ]);

List<ListValueModel> _clothesSizesJp({UnitModel? unit}) => _wrapList([
      'S',
      'M',
      'L',
      'LL',
      '3L',
      '4L',
      '5L',
      '6L',
    ]);

List<ListValueModel> _clothesSizesFr({UnitModel? unit}) => _wrapList([
      ...ObjectUtils.generateNumList(34, 48, step: 2),
    ]);

List<ListValueModel> _clothesSizesEu({UnitModel? unit}) => _wrapList([
      ...ObjectUtils.generateNumList(34, 56, step: 2),
    ]);

List<ListValueModel> _clothesSizesRu({UnitModel? unit}) => _wrapList([
      ...ObjectUtils.generateNumList(40, 56, step: 2),
    ]);

List<ListValueModel> _clothesSizesIt({UnitModel? unit}) => _wrapList([
      ...ObjectUtils.generateNumList(38, 56, step: 2),
    ]);

List<ListValueModel> _clothesSizesUk({UnitModel? unit}) => _wrapList([
      ...ObjectUtils.generateNumList(6, 18, step: 2),
      ...ObjectUtils.generateNumList(26, 40, step: 2),
    ]);

List<ListValueModel> _clothesSizesDe({UnitModel? unit}) => _wrapList([
      ...ObjectUtils.generateNumList(32, 56, step: 2),
    ]);

List<ListValueModel> _clothesSizesEs({UnitModel? unit}) => _wrapList([
      ...ObjectUtils.generateNumList(34, 48, step: 2),
    ]);

List<ListValueModel> _ringSizesUs({UnitModel? unit}) => _wrapList([
      ...ObjectUtils.generateNumList(3, 15, step: 0.5, fractionDigits: 1),
    ]);

List<ListValueModel> _ringSizesUk({UnitModel? unit}) => _wrapList([
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
    ]);

List<ListValueModel> _ringSizesDe({UnitModel? unit}) =>
    _wrapList(ObjectUtils.fromNumList([
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
    ]));

List<ListValueModel> _ringSizesEs({UnitModel? unit}) =>
    _wrapList(ObjectUtils.fromNumList([
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
    ]));

List<ListValueModel> _ringSizesFr({UnitModel? unit}) =>
    _wrapList(ObjectUtils.fromNumList([
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
    ]));

List<ListValueModel> _ringSizesRu({UnitModel? unit}) =>
    _ringSizesFr(unit: unit);

List<ListValueModel> _ringSizesIt({UnitModel? unit}) =>
    _wrapList(ObjectUtils.fromNumList([
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
    ]));

List<ListValueModel> _ringSizesJp({UnitModel? unit}) => _wrapList([
      ...ObjectUtils.fromNumList([4, 5, 7, 8, 9, 10, 11]),
      ...ObjectUtils.generateNumList(13, 20),
      ...ObjectUtils.generateNumList(22, 23),
      ...ObjectUtils.fromNumList([24, 25, 26, 27]),
    ]);

List<ListValueModel> _barbellBarWeights({UnitModel? unit}) => _wrapList([
      ...ObjectUtils.generateNumList(10, 20,
          step: 10, fractionDigits: 0, divisor: unit?.coefficient),
    ]);
