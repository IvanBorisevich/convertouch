import 'dart:math';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/list_value_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/list_value_repository.dart';
import 'package:convertouch/domain/repositories/network_repository.dart';
import 'package:convertouch/domain/utils/conversion_rules/clothes_size.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class ListValueRepositoryImpl implements ListValueRepository {
  final NetworkRepository networkRepository;

  const ListValueRepositoryImpl({
    required this.networkRepository,
  });

  @override
  Future<Either<ConvertouchException, List<ListValueModel>>> fetch({
    required ConvertouchListType listType,
    String? searchString,
    required int pageNum,
    required int pageSize,
    UnitModel? unit,
    ConversionParamSetValueModel? params,
  }) async {
    if (listType.fetchedViaApi && params != null) {
      return await _fetchFromNetwork(
        listType: listType,
        pageNum: pageNum,
        pageSize: pageSize,
        params: params,
      );
    }

    return Right(
      _fetchLocal(
        listType: listType,
        pageNum: pageNum,
        pageSize: pageSize,
        unit: unit,
        params: params,
      ),
    );
  }

  @override
  Future<Either<ConvertouchException, bool>> belongsToList({
    required ValueModel? value,
    required ConvertouchListType listType,
    UnitModel? unit,
    ConversionParamSetValueModel? params,
  }) async {
    if (value == null) {
      return const Right(true);
    }

    bool belongs;

    if (listType.fetchedViaApi) {
      belongs = false;
    } else {
      belongs = _listValues[listType]
              ?.call(unit: unit, params: params)
              .any((v) => v.value == value.raw) ??
          false;
    }

    return Right(belongs);
  }

  List<ListValueModel> _fetchLocal({
    required ConvertouchListType listType,
    required int pageNum,
    required int pageSize,
    UnitModel? unit,
    ConversionParamSetValueModel? params,
  }) {
    List<ListValueModel>? fullList = _listValues[listType]?.call(
      unit: unit,
      params: params,
    );

    if (fullList == null) {
      return const [];
    }

    int end = min((pageNum + 1) * pageSize, fullList.length);
    return fullList.sublist(pageNum * pageSize, end);
  }

  Future<Either<ConvertouchException, List<ListValueModel>>> _fetchFromNetwork({
    required ConvertouchListType listType,
    required int pageNum,
    required int pageSize,
    required ConversionParamSetValueModel params,
  }) async {
    return await networkRepository.fetchList(
      listType: listType,
      params: params,
      pageSize: pageSize,
      pageNum: pageNum,
    );
  }
}

typedef ListBuilderFunc<T> = List<T> Function({
  UnitModel? unit,
  ConversionParamSetValueModel? params,
});

typedef ListValueModelBuilderFunc = ListBuilderFunc<ListValueModel>;

const Map<ConvertouchListType, ListValueModelBuilderFunc> _listValues = {
  ConvertouchListType.person: _persons,
  ConvertouchListType.garment: _garments,
  ConvertouchListType.clothesHeightRange: _clothesHeightRanges,
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
  List<T>? src, {
  String Function(T)? valueMap,
  String Function(T)? altValueMap,
}) {
  return src != null
      ? src.map((v) {
          String value = (valueMap ?? _defaultMap).call(v);
          String? alt = altValueMap?.call(v) ?? value;

          return ListValueModel(
            value: value,
            alt: alt,
            range: v is NumRange ? v : null,
          );
        }).toList()
      : [];
}

List<ListValueModel> _persons({
  UnitModel? unit,
  ConversionParamSetValueModel? params,
}) =>
    _wrapList(
      Person.values,
      valueMap: (v) => v.name,
    );

List<ListValueModel> _garments({
  UnitModel? unit,
  ConversionParamSetValueModel? params,
}) =>
    _wrapList(
      getGarments(unit: unit, params: params),
      valueMap: (v) => v.name,
    );

List<ListValueModel> _clothesHeightRanges({
  UnitModel? unit,
  ConversionParamSetValueModel? params,
}) =>
    _wrapList(
      getHeightRangesCm(params: params),
      valueMap: (v) => v.rangeName,
      altValueMap: (v) => v.copyWithFactor(0.01 * unit!.coefficient!).rangeName,
    );

List<ListValueModel> _clothesSizesInter({
  UnitModel? unit,
  ConversionParamSetValueModel? params,
}) =>
    _wrapList([
      "XXS",
      "XS",
      "S",
      "M",
      "L",
      "XL",
      "XXL",
      "3XL",
    ]);

List<ListValueModel> _clothesSizesUs({
  UnitModel? unit,
  ConversionParamSetValueModel? params,
}) =>
    _wrapList([
      ...ObjectUtils.generateNumList(2, 14, step: 2),
      ...ObjectUtils.generateNumList(28, 42, step: 2),
    ]);

List<ListValueModel> _clothesSizesJp({
  UnitModel? unit,
  ConversionParamSetValueModel? params,
}) =>
    _wrapList([
      'S',
      'M',
      'L',
      'LL',
      '3L',
      '4L',
      '5L',
      '6L',
    ]);

List<ListValueModel> _clothesSizesFr({
  UnitModel? unit,
  ConversionParamSetValueModel? params,
}) =>
    _wrapList([
      ...ObjectUtils.generateNumList(34, 48, step: 2),
    ]);

List<ListValueModel> _clothesSizesEu({
  UnitModel? unit,
  ConversionParamSetValueModel? params,
}) =>
    _wrapList([
      ...ObjectUtils.generateNumList(34, 56, step: 2),
    ]);

List<ListValueModel> _clothesSizesRu({
  UnitModel? unit,
  ConversionParamSetValueModel? params,
}) =>
    _wrapList([
      ...ObjectUtils.generateNumList(40, 56, step: 2),
    ]);

List<ListValueModel> _clothesSizesIt({
  UnitModel? unit,
  ConversionParamSetValueModel? params,
}) =>
    _wrapList([
      ...ObjectUtils.generateNumList(38, 56, step: 2),
    ]);

List<ListValueModel> _clothesSizesUk({
  UnitModel? unit,
  ConversionParamSetValueModel? params,
}) =>
    _wrapList([
      ...ObjectUtils.generateNumList(6, 18, step: 2),
      ...ObjectUtils.generateNumList(26, 40, step: 2),
    ]);

List<ListValueModel> _clothesSizesDe({
  UnitModel? unit,
  ConversionParamSetValueModel? params,
}) =>
    _wrapList([
      ...ObjectUtils.generateNumList(32, 56, step: 2),
    ]);

List<ListValueModel> _clothesSizesEs({
  UnitModel? unit,
  ConversionParamSetValueModel? params,
}) =>
    _wrapList([
      ...ObjectUtils.generateNumList(34, 48, step: 2),
    ]);

List<ListValueModel> _ringSizesFr({
  UnitModel? unit,
  ConversionParamSetValueModel? params,
}) =>
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

List<ListValueModel> _ringSizesRu({
  UnitModel? unit,
  ConversionParamSetValueModel? params,
}) =>
    _ringSizesFr();

List<ListValueModel> _ringSizesUs({
  UnitModel? unit,
  ConversionParamSetValueModel? params,
}) =>
    _wrapList([
      ...ObjectUtils.generateNumList(3, 15, step: 0.5, fractionDigits: 1),
    ]);

List<ListValueModel> _ringSizesIt({
  UnitModel? unit,
  ConversionParamSetValueModel? params,
}) =>
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

List<ListValueModel> _barbellBarWeights({
  UnitModel? unit,
  ConversionParamSetValueModel? params,
}) =>
    _wrapList([
      ...ObjectUtils.generateNumList(10, 20,
          step: 10, fractionDigits: 0, divisor: unit?.coefficient),
    ]);

List<ListValueModel> _ringSizesUk({
  UnitModel? unit,
  ConversionParamSetValueModel? params,
}) =>
    _wrapList([
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

List<ListValueModel> _ringSizesDe({
  UnitModel? unit,
  ConversionParamSetValueModel? params,
}) =>
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

List<ListValueModel> _ringSizesEs({
  UnitModel? unit,
  ConversionParamSetValueModel? params,
}) =>
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

List<ListValueModel> _ringSizesJp({
  UnitModel? unit,
  ConversionParamSetValueModel? params,
}) =>
    _wrapList([
      ...ObjectUtils.fromNumList([4, 5, 7, 8, 9, 10, 11]),
      ...ObjectUtils.generateNumList(13, 20),
      ...ObjectUtils.generateNumList(22, 23),
      ...ObjectUtils.fromNumList([24, 25, 26, 27]),
    ]);
