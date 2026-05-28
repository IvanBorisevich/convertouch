import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/list_value_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/conversion_rules/clothes_size.dart';
import 'package:convertouch/domain/utils/double_value_utils.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

typedef ListBuilderFunc<T> = List<T> Function({
  ConversionParamSetValueModel? params,
});

typedef ListValueModelBuilderFunc = ListBuilderFunc<ListValueModel>;
typedef InternalValueFunc = String Function(dynamic raw);
typedef RawValueMapFunc = dynamic Function(ValueModel v);

typedef PublicValueFunc = String Function(
  dynamic raw, {
  UnitModel? unit,
  ConversionParamSetValueModel? params,
});

InternalValueFunc defaultInternalValueFunc = (r) => r.toString();
PublicValueFunc defaultPublicValueFunc = (r, {unit, params}) => r.toString();
RawValueMapFunc defaultRawValueMapFunc = (v) => v.raw;

class ListValueFuncSet {
  final ListBuilderFunc rawListBuilderFunc;
  final InternalValueFunc internalValueFunc;
  final PublicValueFunc publicValueFunc;
  final RawValueMapFunc rawValueMapFunc;

  const ListValueFuncSet._({
    required this.rawListBuilderFunc,
    required this.internalValueFunc,
    required this.publicValueFunc,
    required this.rawValueMapFunc,
  });

  factory ListValueFuncSet({
    required ListBuilderFunc rawListBuilderFunc,
    InternalValueFunc? internalValueFunc,
    PublicValueFunc? publicValueFunc,
    RawValueMapFunc? rawValueMapFunc,
  }) {
    return ListValueFuncSet._(
      rawListBuilderFunc: rawListBuilderFunc,
      internalValueFunc: internalValueFunc ?? defaultInternalValueFunc,
      publicValueFunc: publicValueFunc ?? defaultPublicValueFunc,
      rawValueMapFunc: rawValueMapFunc ?? defaultRawValueMapFunc,
    );
  }

  List<ListValueModel> buildListValues({
    UnitModel? unit,
    ConversionParamSetValueModel? params,
  }) {
    List srcList = rawListBuilderFunc.call(params: params);

    return srcList.map((v) {
      String value = internalValueFunc.call(v);
      String? publicValue = publicValueFunc.call(v, unit: unit, params: params);

      return ListValueModel(
        value: value,
        publicValue: publicValue,
        range: v is NumRange ? v : null,
      );
    }).toList();
  }
}

final Map<ConvertouchListType, ListValueFuncSet> listValuesFuncSets = {
  ConvertouchListType.person: ListValueFuncSet(
    rawListBuilderFunc: ({params}) => Person.values,
    internalValueFunc: (r) => (r as Person).name,
    publicValueFunc: (r, {unit, params}) => (r as Person).name,
  ),
  ConvertouchListType.garment: ListValueFuncSet(
    rawListBuilderFunc: ({params}) => Garment.values,
    internalValueFunc: (r) => (r as Garment).name,
    publicValueFunc: (r, {unit, params}) => (r as Garment).name,
  ),
  ConvertouchListType.clothesHeightRange: ListValueFuncSet(
    rawListBuilderFunc: getHeightRangesCm,
    internalValueFunc: (r) => (r as NumRange).rangeName,
    publicValueFunc: (r, {unit, params}) =>
        (r as NumRange).copyWithFactor(0.01 / unit!.coefficient!).rangeName,
    rawValueMapFunc: (v) => v.range,
  ),
  ConvertouchListType.barbellBarWeight: ListValueFuncSet(
    rawListBuilderFunc: ({params}) => [
      10,
      20,
    ],
    publicValueFunc: (r, {unit, params}) => DoubleValueUtils.numToStr(
      unit != null ? r / unit.coefficient! : r,
      fractionDigits: 0,
    ),
    rawValueMapFunc: (v) => v.numVal!.toInt(),
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
