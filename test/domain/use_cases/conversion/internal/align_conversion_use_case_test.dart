import 'package:convertouch/data/repositories/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_align_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_items_fetch_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/align_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_non_list_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_set_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_unit_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/dynamic_data/fetch_dynamic_value_use_use.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../model/mock/mock_list_values_batch.dart';
import '../../../model/mock/mock_param.dart';
import '../../../model/mock/mock_unit.dart';
import '../../../model/mock/mock_unit_group.dart';
import '../../../repositories/mock/mock_dynamic_value_repository.dart';
import '../../../repositories/mock/mock_unit_group_repository.dart';
import '../../../repositories/mock/mockito_mock_repository.mocks.dart';

void main() {
  late final AlignConversionUseCase useCase;
  late final MockitoNetworkRepository mockitoNetworkRepository =
      MockitoNetworkRepository();

  setUpAll(() {
    provideDummy<Either<ConvertouchException, List<ValueModel>>>(
      const Right([]),
    );

    final listValueRepository = ListValueRepositoryImpl(
      networkRepository: mockitoNetworkRepository,
    );

    final fetchListValuesUseCase = FetchListValuesUseCase(
      listValueRepository: listValueRepository,
    );

    const CalculateNonListDefaultValueUseCase calculateDefaultValueUseCase =
        CalculateNonListDefaultValueUseCase(
      fetchDynamicValueUseCase: FetchDynamicValueUseCase(
        dynamicValueRepository: MockDynamicValueRepository(),
      ),
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
              ConversionParamValueModel.tuple(
                garmentParam,
                null,
                null,
              ),
              ConversionParamValueModel.tuple(
                heightParam,
                const NumRange.withRight(174, 180),
                null,
                unit: meter,
              ),
            ],
          )
        ],
        selectedIndex: 0,
      ),
      srcUnitValue: ConversionUnitValueModel.tuple(jpClothesSize, null, null),
      convertedUnitValues: [
        ConversionUnitValueModel.tuple(jpClothesSize, null, null),
        ConversionUnitValueModel.tuple(deClothesSize, null, null),
      ],
    );

    ObjectUtils.tryGet(
      await useCase.execute(
        InputConversionAlignModel(
          asyncAlign: false,
          conversion: conversion,
          onConversionParamsAligned: (alignedConversion) {
            expect(
              alignedConversion.toJson(saveListValues: true),
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
                          listValuesFetchResult: personParamListValues,
                        ),
                        ConversionParamValueModel.tuple(
                          garmentParam,
                          null,
                          null,
                          listValuesFetchResult:
                              const OutputItemsFetchModel.successEmpty(),
                        ),
                        ConversionParamValueModel.tuple(
                          heightParam,
                          const NumRange.withRight(174, 180),
                          null,
                          unit: meter,
                          listValuesFetchResult:
                              const OutputItemsFetchModel.successEmpty(),
                        ),
                      ],
                    )
                  ],
                  selectedIndex: 0,
                ),
                srcUnitValue: ConversionUnitValueModel.tuple(
                  jpClothesSize,
                  null,
                  null,
                ),
                convertedUnitValues: [
                  ConversionUnitValueModel.tuple(
                    jpClothesSize,
                    null,
                    null,
                  ),
                  ConversionUnitValueModel.tuple(
                    deClothesSize,
                    null,
                    null,
                  ),
                ],
              ).toJson(saveListValues: true),
            );
          },
          onConversionUnitValuesAligned: (alignedConversion) {
            expect(
              alignedConversion.toJson(saveListValues: true),
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
                          listValuesFetchResult: personParamListValues,
                        ),
                        ConversionParamValueModel.tuple(
                          garmentParam,
                          null,
                          null,
                          listValuesFetchResult:
                              const OutputItemsFetchModel.successEmpty(),
                        ),
                        ConversionParamValueModel.tuple(
                          heightParam,
                          const NumRange.withRight(174, 180),
                          null,
                          unit: meter,
                          listValuesFetchResult:
                              const OutputItemsFetchModel.successEmpty(),
                        ),
                      ],
                    )
                  ],
                  selectedIndex: 0,
                ),
                srcUnitValue: ConversionUnitValueModel.tuple(
                  jpClothesSize,
                  null,
                  null,
                  listValuesFetchResult: japanClothesSizes,
                ),
                convertedUnitValues: [
                  ConversionUnitValueModel.tuple(
                    jpClothesSize,
                    null,
                    null,
                    listValuesFetchResult: japanClothesSizes,
                  ),
                  ConversionUnitValueModel.tuple(
                    deClothesSize,
                    null,
                    null,
                    listValuesFetchResult: germanyClothesSizes,
                  ),
                ],
              ).toJson(saveListValues: true),
            );
          },
        ),
      ),
    );
  });

  test(
      "[Clothes size] Should init 'Person' list values without preselect (already selected), "
      "should init 'Garment' list values with preselect, "
      "should init 'Height' list values ('Garment' is selected), "
      "should init list values and calculate conversion items", () async {
    var conversion = ConversionModel(
      unitGroup: clothesSizeGroup,
      srcUnitValue: ConversionUnitValueModel.tuple(jpClothesSize, null, null),
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
                manShirtHeightRangesFrom0_164To190InMeter.items[3],
                null,
                unit: meter,
              ),
            ],
          )
        ],
        selectedIndex: 0,
      ),
      convertedUnitValues: [
        ConversionUnitValueModel.tuple(jpClothesSize, null, null),
        ConversionUnitValueModel.tuple(deClothesSize, null, null),
      ],
    );

    ObjectUtils.tryGet(
      await useCase.execute(
        InputConversionAlignModel(
          asyncAlign: false,
          conversion: conversion,
          onConversionParamsAligned: (alignedConversion) {
            expect(
              alignedConversion.toJson(
                saveListValues: true,
              ),
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
                          listValuesFetchResult: personParamListValues,
                        ),
                        ConversionParamValueModel.tuple(
                          garmentParam,
                          'Shirt',
                          null,
                          listValuesFetchResult: garmentParamListValues,
                        ),
                        ConversionParamValueModel.tuple(
                          heightParam,
                          manShirtHeightRangesFrom0_164To190InMeter.items[3],
                          null,
                          unit: meter,
                          listValuesFetchResult:
                              manShirtHeightRangesFrom0_164To190InMeter,
                        ),
                      ],
                    )
                  ],
                  selectedIndex: 0,
                ),
                srcUnitValue: ConversionUnitValueModel.tuple(
                  jpClothesSize,
                  null,
                  null,
                ),
                convertedUnitValues: [
                  ConversionUnitValueModel.tuple(
                    jpClothesSize,
                    null,
                    null,
                  ),
                  ConversionUnitValueModel.tuple(
                    deClothesSize,
                    null,
                    null,
                  ),
                ],
              ).toJson(saveListValues: true),
            );
          },
          onConversionUnitValuesAligned: (alignedConversion) {
            expect(
              alignedConversion.toJson(saveListValues: true),
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
                          listValuesFetchResult: personParamListValues,
                        ),
                        ConversionParamValueModel.tuple(
                          garmentParam,
                          'Shirt',
                          null,
                          listValuesFetchResult: garmentParamListValues,
                        ),
                        ConversionParamValueModel.tuple(
                          heightParam,
                          manShirtHeightRangesFrom0_164To190InMeter.items[3],
                          null,
                          unit: meter,
                          listValuesFetchResult:
                              manShirtHeightRangesFrom0_164To190InMeter,
                        ),
                      ],
                    )
                  ],
                  selectedIndex: 0,
                ),
                srcUnitValue: ConversionUnitValueModel.tuple(
                  jpClothesSize,
                  japanClothesSizes.items[0],
                  null,
                  listValuesFetchResult: japanClothesSizes,
                ),
                convertedUnitValues: [
                  ConversionUnitValueModel.tuple(
                    jpClothesSize,
                    japanClothesSizes.items[0],
                    null,
                    listValuesFetchResult: japanClothesSizes,
                  ),
                  ConversionUnitValueModel.tuple(
                    deClothesSize,
                    germanyClothesSizes.items[0],
                    null,
                    listValuesFetchResult: germanyClothesSizes,
                  ),
                ],
              ).toJson(saveListValues: true),
            );
          },
        ),
      ),
    );
  });
}
