import 'dart:math';

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
import 'package:convertouch/domain/use_cases/conversion/align_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_non_list_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_set_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_item_value_use_case.dart';
import 'package:convertouch/domain/use_cases/dynamic_data/fetch_dynamic_value_use_use.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_list_values_batch.dart';
import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';
import '../../repositories/mock/mock_unit_group_repository.dart';
import '../../repositories/mock/mockito_mock_repository.mocks.dart';

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

    useCase = AlignConversionUseCase(
      calculateUnitValueUseValue: CalculateUnitValueUseValue(
        calculateDefaultValueUseCase: calculateDefaultValueUseCase,
        fetchListValuesUseCase: fetchListValuesUseCase,
      ),
      calculateParamSetValueUseCase: CalculateParamSetValueUseCase(
        calculateParamValueUseValue: CalculateParamValueUseValue(
          calculateDefaultValueUseCase: calculateDefaultValueUseCase,
          fetchListValuesUseCase: fetchListValuesUseCase,
          unitGroupRepository: const MockUnitGroupRepository(),
        ),
      ),
    );
  });

  test(
      "[Clothes size] Should init 'Person' list values without preselect, "
      "should NOT init 'Garment' list values ('Person' is not selected), "
      "should remove 'Height' value since it has no list values"
      "should init list values of unit values", () async {
    final misalignedConversion = ConversionModel(
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

    final alignedConversion = ObjectUtils.tryGet(
      await useCase.execute(
        InputConversionAlignModel(
          conversion: misalignedConversion,
        ),
      ),
    );

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
                  null,
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
  });

  test(
      "[Clothes size] Should init 'Person' list values without preselect (already selected), "
      "should init 'Garment' list values with preselect, "
      "should init 'Height' list values ('Garment' is selected), "
      "should init list values with preselect", () async {
    final misalignedConversion = ConversionModel(
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

    final alignedConversion = ObjectUtils.tryGet(
      await useCase.execute(
        InputConversionAlignModel(
          conversion: misalignedConversion,
        ),
      ),
    );

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
  });

  test(
      "[Currency] Should NOT init 'Exchange Rate Source / Bank' list values "
          "(fetched via API with possible delay), "
          "should NOT preselect anything", () async {
    final misalignedConversion = ConversionModel(
      unitGroup: currencyGroup,
      params: ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: exchangeRateParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(
                exchangeRateSourceBankParam,
                null,
                null,
              ),
            ],
          )
        ],
        selectedIndex: 0,
      ),
      srcUnitValue: ConversionUnitValueModel.tuple(aud, null, null),
      convertedUnitValues: [
        ConversionUnitValueModel.tuple(aud, null, null),
        ConversionUnitValueModel.tuple(usd, null, null),
      ],
    );

    final alignedConversion = ObjectUtils.tryGet(
      await useCase.execute(
        InputConversionAlignModel(
          conversion: misalignedConversion,
        ),
      ),
    );

    expect(
      alignedConversion.toJson(saveListValues: true),
      misalignedConversion.toJson(saveListValues: true),
    );
  });


  test(
      "[Currency] Should NOT init 'Exchange Rate Source / Bank' list values "
          "(fetched via API with possible delay), "
          "should keep current value", () async {
    final misalignedConversion = ConversionModel(
      unitGroup: currencyGroup,
      params: ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: exchangeRateParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(
                exchangeRateSourceBankParam,
                'British Bank',
                null,
              ),
            ],
          )
        ],
        selectedIndex: 0,
      ),
      srcUnitValue: ConversionUnitValueModel.tuple(aud, null, null),
      convertedUnitValues: [
        ConversionUnitValueModel.tuple(aud, null, null),
        ConversionUnitValueModel.tuple(usd, null, null),
      ],
    );

    final alignedConversion = ObjectUtils.tryGet(
      await useCase.execute(
        InputConversionAlignModel(
          conversion: misalignedConversion,
        ),
      ),
    );

    expect(
      alignedConversion.toJson(saveListValues: true),
      misalignedConversion.toJson(saveListValues: true),
    );
  });

  group(
      "Backward compatible case: "
      "the param 'Height' non-range value should be aligned "
      "to the corresponding range value", () {
    test(
        "[Clothes size] Should init 'Person' list values without preselect, "
        "should NOT init 'Garment' list values ('Person' is not selected), "
        "should remove 'Height' value since it has no list values"
        "should init list values of unit values", () async {
      final misalignedConversion = ConversionModel(
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
                  1.75,
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

      final alignedConversion = ObjectUtils.tryGet(
        await useCase.execute(
          InputConversionAlignModel(
            conversion: misalignedConversion,
          ),
        ),
      );

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
                    null,
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
    });

    test(
        "[Clothes size] Should init 'Person' list values without preselect (already selected), "
        "should init 'Garment' list values with preselect, "
        "should init 'Height' list values ('Garment' is selected), "
        "should init list values with preselect", () async {
      final misalignedConversion = ConversionModel(
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
                ConversionParamValueModel.tuple(
                  garmentParam,
                  null,
                  null,
                ),
                ConversionParamValueModel.tuple(
                  heightParam,
                  1.75,
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

      final alignedConversion = ObjectUtils.tryGet(
        await useCase.execute(
          InputConversionAlignModel(
            conversion: misalignedConversion,
          ),
        ),
      );

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
                    manShirtHeightRangesFrom0_164To190InMeter.items[2],
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
    });

    test(
        "[Ring size] Should init 'Diameter' and 'Circumference' list values, "
        "should align non-list values, "
        "should init unit list values with preselect", () async {
      final misalignedConversion = ConversionModel(
        unitGroup: ringSizeGroup,
        params: ConversionParamSetValueBulkModel(
          paramSetValues: [
            ConversionParamSetValueModel(
              paramSet: ringSizeByDiameterParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(
                  diameterParam,
                  15.4,
                  null,
                  unit: millimeter,
                ),
              ],
            ),
            ConversionParamSetValueModel(
              paramSet: ringSizeByDiameterParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(
                  circumferenceParam,
                  1.61 * pi,
                  null,
                  unit: centimeter,
                ),
              ],
            ),
          ],
          selectedIndex: 0,
        ),
        srcUnitValue: ConversionUnitValueModel.tuple(
          esRingSize,
          null,
          null,
        ),
        convertedUnitValues: [
          ConversionUnitValueModel.tuple(
            esRingSize,
            null,
            null,
          ),
          ConversionUnitValueModel.tuple(
            usaRingSize,
            null,
            null,
          ),
        ],
      );

      final alignedConversion = ObjectUtils.tryGet(
        await useCase.execute(
          InputConversionAlignModel(
            conversion: misalignedConversion,
          ),
        ),
      );

      expect(
        alignedConversion.toJson(saveListValues: true),
        ConversionModel(
          unitGroup: ringSizeGroup,
          params: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: ringSizeByDiameterParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(
                    diameterParam,
                    ringDiameterRangesInMm.items[3],
                    null,
                    unit: millimeter,
                    listValuesFetchResult: ringDiameterRangesInMm,
                  ),
                ],
              ),
              ConversionParamSetValueModel(
                paramSet: ringSizeByDiameterParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(
                    circumferenceParam,
                    ringCircumferenceRangesInCm.items[4],
                    null,
                    unit: centimeter,
                    listValuesFetchResult: ringCircumferenceRangesInCm,
                  ),
                ],
              ),
            ],
            selectedIndex: 0,
          ),
          srcUnitValue: ConversionUnitValueModel.tuple(
            esRingSize,
            esRingSizes.items[0],
            null,
            listValuesFetchResult: esRingSizes,
          ),
          convertedUnitValues: [
            ConversionUnitValueModel.tuple(
              esRingSize,
              esRingSizes.items[0],
              null,
              listValuesFetchResult: esRingSizes,
            ),
            ConversionUnitValueModel.tuple(
              usaRingSize,
              usaRingSizes.items[0],
              null,
              listValuesFetchResult: usaRingSizes,
            ),
          ],
        ).toJson(saveListValues: true),
      );
    });
  });
}
