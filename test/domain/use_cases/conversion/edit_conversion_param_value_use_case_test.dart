import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/convert_unit_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_param_value_use_case.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';
import 'helpers/helpers.dart';

void main() {
  late EditConversionParamValueUseCase useCase;

  setUp(() {
    useCase = const EditConversionParamValueUseCase(
      convertUnitValuesUseCase: ConvertUnitValuesUseCase(),
      calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
        dynamicValueRepository: MockDynamicValueRepository(),
        listValueRepository: ListValueRepositoryImpl(),
      ),
    );
  });

  group('Change value in the conversion by formula', () {
    var currentUnitValues = [
      ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
      ConversionUnitValueModel.tuple(japanClothSize, 3, null),
    ];

    group('Change non-list parameter value (height)', () {
      group('New height param value is not empty', () {
        test('New height param value is acceptable', () async {
          await testCase(
            unitGroup: clothingSizeGroup,
            useCase: useCase,
            delta: EditConversionParamValueDelta(
              paramId: heightParam.id,
              paramSetId: heightParam.paramSetId,
              newValue: "150",
              newDefaultValue: null,
            ),
            currentSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
            currentParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(genderParam, "Male", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, 160, 1,
                        unit: centimeter),
                  ],
                )
              ],
            ),
            currentUnitValues: currentUnitValues,
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              ConversionUnitValueModel.tuple(japanClothSize, 3, null),
            ],
            expectedParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(genderParam, "Male", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, 150, 1,
                        unit: centimeter),
                  ],
                )
              ],
            ),
          );
        });

        test('New height param value is not acceptable', () async {
          await testCase(
            unitGroup: clothingSizeGroup,
            useCase: useCase,
            delta: EditConversionParamValueDelta(
              paramId: heightParam.id,
              paramSetId: heightParam.paramSetId,
              newValue: "170",
              newDefaultValue: null,
            ),
            currentSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
            currentParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(genderParam, "Male", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, 140, 1,
                        unit: centimeter),
                  ],
                )
              ],
            ),
            currentUnitValues: currentUnitValues,
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              ConversionUnitValueModel.tuple(japanClothSize, null, null),
            ],
            expectedParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(genderParam, "Male", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, 170, 1,
                        unit: centimeter),
                  ],
                )
              ],
            ),
          );
        });

        test('Both new values are not empty', () async {
          await testCase(
            unitGroup: clothingSizeGroup,
            useCase: useCase,
            delta: EditConversionParamValueDelta(
              paramId: heightParam.id,
              paramSetId: heightParam.paramSetId,
              newValue: "180",
              newDefaultValue: "140",
            ),
            currentSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 30, null),
            currentParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(genderParam, "Male", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, 150, 1,
                        unit: centimeter),
                  ],
                )
              ],
            ),
            currentUnitValues: currentUnitValues,
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 30, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 30, null),
              ConversionUnitValueModel.tuple(japanClothSize, null, null),
            ],
            expectedParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(genderParam, "Male", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, 180, 140,
                        unit: centimeter),
                  ],
                )
              ],
            ),
          );
        });
      });

      group('New height param value is empty', () {
        test(
          '''
          New value is empty | new default value is not empty 
          (for list param should be ignored)
          ''',
          () async {
            await testCase(
              unitGroup: clothingSizeGroup,
              useCase: useCase,
              delta: EditConversionParamValueDelta(
                paramId: heightParam.id,
                paramSetId: heightParam.paramSetId,
                newValue: null,
                newDefaultValue: "160",
              ),
              currentSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothingSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(
                          genderParam, "Male", null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, 150, 1,
                          unit: centimeter),
                    ],
                  )
                ],
              ),
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
                ConversionUnitValueModel.tuple(japanClothSize, 3, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothingSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(
                          genderParam, "Male", null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, null, 160,
                          unit: centimeter),
                    ],
                  )
                ],
              ),
            );
          },
        );
      });
    });

    group('Change list parameter value (garment)', () {
      group('New garment param value is empty', () {
        test(
          'New value is empty',
          () async {
            await testCase(
              unitGroup: clothingSizeGroup,
              useCase: useCase,
              delta: EditConversionParamValueDelta(
                paramId: garmentParam.id,
                paramSetId: garmentParam.paramSetId,
                newValue: null,
                newDefaultValue: null,
              ),
              currentSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothingSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(
                          genderParam, "Male", null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, 150, 1,
                          unit: centimeter),
                    ],
                  )
                ],
              ),
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothingSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(
                          genderParam, "Male", null),
                      ConversionParamValueModel.tuple(garmentParam, null, null),
                      ConversionParamValueModel.tuple(heightParam, 150, 1,
                          unit: centimeter),
                    ],
                  )
                ],
              ),
            );
          },
        );

        test(
          '''
          New value is empty | new default value is not empty 
          (for list param should be ignored)
          ''',
          () async {
            await testCase(
              unitGroup: clothingSizeGroup,
              useCase: useCase,
              delta: EditConversionParamValueDelta(
                paramId: garmentParam.id,
                paramSetId: garmentParam.paramSetId,
                newValue: null,
                newDefaultValue: "Any",
              ),
              currentSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothingSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(
                          genderParam, "Male", null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, 150, 1,
                          unit: centimeter),
                    ],
                  )
                ],
              ),
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothingSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(
                          genderParam, "Male", null),
                      ConversionParamValueModel.tuple(garmentParam, null, null),
                      ConversionParamValueModel.tuple(heightParam, 150, 1,
                          unit: centimeter),
                    ],
                  )
                ],
              ),
            );
          },
        );
      });
    });
  });
}
