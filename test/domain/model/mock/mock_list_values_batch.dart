import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_items_fetch_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/list_values_utils.dart';

import 'mock_unit.dart';

final OutputListValuesBatch japanClothesSizes = OutputItemsFetchModel(
  items:
      listValuesFuncSets[ConvertouchListType.clothesSizeJp]!.buildListValues(),
  pageNum: 1,
  hasReachedMax: true,
);

final OutputListValuesBatch usaClothesSizes = OutputItemsFetchModel(
  items:
      listValuesFuncSets[ConvertouchListType.clothesSizeUs]!.buildListValues(),
  pageNum: 1,
  hasReachedMax: true,
);

final OutputListValuesBatch italianClothesSizes = OutputItemsFetchModel(
  items:
      listValuesFuncSets[ConvertouchListType.clothesSizeIt]!.buildListValues(),
  pageNum: 1,
  hasReachedMax: true,
);

final OutputListValuesBatch europeanClothesSizes = OutputItemsFetchModel(
  items:
      listValuesFuncSets[ConvertouchListType.clothesSizeEu]!.buildListValues(),
  pageNum: 1,
  hasReachedMax: true,
);

final OutputListValuesBatch spainClothesSizes = OutputItemsFetchModel(
  items:
      listValuesFuncSets[ConvertouchListType.clothesSizeEs]!.buildListValues(),
  pageNum: 1,
  hasReachedMax: true,
);

final OutputListValuesBatch germanyClothesSizes = OutputItemsFetchModel(
  items:
      listValuesFuncSets[ConvertouchListType.clothesSizeDe]!.buildListValues(),
  pageNum: 1,
  hasReachedMax: true,
);

final OutputListValuesBatch personParamListValues = OutputItemsFetchModel(
  items: listValuesFuncSets[ConvertouchListType.person]!.buildListValues(),
  pageNum: 1,
  hasReachedMax: true,
);

const OutputListValuesBatch garmentParamListValues = OutputItemsFetchModel(
  items: [
    ValueModel.rawStr('Shirt'),
    ValueModel.rawStr('Trousers'),
  ],
  pageNum: 1,
  hasReachedMax: true,
);

final OutputListValuesBatch barWeightParamKgListValues = OutputItemsFetchModel(
  items: listValuesFuncSets[ConvertouchListType.barbellBarWeight]!
      .buildListValues(unit: kilogram),
  pageNum: 1,
  hasReachedMax: true,
);

final OutputListValuesBatch barWeightParamPoundListValues =
    OutputItemsFetchModel(
  items: listValuesFuncSets[ConvertouchListType.barbellBarWeight]!
      .buildListValues(unit: pound),
  pageNum: 1,
  hasReachedMax: true,
);

final OutputListValuesBatch womanTrousersHeightRangesFrom0_156To186InCm =
    OutputItemsFetchModel(
  items: [
    ValueModel.range(const NumRange.withRight(0, 156)),
    ValueModel.range(const NumRange.withRight(156, 162)),
    ValueModel.range(const NumRange.withRight(162, 168)),
    ValueModel.range(const NumRange.withRight(168, 174)),
    ValueModel.range(const NumRange.withRight(174, 180)),
    ValueModel.range(const NumRange.withRight(180, 186)),
    ValueModel.range(const NumRange.withoutBoth(186, double.infinity)),
  ],
  pageNum: 1,
  hasReachedMax: true,
);

const OutputListValuesBatch womanTrousersHeightRangesFrom0_156To186InMeter =
    OutputItemsFetchModel(
  items: [
    ValueModel(
        raw: '.. - 156', alt: '.. - 1.56', range: NumRange.withRight(0, 156)),
    ValueModel(
        raw: '156 - 162',
        alt: '1.56 - 1.62',
        range: NumRange.withRight(156, 162)),
    ValueModel(
        raw: '162 - 168',
        alt: '1.62 - 1.68',
        range: NumRange.withRight(162, 168)),
    ValueModel(
        raw: '168 - 174',
        alt: '1.68 - 1.74',
        range: NumRange.withRight(168, 174)),
    ValueModel(
        raw: '174 - 180',
        alt: '1.74 - 1.8',
        range: NumRange.withRight(174, 180)),
    ValueModel(
        raw: '180 - 186',
        alt: '1.8 - 1.86',
        range: NumRange.withRight(180, 186)),
    ValueModel(
        raw: '186 - ..',
        alt: '1.86 - ..',
        range: NumRange.withoutBoth(186, double.infinity)),
  ],
  pageNum: 1,
  hasReachedMax: true,
);

const OutputListValuesBatch manShirtHeightRangesFrom0_164To190InCm =
    OutputItemsFetchModel(
  items: [
    ValueModel(
        raw: '.. - 164', alt: '.. - 164', range: NumRange.withRight(0, 164)),
    ValueModel(
        raw: '164 - 170',
        alt: '164 - 170',
        range: NumRange.withRight(164, 170)),
    ValueModel(
        raw: '170 - 176',
        alt: '170 - 176',
        range: NumRange.withRight(170, 176)),
    ValueModel(
        raw: '174 - 180',
        alt: '174 - 180',
        range: NumRange.withRight(174, 180)),
    ValueModel(
        raw: '178 - 184',
        alt: '178 - 184',
        range: NumRange.withRight(178, 184)),
    ValueModel(
        raw: '182 - 188',
        alt: '182 - 188',
        range: NumRange.withRight(182, 188)),
    ValueModel(
        raw: '186 - 192',
        alt: '186 - 192',
        range: NumRange.withRight(186, 192)),
    ValueModel(
        raw: '190 - ..',
        alt: '190 - ..',
        range: NumRange.withoutBoth(190, double.infinity)),
  ],
  pageNum: 1,
  hasReachedMax: true,
);

const OutputListValuesBatch manShirtHeightRangesFrom0_164To190InMeter =
    OutputItemsFetchModel(
  items: [
    ValueModel(
        raw: '.. - 164', alt: '.. - 1.64', range: NumRange.withRight(0, 164)),
    ValueModel(
        raw: '164 - 170',
        alt: '1.64 - 1.7',
        range: NumRange.withRight(164, 170)),
    ValueModel(
        raw: '170 - 176',
        alt: '1.7 - 1.76',
        range: NumRange.withRight(170, 176)),
    ValueModel(
        raw: '174 - 180',
        alt: '1.74 - 1.8',
        range: NumRange.withRight(174, 180)),
    ValueModel(
        raw: '178 - 184',
        alt: '1.78 - 1.84',
        range: NumRange.withRight(178, 184)),
    ValueModel(
        raw: '182 - 188',
        alt: '1.82 - 1.88',
        range: NumRange.withRight(182, 188)),
    ValueModel(
        raw: '186 - 192',
        alt: '1.86 - 1.92',
        range: NumRange.withRight(186, 192)),
    ValueModel(
        raw: '190 - ..',
        alt: '1.9 - ..',
        range: NumRange.withoutBoth(190, double.infinity)),
  ],
  pageNum: 1,
  hasReachedMax: true,
);

const OutputListValuesBatch manTrousersHeightRangesFrom0_164To188InCm =
    OutputItemsFetchModel(
  items: [
    ValueModel(
        raw: '.. - 164', alt: '.. - 164', range: NumRange.withRight(0, 164)),
    ValueModel(
        raw: '164 - 170',
        alt: '164 - 170',
        range: NumRange.withRight(164, 170)),
    ValueModel(
        raw: '170 - 176',
        alt: '170 - 176',
        range: NumRange.withRight(170, 176)),
    ValueModel(
        raw: '176 - 182',
        alt: '176 - 182',
        range: NumRange.withRight(176, 182)),
    ValueModel(
        raw: '180 - 186',
        alt: '180 - 186',
        range: NumRange.withRight(180, 186)),
    ValueModel(
        raw: '184 - 190',
        alt: '184 - 190',
        range: NumRange.withRight(184, 190)),
    ValueModel(
        raw: '188 - ..',
        alt: '188 - ..',
        range: NumRange.withoutBoth(188, double.infinity)),
  ],
  pageNum: 1,
  hasReachedMax: true,
);

const OutputListValuesBatch manTrousersHeightRangesFrom0_164To188InMeter =
    OutputItemsFetchModel(
  items: [
    ValueModel(
        raw: '.. - 164', alt: '.. - 1.64', range: NumRange.withRight(0, 164)),
    ValueModel(
        raw: '164 - 170',
        alt: '1.64 - 1.7',
        range: NumRange.withRight(164, 170)),
    ValueModel(
        raw: '170 - 176',
        alt: '1.7 - 1.76',
        range: NumRange.withRight(170, 176)),
    ValueModel(
        raw: '176 - 182',
        alt: '1.76 - 1.82',
        range: NumRange.withRight(176, 182)),
    ValueModel(
        raw: '180 - 186',
        alt: '1.8 - 1.86',
        range: NumRange.withRight(180, 186)),
    ValueModel(
        raw: '184 - 190',
        alt: '1.84 - 1.9',
        range: NumRange.withRight(184, 190)),
    ValueModel(
        raw: '188 - ..',
        alt: '1.88 - ..',
        range: NumRange.withoutBoth(188, double.infinity)),
  ],
  pageNum: 1,
  hasReachedMax: true,
);

final OutputListValuesBatch esRingSizes = OutputItemsFetchModel(
  items: listValuesFuncSets[ConvertouchListType.ringSizeEs]!.buildListValues(),
  pageNum: 1,
  hasReachedMax: true,
);

final OutputListValuesBatch usaRingSizes = OutputItemsFetchModel(
  items: listValuesFuncSets[ConvertouchListType.ringSizeUs]!.buildListValues(),
  pageNum: 1,
  hasReachedMax: true,
);

final OutputListValuesBatch frRingSizes = OutputItemsFetchModel(
  items: listValuesFuncSets[ConvertouchListType.ringSizeFr]!.buildListValues(),
  pageNum: 1,
  hasReachedMax: true,
);

final OutputListValuesBatch ringDiameterRangesInMm = OutputItemsFetchModel(
  items: listValuesFuncSets[ConvertouchListType.ringDiameterRange]!
      .buildListValues(unit: millimeter),
  pageNum: 1,
  hasReachedMax: true,
);

final OutputListValuesBatch ringDiameterRangesInCm = OutputItemsFetchModel(
  items: listValuesFuncSets[ConvertouchListType.ringDiameterRange]!
      .buildListValues(unit: centimeter),
  pageNum: 1,
  hasReachedMax: true,
);

final OutputListValuesBatch ringCircumferenceRangesInMm = OutputItemsFetchModel(
  items: listValuesFuncSets[ConvertouchListType.ringCircumferenceRange]!
      .buildListValues(unit: millimeter),
  pageNum: 1,
  hasReachedMax: true,
);

const OutputListValuesBatch exchangeRateSources = OutputListValuesBatch(
  items: [
    ValueModel.rawStr('FloatRates'),
  ],
  hasReachedMax: true,
  pageNum: 1,
);
