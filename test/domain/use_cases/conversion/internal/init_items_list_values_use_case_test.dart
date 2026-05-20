import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/list_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/init_items_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../model/mock/mock_param.dart';
import '../../../model/mock/mock_unit.dart';
import '../../../model/mock/mock_unit_group.dart';
import '../../../repositories/mock/mockito_mock_repository.mocks.dart';

void main() {
  late final InitItemsListValuesUseCase useCase;
  late final MockitoNetworkRepository mockitoNetworkRepository =
      MockitoNetworkRepository();

  setUpAll(() {
    provideDummy<Either<ConvertouchException, List<ListValueModel>>>(
      const Right([]),
    );

    useCase = InitItemsListValuesUseCase(
      fetchListValuesUseCase: FetchListValuesUseCase(
        listValueRepository: ListValueRepositoryImpl(
          networkRepository: mockitoNetworkRepository,
        ),
      ),
    );
  });

  test(
      "[Clothes size] Should not enrich 'Garment' param, as 'Person' is not "
      "selected, should not preselect default values of params", () async {
    var conversion = ConversionModel(
      unitGroup: clothesSizeGroup,
      srcUnitValue: ConversionUnitValueModel.tuple(japanClothSize, null, null),
      params: ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(
                personParam,
                null,
                null,
              ),
              ConversionParamValueModel.tuple(garmentParam, null, null),
              ConversionParamValueModel.tuple(heightParam, 180, 1, unit: meter),
            ],
          )
        ],
        selectedIndex: 0,
      ),
      convertedUnitValues: [
        ConversionUnitValueModel.tuple(japanClothSize, null, null),
        ConversionUnitValueModel.tuple(germanyClothSize, null, null),
      ],
    );

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
                  null,
                  null,
                  listValues: const OutputListValuesBatch(
                    items: [
                      ListValueModel.raw("Man"),
                      ListValueModel.raw("Woman"),
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
                  null,
                  null,
                  listValues: const OutputListValuesBatch(
                    items: [],
                    params: ListValuesFetchParams(
                      listType: ConvertouchListType.garment,
                    ),
                    hasReachedMax: true,
                    pageNum: 0,
                  ),
                ),
                ConversionParamValueModel.tuple(heightParam, 180, 1,
                    unit: meter),
              ],
            )
          ],
          selectedIndex: 0,
        ),
        srcUnitValue:
            ConversionUnitValueModel.tuple(japanClothSize, null, null),
        convertedUnitValues: [
          ConversionUnitValueModel.tuple(
            japanClothSize,
            null,
            null,
            listValues: const OutputListValuesBatch(
              items: [
                ListValueModel.raw('S'),
                ListValueModel.raw('M'),
                ListValueModel.raw('L'),
                ListValueModel.raw('LL'),
                ListValueModel.raw('3L'),
                ListValueModel.raw('4L'),
                ListValueModel.raw('5L'),
                ListValueModel.raw('6L'),
              ],
              hasReachedMax: true,
              pageNum: 1,
            ),
          ),
          ConversionUnitValueModel.tuple(
            germanyClothSize,
            null,
            null,
            listValues: const OutputListValuesBatch(
              items: [
                ListValueModel.raw('32'),
                ListValueModel.raw('34'),
                ListValueModel.raw('36'),
                ListValueModel.raw('38'),
                ListValueModel.raw('40'),
                ListValueModel.raw('42'),
                ListValueModel.raw('44'),
                ListValueModel.raw('46'),
                ListValueModel.raw('48'),
                ListValueModel.raw('50'),
                ListValueModel.raw('52'),
                ListValueModel.raw('54'),
                ListValueModel.raw('56'),
              ],
              hasReachedMax: true,
              pageNum: 1,
            ),
          ),
        ],
      ).toJson(),
    );
  });

  test(
      "[Clothes size] Should enrich 'Garment' param, as 'Person' is selected, "
      "should not preselect default value of 'Garment'", () async {
    var conversion = ConversionModel(
      unitGroup: clothesSizeGroup,
      srcUnitValue: ConversionUnitValueModel.tuple(japanClothSize, null, null),
      params: ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(
                personParam,
                'Man',
                null,
              ),
              ConversionParamValueModel.tuple(garmentParam, null, null),
              ConversionParamValueModel.tuple(heightParam, 180, 1, unit: meter),
            ],
          )
        ],
        selectedIndex: 0,
      ),
      convertedUnitValues: [
        ConversionUnitValueModel.tuple(japanClothSize, null, null),
        ConversionUnitValueModel.tuple(germanyClothSize, null, null),
      ],
    );

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
                  'Man',
                  null,
                  listValues: const OutputListValuesBatch(
                    items: [
                      ListValueModel.raw("Man"),
                      ListValueModel.raw("Woman"),
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
                  null,
                  null,
                  listValues: const OutputListValuesBatch(
                    items: [
                      ListValueModel.raw("Shirt"),
                      ListValueModel.raw("Trousers"),
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
        srcUnitValue:
            ConversionUnitValueModel.tuple(japanClothSize, null, null),
        convertedUnitValues: [
          ConversionUnitValueModel.tuple(
            japanClothSize,
            null,
            null,
            listValues: const OutputListValuesBatch(
              items: [
                ListValueModel.raw('S'),
                ListValueModel.raw('M'),
                ListValueModel.raw('L'),
                ListValueModel.raw('LL'),
                ListValueModel.raw('3L'),
                ListValueModel.raw('4L'),
                ListValueModel.raw('5L'),
                ListValueModel.raw('6L'),
              ],
              hasReachedMax: true,
              pageNum: 1,
            ),
          ),
          ConversionUnitValueModel.tuple(
            germanyClothSize,
            null,
            null,
            listValues: const OutputListValuesBatch(
              items: [
                ListValueModel.raw('32'),
                ListValueModel.raw('34'),
                ListValueModel.raw('36'),
                ListValueModel.raw('38'),
                ListValueModel.raw('40'),
                ListValueModel.raw('42'),
                ListValueModel.raw('44'),
                ListValueModel.raw('46'),
                ListValueModel.raw('48'),
                ListValueModel.raw('50'),
                ListValueModel.raw('52'),
                ListValueModel.raw('54'),
                ListValueModel.raw('56'),
              ],
              hasReachedMax: true,
              pageNum: 1,
            ),
          ),
        ],
      ).toJson(),
    );
  });

  test(
      '[Currency] Should enrich conversion items and params with list values'
      'fetched from network and preselect them if possible', () async {
    final conversion = ConversionModel(
      unitGroup: currencyGroup,
      srcUnitValue: ConversionUnitValueModel.tuple(usd, null, null),
      params: ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: exchangeRateParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(
                exchangeRateSourceParam,
                null,
                null,
              ),
              ConversionParamValueModel.tuple(
                exchangeRateBankParam,
                null,
                null,
              ),
            ],
          ),
        ],
        selectedIndex: 0,
      ),
      convertedUnitValues: [
        ConversionUnitValueModel.tuple(usd, null, null),
        ConversionUnitValueModel.tuple(eur, null, null),
      ],
    );

    when(
      mockitoNetworkRepository.fetchList(
        listType: ConvertouchListType.exchangeRateSource,
        params: anyNamed('params'),
        pageSize: listValuesPageSize,
        pageNum: 0,
      ),
    ).thenAnswer(
      (_) async => const Right([
        ListValueModel.raw('FloatRates'),
      ]),
    );

    when(
      mockitoNetworkRepository.fetchList(
        listType: ConvertouchListType.exchangeRateBank,
        params: anyNamed('params'),
        pageSize: listValuesPageSize,
        pageNum: 0,
      ),
    ).thenAnswer(
      (_) async => const Right([]),
    );

    var enrichedConversion = ObjectUtils.tryGet(
      await useCase.execute(conversion),
    );

    expect(
      enrichedConversion.toJson(),
      ConversionModel(
        unitGroup: currencyGroup,
        srcUnitValue: ConversionUnitValueModel.tuple(usd, null, null),
        params: ConversionParamSetValueBulkModel(
          paramSetValues: [
            ConversionParamSetValueModel(
              paramSet: exchangeRateParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(
                  exchangeRateSourceParam,
                  null,
                  null,
                  listValues: const OutputListValuesBatch(
                    items: [
                      ListValueModel.raw('FloatRates'),
                    ],
                    hasReachedMax: true,
                    pageNum: 1,
                  ),
                ),
                ConversionParamValueModel.tuple(
                  exchangeRateBankParam,
                  null,
                  null,
                  listValues: const OutputListValuesBatch.empty(),
                ),
              ],
            )
          ],
          selectedIndex: 0,
        ),
        convertedUnitValues: [
          ConversionUnitValueModel.tuple(usd, null, null),
          ConversionUnitValueModel.tuple(eur, null, null),
        ],
      ).toJson(),
    );
  });
}
