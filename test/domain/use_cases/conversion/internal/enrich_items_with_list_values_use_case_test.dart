import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/enrich_items_with_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../../model/mock/mock_param.dart';
import '../../../model/mock/mock_unit.dart';
import '../../../model/mock/mock_unit_group.dart';

void main() {
  late EnrichItemsWithListValuesUseCase useCase;
  late ConversionModel conversion;

  setUp(() {
    useCase = const EnrichItemsWithListValuesUseCase(
      fetchListValuesUseCase: FetchListValuesUseCase(
        listValueRepository: ListValueRepositoryImpl(),
      ),
    );

    conversion = ConversionModel(
      unitGroup: clothesSizeGroup,
      srcUnitValue: ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
      params: ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(
                personParam,
                "Man",
                null,
                listValues: const OutputListValuesBatch(
                  items: [
                    ListValueModel.value("Man"),
                    ListValueModel.value("Woman"),
                  ],
                  params: ListValuesFetchParams(
                    listType: ConvertouchListType.person,
                  ),
                  hasReachedMax: true,
                  pageNum: 1,
                ),
              ),
              ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
              ConversionParamValueModel.tuple(heightParam, 180, 1, unit: meter),
            ],
          )
        ],
        selectedIndex: 0,
      ),
      convertedUnitValues: [
        ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
        ConversionUnitValueModel.tuple(germanyClothSize, 40, null),
      ],
    );
  });

  test(
      'Should enrich conversion items and params '
      'with local list values', () async {
    var enrichedConversion = ObjectUtils.tryGet(
      await useCase.execute(conversion),
    );

    expect(
      enrichedConversion.toJson(),
      ConversionModel(
        unitGroup: clothesSizeGroup,
        params: ConversionParamSetValueBulkModel(
          paramSetValues: [
            ConversionParamSetValueModel(
              paramSet: clothesSizeParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(
                  personParam,
                  "Man",
                  null,
                  listValues: const OutputListValuesBatch(
                    items: [
                      ListValueModel.value("Man"),
                      ListValueModel.value("Woman"),
                    ],
                    params: ListValuesFetchParams(
                      listType: ConvertouchListType.person,
                    ),
                    hasReachedMax: true,
                    pageNum: 1,
                  ),
                ),
                ConversionParamValueModel.tuple(
                  garmentParam,
                  "Shirt",
                  null,
                  listValues: const OutputListValuesBatch(
                    items: [
                      ListValueModel.value("Shirt"),
                      ListValueModel.value("Trousers"),
                    ],
                    params: ListValuesFetchParams(
                      listType: ConvertouchListType.garment,
                    ),
                    hasReachedMax: true,
                    pageNum: 1,
                  ),
                ),
                ConversionParamValueModel.tuple(heightParam, 180, 1,
                    unit: meter),
              ],
            )
          ],
          selectedIndex: 0,
        ),
        srcUnitValue: ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
        convertedUnitValues: [
          ConversionUnitValueModel.tuple(
            japanClothSize,
            'S',
            null,
            listValues: const OutputListValuesBatch(
              items: [
                ListValueModel.value('S'),
                ListValueModel.value('M'),
                ListValueModel.value('L'),
                ListValueModel.value('LL'),
                ListValueModel.value('3L'),
                ListValueModel.value('4L'),
                ListValueModel.value('5L'),
                ListValueModel.value('6L'),
              ],
              hasReachedMax: true,
              pageNum: 1,
            ),
          ),
          ConversionUnitValueModel.tuple(
            germanyClothSize,
            40,
            null,
            listValues: const OutputListValuesBatch(
              items: [],
              hasReachedMax: true,
              pageNum: 1,
            ),
          ),
        ],
      ).toJson(),
    );
  });
}
