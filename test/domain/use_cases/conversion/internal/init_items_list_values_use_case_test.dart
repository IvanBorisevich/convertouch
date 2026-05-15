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
      '[Clothes size] Should enrich conversion items and params with local list values'
      'and preselect them if possible', () async {
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
                  null,
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
        srcUnitValue:
            ConversionUnitValueModel.tuple(japanClothSize, null, null),
        convertedUnitValues: [
          ConversionUnitValueModel.tuple(
            japanClothSize,
            null,
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
            null,
            null,
            listValues: const OutputListValuesBatch(
              items: [
                ListValueModel.value('32'),
                ListValueModel.value('34'),
                ListValueModel.value('36'),
                ListValueModel.value('38'),
                ListValueModel.value('40'),
                ListValueModel.value('42'),
                ListValueModel.value('44'),
                ListValueModel.value('46'),
                ListValueModel.value('48'),
                ListValueModel.value('50'),
                ListValueModel.value('52'),
                ListValueModel.value('54'),
                ListValueModel.value('56'),
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
        ListValueModel.value('FloatRates'),
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
                      ListValueModel.value('FloatRates'),
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
