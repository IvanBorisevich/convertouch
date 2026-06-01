import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/list_value_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_items_fetch_model.dart';
import 'package:convertouch/domain/utils/list_values_utils.dart';

import 'mock_unit.dart';

const OutputListValuesBatch japanClothesSizes = OutputItemsFetchModel(
  items: [
    ListValueModel.str('S'),
    ListValueModel.str('M'),
    ListValueModel.str('L'),
    ListValueModel.str('LL'),
    ListValueModel.str('3L'),
    ListValueModel.str('4L'),
    ListValueModel.str('5L'),
    ListValueModel.str('6L'),
  ],
  pageNum: 1,
  hasReachedMax: true,
);

const OutputListValuesBatch usaClothesSizes = OutputItemsFetchModel(
  items: [
    ListValueModel.str('2'),
    ListValueModel.str('4'),
    ListValueModel.str('6'),
    ListValueModel.str('8'),
    ListValueModel.str('10'),
    ListValueModel.str('12'),
    ListValueModel.str('14'),
    ListValueModel.str('28'),
    ListValueModel.str('30'),
    ListValueModel.str('32'),
    ListValueModel.str('34'),
    ListValueModel.str('36'),
    ListValueModel.str('38'),
    ListValueModel.str('40'),
    ListValueModel.str('42'),
  ],
  pageNum: 1,
  hasReachedMax: true,
);

const OutputListValuesBatch italianClothesSizes = OutputItemsFetchModel(
  items: [
    ListValueModel.str('38'),
    ListValueModel.str('40'),
    ListValueModel.str('42'),
    ListValueModel.str('44'),
    ListValueModel.str('46'),
    ListValueModel.str('48'),
    ListValueModel.str('50'),
    ListValueModel.str('52'),
    ListValueModel.str('54'),
    ListValueModel.str('56'),
  ],
  pageNum: 1,
  hasReachedMax: true,
);

const OutputListValuesBatch europeanClothesSizes = OutputItemsFetchModel(
  items: [
    ListValueModel.str('34'),
    ListValueModel.str('36'),
    ListValueModel.str('38'),
    ListValueModel.str('40'),
    ListValueModel.str('42'),
    ListValueModel.str('44'),
    ListValueModel.str('46'),
    ListValueModel.str('48'),
    ListValueModel.str('50'),
    ListValueModel.str('52'),
    ListValueModel.str('54'),
    ListValueModel.str('56'),
  ],
  pageNum: 1,
  hasReachedMax: true,
);

const OutputListValuesBatch spainClothesSizes = OutputItemsFetchModel(
  items: [
    ListValueModel.str('34'),
    ListValueModel.str('36'),
    ListValueModel.str('38'),
    ListValueModel.str('40'),
    ListValueModel.str('42'),
    ListValueModel.str('44'),
    ListValueModel.str('46'),
    ListValueModel.str('48'),
  ],
  pageNum: 1,
  hasReachedMax: true,
);

const OutputListValuesBatch germanyClothesSizes = OutputItemsFetchModel(
  items: [
    ListValueModel.str('32'),
    ListValueModel.str('34'),
    ListValueModel.str('36'),
    ListValueModel.str('38'),
    ListValueModel.str('40'),
    ListValueModel.str('42'),
    ListValueModel.str('44'),
    ListValueModel.str('46'),
    ListValueModel.str('48'),
    ListValueModel.str('50'),
    ListValueModel.str('52'),
    ListValueModel.str('54'),
    ListValueModel.str('56'),
  ],
  pageNum: 1,
  hasReachedMax: true,
);

const OutputListValuesBatch personParamListValues = OutputItemsFetchModel(
  items: [
    ListValueModel.str('Man'),
    ListValueModel.str('Woman'),
  ],
  pageNum: 1,
  hasReachedMax: true,
);

const OutputListValuesBatch garmentParamListValues = OutputItemsFetchModel(
  items: [
    ListValueModel.str('Shirt'),
    ListValueModel.str('Trousers'),
  ],
  pageNum: 1,
  hasReachedMax: true,
);

const OutputListValuesBatch barWeightParamKgListValues = OutputItemsFetchModel(
  items: [
    ListValueModel.str('10'),
    ListValueModel.str('20'),
  ],
  pageNum: 1,
  hasReachedMax: true,
);

const OutputListValuesBatch barWeightParamPoundListValues =
    OutputItemsFetchModel(
  items: [
    ListValueModel(
      value: '10',
      publicValue: '22',
    ),
    ListValueModel(
      value: '20',
      publicValue: '44',
    ),
  ],
  pageNum: 1,
  hasReachedMax: true,
);

final OutputListValuesBatch womanTrousersHeightRangesFrom0_156To186InCm =
    OutputItemsFetchModel(items: [
  ListValueModel.range(const NumRange.withRight(0, 156)),
  ListValueModel.range(const NumRange.withRight(156, 162)),
  ListValueModel.range(const NumRange.withRight(162, 168)),
  ListValueModel.range(const NumRange.withRight(168, 174)),
  ListValueModel.range(const NumRange.withRight(174, 180)),
  ListValueModel.range(const NumRange.withRight(180, 186)),
  ListValueModel.range(const NumRange.withoutBoth(186, double.infinity)),
], pageNum: 1, hasReachedMax: true);

const OutputListValuesBatch womanTrousersHeightRangesFrom0_156To186InMeter =
    OutputItemsFetchModel(items: [
  ListValueModel(
      value: '.. - 156',
      publicValue: '.. - 1.56',
      range: NumRange.withRight(0, 156)),
  ListValueModel(
      value: '156 - 162',
      publicValue: '1.56 - 1.62',
      range: NumRange.withRight(156, 162)),
  ListValueModel(
      value: '162 - 168',
      publicValue: '1.62 - 1.68',
      range: NumRange.withRight(162, 168)),
  ListValueModel(
      value: '168 - 174',
      publicValue: '1.68 - 1.74',
      range: NumRange.withRight(168, 174)),
  ListValueModel(
      value: '174 - 180',
      publicValue: '1.74 - 1.8',
      range: NumRange.withRight(174, 180)),
  ListValueModel(
      value: '180 - 186',
      publicValue: '1.8 - 1.86',
      range: NumRange.withRight(180, 186)),
  ListValueModel(
      value: '186 - ..',
      publicValue: '1.86 - ..',
      range: NumRange.withRight(186, double.infinity)),
], pageNum: 1, hasReachedMax: true);

const OutputListValuesBatch manShirtHeightRangesFrom0_164To190InCm =
    OutputItemsFetchModel(items: [
  ListValueModel(
      value: '.. - 164',
      publicValue: '.. - 164',
      range: NumRange.withRight(0, 164)),
  ListValueModel(
      value: '164 - 170',
      publicValue: '164 - 170',
      range: NumRange.withRight(164, 170)),
  ListValueModel(
      value: '170 - 176',
      publicValue: '170 - 176',
      range: NumRange.withRight(170, 176)),
  ListValueModel(
      value: '174 - 180',
      publicValue: '174 - 180',
      range: NumRange.withRight(174, 180)),
  ListValueModel(
      value: '178 - 184',
      publicValue: '178 - 184',
      range: NumRange.withRight(178, 184)),
  ListValueModel(
      value: '182 - 188',
      publicValue: '182 - 188',
      range: NumRange.withRight(182, 188)),
  ListValueModel(
      value: '186 - 192',
      publicValue: '186 - 192',
      range: NumRange.withRight(186, 192)),
  ListValueModel(
      value: '190 - ..',
      publicValue: '190 - ..',
      range: NumRange.withoutBoth(190, double.infinity)),
], pageNum: 1, hasReachedMax: true);

const OutputListValuesBatch manShirtHeightRangesFrom0_164To190InMeter =
    OutputItemsFetchModel(items: [
  ListValueModel(
      value: '.. - 164',
      publicValue: '.. - 1.64',
      range: NumRange.withRight(0, 164)),
  ListValueModel(
      value: '164 - 170',
      publicValue: '1.64 - 1.7',
      range: NumRange.withRight(164, 170)),
  ListValueModel(
      value: '170 - 176',
      publicValue: '1.7 - 1.76',
      range: NumRange.withRight(170, 176)),
  ListValueModel(
      value: '174 - 180',
      publicValue: '1.74 - 1.8',
      range: NumRange.withRight(174, 180)),
  ListValueModel(
      value: '178 - 184',
      publicValue: '1.78 - 1.84',
      range: NumRange.withRight(178, 184)),
  ListValueModel(
      value: '182 - 188',
      publicValue: '1.82 - 1.88',
      range: NumRange.withRight(182, 188)),
  ListValueModel(
      value: '186 - 192',
      publicValue: '1.86 - 1.92',
      range: NumRange.withRight(186, 192)),
  ListValueModel(
      value: '190 - ..',
      publicValue: '1.9 - ..',
      range: NumRange.withoutBoth(190, double.infinity)),
], pageNum: 1, hasReachedMax: true);

const OutputListValuesBatch manTrousersHeightRangesFrom0_164To188InCm =
    OutputItemsFetchModel(items: [
  ListValueModel(
      value: '.. - 164',
      publicValue: '.. - 164',
      range: NumRange.withRight(0, 164)),
  ListValueModel(
      value: '164 - 170',
      publicValue: '164 - 170',
      range: NumRange.withRight(164, 170)),
  ListValueModel(
      value: '170 - 176',
      publicValue: '170 - 176',
      range: NumRange.withRight(170, 176)),
  ListValueModel(
      value: '176 - 182',
      publicValue: '176 - 182',
      range: NumRange.withRight(176, 182)),
  ListValueModel(
      value: '180 - 186',
      publicValue: '180 - 186',
      range: NumRange.withRight(180, 186)),
  ListValueModel(
      value: '184 - 190',
      publicValue: '184 - 190',
      range: NumRange.withRight(184, 190)),
  ListValueModel(
      value: '188 - ..',
      publicValue: '188 - ..',
      range: NumRange.withRight(188, double.infinity)),
], pageNum: 1, hasReachedMax: true);

const OutputListValuesBatch manTrousersHeightRangesFrom0_164To188InMeter =
    OutputItemsFetchModel(items: [
  ListValueModel(
      value: '.. - 164',
      publicValue: '.. - 1.64',
      range: NumRange.withRight(0, 164)),
  ListValueModel(
      value: '164 - 170',
      publicValue: '1.64 - 1.7',
      range: NumRange.withRight(164, 170)),
  ListValueModel(
      value: '170 - 176',
      publicValue: '1.7 - 1.76',
      range: NumRange.withRight(170, 176)),
  ListValueModel(
      value: '176 - 182',
      publicValue: '1.76 - 1.82',
      range: NumRange.withRight(176, 182)),
  ListValueModel(
      value: '180 - 186',
      publicValue: '1.8 - 1.86',
      range: NumRange.withRight(180, 186)),
  ListValueModel(
      value: '184 - 190',
      publicValue: '1.84 - 1.9',
      range: NumRange.withRight(184, 190)),
  ListValueModel(
      value: '188 - ..',
      publicValue: '1.88 - ..',
      range: NumRange.withRight(188, double.infinity)),
], pageNum: 1, hasReachedMax: true);

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
    ListValueModel.str('FloatRates'),
  ],
  hasReachedMax: true,
  pageNum: 1,
);
