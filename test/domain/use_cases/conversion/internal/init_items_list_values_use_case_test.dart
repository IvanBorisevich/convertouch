import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/list_value_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/use_cases/common/init_item_list_values_use_case.dart';
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

    final fetchListValuesUseCase = FetchListValuesUseCase(
      listValueRepository: ListValueRepositoryImpl(
        networkRepository: mockitoNetworkRepository,
      ),
    );

    useCase = InitItemsListValuesUseCase(
      initUnitListValuesUseCase: InitUnitListValuesUseCase(
        fetchListValuesUseCase: fetchListValuesUseCase,
      ),
      initParamListValuesUseCase: InitParamListValuesUseCase(
        fetchListValuesUseCase: fetchListValuesUseCase,
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
              ConversionParamValueModel.tuple(
                  heightParam, const NumRange.withRight(174, 180), null,
                  unit: meter),
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
                      ListValueModel.str("Man"),
                      ListValueModel.str("Woman"),
                    ],
                    fetchParams: ListValuesFetchParams(
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
                    fetchParams: ListValuesFetchParams(
                      listType: ConvertouchListType.garment,
                    ),
                    hasReachedMax: true,
                    pageNum: 0,
                  ),
                ),
                ConversionParamValueModel.tuple(
                  heightParam,
                  const NumRange.withRight(174, 180),
                  null,
                  unit: meter,
                  listValues: const OutputListValuesBatch(
                    items: [],
                    fetchParams: ListValuesFetchParams(
                      listType: ConvertouchListType.clothesHeightRange,
                    ),
                    hasReachedMax: true,
                    pageNum: 0,
                  ),
                ),
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
                ListValueModel.str('S'),
                ListValueModel.str('M'),
                ListValueModel.str('L'),
                ListValueModel.str('LL'),
                ListValueModel.str('3L'),
                ListValueModel.str('4L'),
                ListValueModel.str('5L'),
                ListValueModel.str('6L'),
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
              ConversionParamValueModel.tuple(
                  heightParam, const NumRange.withRight(174, 180), null,
                  unit: meter),
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
                      ListValueModel.str("Man"),
                      ListValueModel.str("Woman"),
                    ],
                    fetchParams: ListValuesFetchParams(
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
                      ListValueModel.str("Shirt"),
                      ListValueModel.str("Trousers"),
                    ],
                    fetchParams: ListValuesFetchParams(
                      listType: ConvertouchListType.garment,
                    ),
                    hasReachedMax: true,
                    pageNum: 1,
                  ),
                ),
                ConversionParamValueModel.tuple(
                  heightParam,
                  const NumRange.withRight(174, 180),
                  null,
                  unit: meter,
                  listValues: const OutputListValuesBatch(
                    items: [],
                    fetchParams: ListValuesFetchParams(
                      listType: ConvertouchListType.clothesHeightRange,
                    ),
                    hasReachedMax: true,
                    pageNum: 0,
                  ),
                ),
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
                ListValueModel.str('S'),
                ListValueModel.str('M'),
                ListValueModel.str('L'),
                ListValueModel.str('LL'),
                ListValueModel.str('3L'),
                ListValueModel.str('4L'),
                ListValueModel.str('5L'),
                ListValueModel.str('6L'),
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
        ListValueModel.str('FloatRates'),
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
                      ListValueModel.str('FloatRates'),
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
