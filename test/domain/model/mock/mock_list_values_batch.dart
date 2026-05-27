import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/list_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_items_fetch_model.dart';

const OutputListValuesBatch japanClothSizeListValues = OutputItemsFetchModel(
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

const OutputListValuesBatch usaClothSizeListValues = OutputItemsFetchModel(
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

const OutputListValuesBatch italianClothesSizeListValues =
    OutputItemsFetchModel(
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

const OutputListValuesBatch europeanClothSizeListValues = OutputItemsFetchModel(
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

const OutputListValuesBatch spainClothSizeListValues = OutputItemsFetchModel(
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

const OutputListValuesBatch germanyClothesSizeListValues =
    OutputItemsFetchModel(
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

const OutputListValuesBatch barWeightParamLbListValues = OutputItemsFetchModel(
  items: [
    ListValueModel.str('22'),
    ListValueModel.str('44'),
  ],
  pageNum: 1,
  hasReachedMax: true,
);
