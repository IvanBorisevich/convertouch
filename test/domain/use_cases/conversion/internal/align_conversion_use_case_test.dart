import 'package:convertouch/data/repositories/list_value_repository_impl.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/list_value_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/use_cases/conversion/add_param_sets_to_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/align_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_set_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_unit_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../model/mock/mock_list_values_batch.dart';
import '../../../model/mock/mock_param.dart';
import '../../../model/mock/mock_unit.dart';
import '../../../model/mock/mock_unit_group.dart';
import '../../../repositories/mock/mock_conversion_param_repository.dart';
import '../../../repositories/mock/mock_conversion_param_set_repository.dart';
import '../../../repositories/mock/mock_dynamic_value_repository.dart';
import '../../../repositories/mock/mock_unit_group_repository.dart';
import '../../../repositories/mock/mockito_mock_repository.mocks.dart';

void main() {
  late final AlignConversionUseCase useCase;
  late final MockitoNetworkRepository mockitoNetworkRepository =
      MockitoNetworkRepository();

  setUpAll(() {
    provideDummy<Either<ConvertouchException, List<ListValueModel>>>(
      const Right([]),
    );

    final listValueRepository = ListValueRepositoryImpl(
      networkRepository: mockitoNetworkRepository,
    );

    final fetchListValuesUseCase = FetchListValuesUseCase(
      listValueRepository: listValueRepository,
    );

    final CalculateDefaultValueUseCase calculateDefaultValueUseCase =
        CalculateDefaultValueUseCase(
      dynamicValueRepository: const MockDynamicValueRepository(),
      listValueRepository: listValueRepository,
    );

    final CalculateParamSetValueUseCase calculateParamSetValueUseCase =
        CalculateParamSetValueUseCase(
      calculateParamValueUseValue: CalculateParamValueUseValue(
        calculateDefaultValueUseCase: calculateDefaultValueUseCase,
        initParamListValuesUseCase: InitParamListValuesUseCase(
          fetchListValuesUseCase: fetchListValuesUseCase,
        ),
        unitGroupRepository: const MockUnitGroupRepository(),
      ),
    );

    useCase = AlignConversionUseCase(
      addParamSetsToConversionUseCase: AddParamSetsToConversionUseCase(
        calculateParamSetValueUseCase: calculateParamSetValueUseCase,
        conversionParamRepository: const MockConversionParamRepository(),
        conversionParamSetRepository: const MockConversionParamSetRepository(),
      ),
      calculateUnitValueUseValue: CalculateUnitValueUseValue(
        calculateDefaultValueUseCase: calculateDefaultValueUseCase,
        initUnitListValuesUseCase: InitUnitListValuesUseCase(
          fetchListValuesUseCase: fetchListValuesUseCase,
        ),
        unitGroupRepository: const MockUnitGroupRepository(),
      ),
      calculateParamSetValueUseCase: calculateParamSetValueUseCase,
    );
  });

  test(
      "[Clothes size] Should init 'Person' list values without preselect, "
      "should NOT init 'Garment' list values ('Person' is not selected), "
      "should init list values of unit values", () async {
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

    var alignedConversion = ObjectUtils.tryGet(
      await useCase.execute(conversion),
    );

    expect(
      alignedConversion.toJson(),
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
                  listValues: const OutputListValuesBatch.empty(),
                ),
                ConversionParamValueModel.tuple(
                  heightParam,
                  const NumRange.withRight(174, 180),
                  null,
                  unit: meter,
                  listValues: const OutputListValuesBatch.empty(),
                ),
              ],
            )
          ],
          selectedIndex: 0,
        ),
        srcUnitValue: ConversionUnitValueModel.tuple(
          japanClothSize,
          null,
          null,
          listValues: japanClothesSizes,
        ),
        convertedUnitValues: [
          ConversionUnitValueModel.tuple(
            japanClothSize,
            null,
            null,
            listValues: japanClothesSizes,
          ),
          ConversionUnitValueModel.tuple(
            germanyClothSize,
            null,
            null,
            listValues: germanyClothesSizes,
          ),
        ],
      ).toJson(),
    );
  });

  test(
      "[Clothes size] Should 'Person' list values without preselect (already selected), "
      "should init 'Garment' list values without preselect (alignCurrentValues = false), "
      "should NOT init 'Height' list values ('Garment' is not selected), "
      "should init conversion items list values without preselect "
      "(mandatory params NOT full, alignCurrentValues = false)", () async {
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
                heightParam,
                manShirtHeightRangesFrom0_164To190InMeter.items[3].valueModel,
                null,
                unit: meter,
              ),
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

    var alignedConversion = ObjectUtils.tryGet(
      await useCase.execute(conversion),
    );

    expect(
      alignedConversion.toJson(),
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
                  null,
                  null,
                  listValues: garmentParamListValues,
                ),
                ConversionParamValueModel.tuple(
                  heightParam,
                  manShirtHeightRangesFrom0_164To190InMeter.items[3].valueModel,
                  null,
                  unit: meter,
                  listValues: const OutputListValuesBatch.empty(),
                ),
              ],
            )
          ],
          selectedIndex: 0,
        ),
        srcUnitValue: ConversionUnitValueModel.tuple(
          japanClothSize,
          null,
          null,
          listValues: japanClothesSizes,
        ),
        convertedUnitValues: [
          ConversionUnitValueModel.tuple(
            japanClothSize,
            null,
            null,
            listValues: japanClothesSizes,
          ),
          ConversionUnitValueModel.tuple(
            germanyClothSize,
            null,
            null,
            listValues: germanyClothesSizes,
          ),
        ],
      ).toJson(),
    );
  });

  test(
      "[Currency] Should automatically add a mandatory param set, "
      "should make it active (set selectedIndex = 0), "
      "should not calculate default values", () async {
    final conversion = ConversionModel(
      unitGroup: currencyGroup,
      srcUnitValue: ConversionUnitValueModel.tuple(usd, null, null),
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

    var alignedConversion = ObjectUtils.tryGet(
      await useCase.execute(conversion),
    );

    expect(
      alignedConversion.toJson(),
      ConversionModel(
        unitGroup: currencyGroup,
        params: ConversionParamSetValueBulkModel(
          paramSetValues: [
            ConversionParamSetValueModel(
              paramSet: exchangeRateParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(
                  exchangeRateSourceParam,
                  'FloatRates',
                  null,
                  listValues: exchangeRateSources,
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
          mandatoryParamSetExists: true,
          selectedIndex: 0,
        ),
        srcUnitValue: ConversionUnitValueModel.tuple(usd, null, null),
        convertedUnitValues: [
          ConversionUnitValueModel.tuple(usd, null, null),
          ConversionUnitValueModel.tuple(eur, null, null),
        ],
      ).toJson(),
    );
  });
}
