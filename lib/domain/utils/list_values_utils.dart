import 'dart:math';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/conversion_rules/clothes_size.dart';
import 'package:convertouch/domain/utils/conversion_rules/ring_size.dart';
import 'package:convertouch/domain/utils/double_value_utils.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

typedef ListBuilderFunc<T> = List<T> Function({
  ConversionParamSetValueModel? params,
});

typedef ValueModelBuilderFunc = ListBuilderFunc<ValueModel>;
typedef InternalValueFunc = String Function(dynamic raw);
typedef RawValueMapFunc = dynamic Function(ValueModel v);
typedef SearchFunc = bool Function(String, ValueModel?);

typedef PublicValueFunc = String Function(
  dynamic raw, {
  UnitModel? unit,
  ConversionParamSetValueModel? params,
});

InternalValueFunc defaultInternalValueFunc = (r) => r.toString();
PublicValueFunc defaultPublicValueFunc = (r, {unit, params}) => r.toString();
RawValueMapFunc defaultRawValueMapFunc = (v) => v.raw;

SearchFunc defaultSearchFunc = (searchString, v) =>
    v?.itemName.toLowerCase().contains(searchString.toLowerCase()) ?? false;

SearchFunc rangesSearchFunc = (searchString, v) {
  if (searchString.isEmpty) {
    return true;
  }
  double? inputValue = double.tryParse(searchString);
  return v?.range?.includesNum(inputValue) ?? false;
};

class ListValueFuncSet {
  final ListBuilderFunc rawListBuilderFunc;
  final InternalValueFunc internalListValueBuilderFunc;
  final PublicValueFunc publicListValueBuilderFunc;
  final RawValueMapFunc listValueToRawMapFunc;
  final SearchFunc searchFunc;

  const ListValueFuncSet._({
    required this.rawListBuilderFunc,
    required this.internalListValueBuilderFunc,
    required this.publicListValueBuilderFunc,
    required this.listValueToRawMapFunc,
    required this.searchFunc,
  });

  factory ListValueFuncSet({
    required ListBuilderFunc rawListBuilderFunc,
    InternalValueFunc? internalListValueBuilderFunc,
    PublicValueFunc? publicListValueBuilderFunc,
    RawValueMapFunc? listValueToRawMapFunc,
    SearchFunc? searchFunc,
  }) {
    return ListValueFuncSet._(
      rawListBuilderFunc: rawListBuilderFunc,
      internalListValueBuilderFunc:
          internalListValueBuilderFunc ?? defaultInternalValueFunc,
      publicListValueBuilderFunc:
          publicListValueBuilderFunc ?? defaultPublicValueFunc,
      listValueToRawMapFunc: listValueToRawMapFunc ?? defaultRawValueMapFunc,
      searchFunc: searchFunc ?? defaultSearchFunc,
    );
  }

  List<ValueModel> buildListValues({
    UnitModel? unit,
    ConversionParamSetValueModel? params,
  }) {
    List srcList = rawListBuilderFunc.call(params: params);

    return srcList.map((v) {
      String value = internalListValueBuilderFunc.call(v);
      String? publicValue =
          publicListValueBuilderFunc.call(v, unit: unit, params: params);

      return ValueModel(
        raw: value,
        alt: publicValue,
        numVal: double.tryParse(value),
        range: v is NumRange ? v : null,
      );
    }).toList();
  }

  ValueModel recalculatePublicValueForUnit(
    ValueModel src, {
    UnitModel? unit,
    ConversionParamSetValueModel? params,
  }) {
    dynamic rawValue = listValueToRawMapFunc.call(src);
    dynamic publicListValue = publicListValueBuilderFunc.call(
      rawValue,
      unit: unit,
      params: params,
    );

    return ValueModel(
      raw: src.raw,
      alt: publicListValue,
      numVal: src.numVal,
      range: src.range,
    );
  }
}

final Map<ConvertouchListType, ListValueFuncSet> listValuesFuncSets = {
  ConvertouchListType.person: ListValueFuncSet(
    rawListBuilderFunc: ({params}) => Person.values,
    internalListValueBuilderFunc: (r) => (r as Person).name,
    publicListValueBuilderFunc: (r, {unit, params}) => (r as Person).name,
  ),
  ConvertouchListType.garment: ListValueFuncSet(
    rawListBuilderFunc: getGarments,
    internalListValueBuilderFunc: (r) => (r as Garment).name,
    publicListValueBuilderFunc: (r, {unit, params}) => (r as Garment).name,
  ),
  ConvertouchListType.clothesHeightRange: ListValueFuncSet(
    rawListBuilderFunc: getHeightRangesCm,
    internalListValueBuilderFunc: (r) => (r as NumRange).rangeName,
    publicListValueBuilderFunc: (r, {unit, params}) =>
        (r as NumRange).copyWithFactor(0.01 / unit!.coefficient!).rangeName,
    listValueToRawMapFunc: (v) => v.range,
    searchFunc: rangesSearchFunc,
  ),
  ConvertouchListType.ringDiameterRange: ListValueFuncSet(
    rawListBuilderFunc: getRingDiameterRangesMm,
    internalListValueBuilderFunc: (r) => (r as NumRange).rangeName,
    publicListValueBuilderFunc: (r, {unit, params}) =>
        (r as NumRange).copyWithFactor(0.001 / unit!.coefficient!).rangeName,
    listValueToRawMapFunc: (v) => v.range,
    searchFunc: rangesSearchFunc,
  ),
  ConvertouchListType.ringCircumferenceRange: ListValueFuncSet(
    rawListBuilderFunc: getRingDiameterRangesMm,
    internalListValueBuilderFunc: (r) => (r as NumRange).rangeName,
    publicListValueBuilderFunc: (r, {unit, params}) => (r as NumRange)
        .copyWithFactor(pi * 0.001 / unit!.coefficient!)
        .rangeName,
    listValueToRawMapFunc: (v) => v.range,
    searchFunc: rangesSearchFunc,
  ),
  ConvertouchListType.barbellBarWeight: ListValueFuncSet(
    rawListBuilderFunc: ({params}) => [
      10,
      20,
    ],
    publicListValueBuilderFunc: (r, {unit, params}) =>
        DoubleValueUtils.numToStr(
      unit != null ? r / unit.coefficient! : r,
      fractionDigits: 0,
    ),
    listValueToRawMapFunc: (v) => v.numVal!.toInt(),
    searchFunc: (searchString, v) {
      if (v == null) {
        return false;
      }

      if (searchString.isEmpty) {
        return true;
      }

      double? inputValue = double.tryParse(searchString);
      double numListValue = double.parse(v.itemName);
      return numListValue == inputValue;
    },
  ),
  ConvertouchListType.clothesSizeInter: ListValueFuncSet(
    rawListBuilderFunc: ({params}) => [
      "XXS",
      "XS",
      "S",
      "M",
      "L",
      "XL",
      "XXL",
      "3XL",
    ],
  ),
  ConvertouchListType.clothesSizeUs: ListValueFuncSet(
    rawListBuilderFunc: ({params}) => [
      ...ObjectUtils.generateNumStrList(2, 14, step: 2),
      ...ObjectUtils.generateNumStrList(28, 42, step: 2),
    ],
  ),
  ConvertouchListType.clothesSizeJp: ListValueFuncSet(
    rawListBuilderFunc: ({params}) => [
      'S',
      'M',
      'L',
      'LL',
      '3L',
      '4L',
      '5L',
      '6L',
    ],
  ),
  ConvertouchListType.clothesSizeFr: ListValueFuncSet(
    rawListBuilderFunc: ({params}) => [
      ...ObjectUtils.generateNumStrList(34, 48, step: 2),
    ],
  ),
  ConvertouchListType.clothesSizeEu: ListValueFuncSet(
    rawListBuilderFunc: ({params}) => [
      ...ObjectUtils.generateNumStrList(34, 56, step: 2),
    ],
  ),
  ConvertouchListType.clothesSizeRu: ListValueFuncSet(
    rawListBuilderFunc: ({params}) => [
      ...ObjectUtils.generateNumStrList(40, 56, step: 2),
    ],
  ),
  ConvertouchListType.clothesSizeIt: ListValueFuncSet(
    rawListBuilderFunc: ({params}) => [
      ...ObjectUtils.generateNumStrList(38, 56, step: 2),
    ],
  ),
  ConvertouchListType.clothesSizeUk: ListValueFuncSet(
    rawListBuilderFunc: ({params}) => [
      ...ObjectUtils.generateNumStrList(6, 18, step: 2),
      ...ObjectUtils.generateNumStrList(26, 40, step: 2),
    ],
  ),
  ConvertouchListType.clothesSizeDe: ListValueFuncSet(
    rawListBuilderFunc: ({params}) => [
      ...ObjectUtils.generateNumStrList(32, 56, step: 2),
    ],
  ),
  ConvertouchListType.clothesSizeEs: ListValueFuncSet(
    rawListBuilderFunc: ({params}) => [
      ...ObjectUtils.generateNumStrList(34, 48, step: 2),
    ],
  ),
  ConvertouchListType.ringSizeUs: ListValueFuncSet(
    rawListBuilderFunc: ({params}) => [
      ...ObjectUtils.generateNumStrList(3, 15, step: 0.5, fractionDigits: 1),
    ],
  ),
  ConvertouchListType.ringSizeUk: ListValueFuncSet(
    rawListBuilderFunc: ({params}) => [
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
    ],
  ),
  ConvertouchListType.ringSizeDe: ListValueFuncSet(
    rawListBuilderFunc: ({params}) => [
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
    ],
  ),
  ConvertouchListType.ringSizeEs: ListValueFuncSet(
    rawListBuilderFunc: ({params}) => ObjectUtils.fromNumList([
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
    ]),
  ),
  ConvertouchListType.ringSizeFr: ListValueFuncSet(
    rawListBuilderFunc: ({params}) => ObjectUtils.fromNumList([
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
    ]),
  ),
  ConvertouchListType.ringSizeRu: ListValueFuncSet(
    rawListBuilderFunc: ({params}) => ObjectUtils.fromNumList([
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
    ]),
  ),
  ConvertouchListType.ringSizeIt: ListValueFuncSet(
    rawListBuilderFunc: ({params}) => ObjectUtils.fromNumList([
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
    ]),
  ),
  ConvertouchListType.ringSizeJp: ListValueFuncSet(
    rawListBuilderFunc: ({params}) => [
      ...ObjectUtils.fromNumList([4, 5, 7, 8, 9, 10, 11]),
      ...ObjectUtils.generateNumStrList(13, 20),
      ...ObjectUtils.generateNumStrList(22, 23),
      ...ObjectUtils.fromNumList([24, 25, 26, 27]),
    ],
  ),
};
