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
typedef PublicValueToInternalValueFunc<T> = T Function(T, {UnitModel? unit});
typedef RawValueMapFunc = dynamic Function(ValueModel v);
typedef SearchStringPredicate = bool Function(String, ValueModel?);
typedef PublicValuePredicate = bool Function({
  required ValueModel input,
  required ValueModel v,
  required UnitModel? unit,
});

typedef PublicValueFunc = String Function(
  dynamic raw, {
  UnitModel? unit,
  ConversionParamSetValueModel? params,
});

InternalValueFunc defaultInternalValueFunc = (r) => r.toString();
PublicValueFunc defaultPublicValueFunc = (r, {unit, params}) => r.toString();
RawValueMapFunc defaultRawValueMapFunc = (v) => v.raw;

SearchStringPredicate defaultSearchStringPredicate = (searchString, v) =>
    v?.itemName.toLowerCase().contains(searchString.toLowerCase()) ?? false;

PublicValuePredicate defaultPublicValuePredicate = ({
  required input,
  required v,
  unit,
}) =>
    v.raw == input.raw;

SearchStringPredicate searchStringPredicateForRange = (searchString, v) {
  if (searchString.isEmpty) {
    return true;
  }

  double? inputValue = double.tryParse(searchString);
  return v?.range?.includesNum(inputValue) ?? false;
};

PublicValuePredicate _publicValuePredicateForRange({
  PublicValueToInternalValueFunc<double>? inputToInternalValue,
}) {
  return ({
    required input,
    required v,
    unit,
  }) {
    if (input.range != null) {
      return input.range == v.range;
    }

    if (input.raw.isEmpty) {
      return false;
    }

    double? publicInputValue = double.tryParse(input.raw);

    if (publicInputValue == null) {
      return false;
    }

    double? internalInputValue = inputToInternalValue != null
        ? inputToInternalValue.call(publicInputValue, unit: unit)
        : publicInputValue;

    return v.range?.includesNum(internalInputValue) ?? false;
  };
}

class ListValueFuncSet {
  final ListBuilderFunc rawListBuilder;
  final InternalValueFunc internalListValueBuilder;
  final PublicValueFunc publicListValueBuilder;
  final RawValueMapFunc listValueToRaw;
  final SearchStringPredicate searchStringPredicate;
  final PublicValuePredicate publicValuePredicate;

  const ListValueFuncSet._({
    required this.rawListBuilder,
    required this.internalListValueBuilder,
    required this.publicListValueBuilder,
    required this.listValueToRaw,
    required this.searchStringPredicate,
    required this.publicValuePredicate,
  });

  factory ListValueFuncSet({
    required ListBuilderFunc rawListBuilder,
    InternalValueFunc? internalListValueBuilder,
    PublicValueFunc? publicListValueBuilder,
    RawValueMapFunc? listValueToRaw,
    SearchStringPredicate? searchStringPredicate,
    PublicValuePredicate? publicValuePredicate,
  }) {
    return ListValueFuncSet._(
      rawListBuilder: rawListBuilder,
      internalListValueBuilder:
          internalListValueBuilder ?? defaultInternalValueFunc,
      publicListValueBuilder: publicListValueBuilder ?? defaultPublicValueFunc,
      listValueToRaw: listValueToRaw ?? defaultRawValueMapFunc,
      searchStringPredicate:
          searchStringPredicate ?? defaultSearchStringPredicate,
      publicValuePredicate: publicValuePredicate ?? defaultPublicValuePredicate,
    );
  }

  List<ValueModel> buildListValues({
    UnitModel? unit,
    ConversionParamSetValueModel? params,
  }) {
    List srcList = rawListBuilder.call(params: params);

    return srcList.map((v) {
      String value = internalListValueBuilder.call(v);
      String? publicValue =
          publicListValueBuilder.call(v, unit: unit, params: params);

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
    dynamic rawValue = listValueToRaw.call(src);
    dynamic publicListValue = publicListValueBuilder.call(
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
    rawListBuilder: ({params}) => Person.values,
    internalListValueBuilder: (r) => (r as Person).name,
    publicListValueBuilder: (r, {unit, params}) => (r as Person).name,
  ),
  ConvertouchListType.garment: ListValueFuncSet(
    rawListBuilder: getGarments,
    internalListValueBuilder: (r) => (r as Garment).name,
    publicListValueBuilder: (r, {unit, params}) => (r as Garment).name,
  ),
  ConvertouchListType.clothesHeightRange: ListValueFuncSet(
    rawListBuilder: getHeightRangesCm,
    internalListValueBuilder: (r) => (r as NumRange).rangeName,
    publicListValueBuilder: (r, {unit, params}) =>
        (r as NumRange).copyWithFactor(0.01 / unit!.coefficient!).rangeName,
    listValueToRaw: (v) => v.range,
    searchStringPredicate: searchStringPredicateForRange,
    publicValuePredicate: _publicValuePredicateForRange(
      inputToInternalValue: (inputPublicNum, {unit}) =>
          inputPublicNum * unit!.coefficient! * 100,
    ),
  ),
  ConvertouchListType.ringDiameterRange: ListValueFuncSet(
    rawListBuilder: getRingDiameterRangesMm,
    internalListValueBuilder: (r) => (r as NumRange).rangeName,
    publicListValueBuilder: (r, {unit, params}) =>
        (r as NumRange).copyWithFactor(0.001 / unit!.coefficient!).rangeName,
    listValueToRaw: (v) => v.range,
    searchStringPredicate: searchStringPredicateForRange,
    publicValuePredicate: _publicValuePredicateForRange(
      inputToInternalValue: (inputPublicNum, {unit}) =>
          inputPublicNum * unit!.coefficient! * 1000,
    ),
  ),
  ConvertouchListType.ringCircumferenceRange: ListValueFuncSet(
    rawListBuilder: getRingDiameterRangesMm,
    internalListValueBuilder: (r) => (r as NumRange).rangeName,
    publicListValueBuilder: (r, {unit, params}) => (r as NumRange)
        .copyWithFactor(pi * 0.001 / unit!.coefficient!)
        .rangeName,
    listValueToRaw: (v) => v.range,
    searchStringPredicate: searchStringPredicateForRange,
    publicValuePredicate: _publicValuePredicateForRange(
      inputToInternalValue: (inputPublicNum, {unit}) =>
          inputPublicNum * unit!.coefficient! * 1000 / pi,
    ),
  ),
  ConvertouchListType.barbellBarWeight: ListValueFuncSet(
    rawListBuilder: ({params}) => [
      10,
      20,
    ],
    publicListValueBuilder: (r, {unit, params}) => DoubleValueUtils.numToStr(
      unit != null ? r / unit.coefficient! : r,
      fractionDigits: 0,
    ),
    listValueToRaw: (v) => v.numVal!.toInt(),
    searchStringPredicate: (searchString, v) {
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
    rawListBuilder: ({params}) => [
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
    rawListBuilder: ({params}) => [
      ...ObjectUtils.generateNumStrList(2, 14, step: 2),
      ...ObjectUtils.generateNumStrList(28, 42, step: 2),
    ],
  ),
  ConvertouchListType.clothesSizeJp: ListValueFuncSet(
    rawListBuilder: ({params}) => [
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
    rawListBuilder: ({params}) => [
      ...ObjectUtils.generateNumStrList(34, 48, step: 2),
    ],
  ),
  ConvertouchListType.clothesSizeEu: ListValueFuncSet(
    rawListBuilder: ({params}) => [
      ...ObjectUtils.generateNumStrList(34, 56, step: 2),
    ],
  ),
  ConvertouchListType.clothesSizeRu: ListValueFuncSet(
    rawListBuilder: ({params}) => [
      ...ObjectUtils.generateNumStrList(40, 56, step: 2),
    ],
  ),
  ConvertouchListType.clothesSizeIt: ListValueFuncSet(
    rawListBuilder: ({params}) => [
      ...ObjectUtils.generateNumStrList(38, 56, step: 2),
    ],
  ),
  ConvertouchListType.clothesSizeUk: ListValueFuncSet(
    rawListBuilder: ({params}) => [
      ...ObjectUtils.generateNumStrList(6, 18, step: 2),
      ...ObjectUtils.generateNumStrList(26, 40, step: 2),
    ],
  ),
  ConvertouchListType.clothesSizeDe: ListValueFuncSet(
    rawListBuilder: ({params}) => [
      ...ObjectUtils.generateNumStrList(32, 56, step: 2),
    ],
  ),
  ConvertouchListType.clothesSizeEs: ListValueFuncSet(
    rawListBuilder: ({params}) => [
      ...ObjectUtils.generateNumStrList(34, 48, step: 2),
    ],
  ),
  ConvertouchListType.ringSizeUs: ListValueFuncSet(
    rawListBuilder: ({params}) => [
      ...ObjectUtils.generateNumStrList(3, 15, step: 0.5, fractionDigits: 1),
    ],
  ),
  ConvertouchListType.ringSizeUk: ListValueFuncSet(
    rawListBuilder: ({params}) => [
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
    rawListBuilder: ({params}) => [
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
    rawListBuilder: ({params}) => ObjectUtils.fromNumList([
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
    rawListBuilder: ({params}) => ObjectUtils.fromNumList([
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
    rawListBuilder: ({params}) => ObjectUtils.fromNumList([
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
    rawListBuilder: ({params}) => ObjectUtils.fromNumList([
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
    rawListBuilder: ({params}) => [
      ...ObjectUtils.fromNumList([4, 5, 7, 8, 9, 10, 11]),
      ...ObjectUtils.generateNumStrList(13, 20),
      ...ObjectUtils.generateNumStrList(22, 23),
      ...ObjectUtils.fromNumList([24, 25, 26, 27]),
    ],
  ),
};
