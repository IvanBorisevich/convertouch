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
import 'package:convertouch/domain/model/use_case_model/output/output_items_fetch_model.dart';
import 'package:convertouch/domain/use_cases/common/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/init_items_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../model/mock/mock_list_values_batch.dart';
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
      "[Clothes size] Should init list values of 'Person' param without preselect, "
      "should not init list values of 'Garment' param ('Person' is not selected), "
      "should not init list values of unit values (not all mandatory params filled)",
      () async {
    var conversion = ConversionModel(
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
      srcUnitValue: ConversionUnitValueModel.tuple(japanClothSize, null, null),
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
                  listValues: personParamListValues,
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
          ConversionUnitValueModel.tuple(japanClothSize, null, null),
          ConversionUnitValueModel.tuple(germanyClothSize, null, null),
        ],
      ).toJson(),
    );
  });

  test(
      "[Clothes size] Should init 'Person' param list values with preselect, "
      "should init 'Garment' param list values with preselect ('Person' is selected), "
      "should init 'Height' param list values with preselect, "
      "should init list values of unit values with preselect (all mandatory params filled)",
      () async {
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
                  heightParam, const NumRange.withRight(1.74, 1.8), null,
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
                  listValues: personParamListValues,
                ),
                ConversionParamValueModel.tuple(
                  garmentParam,
                  'Shirt',
                  null,
                  listValues: garmentParamListValues,
                ),
                ConversionParamValueModel.tuple(
                  heightParam,
                  const NumRange.withRight(1.74, 1.8),
                  null,
                  unit: meter,
                  listValues: OutputItemsFetchModel(items: [
                    ListValueModel.range(const NumRange.withRight(0, 1.64)),
                    ListValueModel.range(const NumRange.withRight(1.64, 1.7)),
                    ListValueModel.range(const NumRange.withRight(1.7, 1.76)),
                    ListValueModel.range(const NumRange.withRight(1.74, 1.8)),
                    ListValueModel.range(const NumRange.withRight(1.78, 1.84)),
                    ListValueModel.range(const NumRange.withRight(1.82, 1.88)),
                    ListValueModel.range(const NumRange.withRight(1.86, 1.92)),
                    ListValueModel.range(
                        const NumRange.withoutBoth(1.9, double.infinity)),
                  ], pageNum: 1, hasReachedMax: true),
                ),
              ],
            )
          ],
          selectedIndex: 0,
        ),
        srcUnitValue: ConversionUnitValueModel.tuple(
          japanClothSize,
          'LL',
          null,
          listValues: japanClothSizeListValues,
        ),
        convertedUnitValues: [
          ConversionUnitValueModel.tuple(
            japanClothSize,
            'LL',
            null,
            listValues: japanClothSizeListValues,
          ),
          ConversionUnitValueModel.tuple(
            germanyClothSize,
            46,
            null,
            listValues: germanyClothesSizeListValues,
          ),
        ],
      ).toJson(),
    );
  });

  test(
      "[Currency] Should init 'Source' param list values with preselect, "
      "should not init 'Bank' param list values", () async {
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
                  'FloatRates',
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
