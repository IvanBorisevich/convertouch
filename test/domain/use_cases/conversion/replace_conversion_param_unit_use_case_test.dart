import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_source_item_by_params_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/replace_item_unit_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/replace_conversion_param_unit_use_case.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';
import 'helpers/helpers.dart';

void main() {
  late ReplaceConversionParamUnitUseCase useCase;

  setUp(() {
    const calculateDefaultValueUseCase = CalculateDefaultValueUseCase(
      dynamicValueRepository: MockDynamicValueRepository(),
      listValueRepository: ListValueRepositoryImpl(),
    );

    useCase = const ReplaceConversionParamUnitUseCase(
      calculateSourceItemByParamsUseCase: CalculateSourceItemByParamsUseCase(
        calculateDefaultValueUseCase: calculateDefaultValueUseCase,
      ),
      replaceUnitInParamUseCase: ReplaceUnitInParamUseCase(
        listValueRepository: ListValueRepositoryImpl(),
        calculateDefaultValueUseCase: calculateDefaultValueUseCase,
      ),
    );
  });

  group('Change param unit in the conversion by formula', () {
    group('Change non-list parameter unit (height)', () {
      test('New height param value is acceptable', () async {
        await testCase(
          unitGroup: clothesSizeGroup,
          useCase: useCase,
          delta: ReplaceConversionParamUnitDelta(
            paramId: heightParam.id,
            paramSetId: heightParam.paramSetId,
            newUnit: meter,
          ),
          currentParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothesSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(heightParam, 1.7, 1,
                      unit: centimeter),
                ],
              )
            ],
            selectedIndex: 0,
          ),
          currentSrc:
              ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
            ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
          ],
          expectedSrc:
              ConversionUnitValueModel.tuple(europeanClothSize, 44, null),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(europeanClothSize, 44, null),
            ConversionUnitValueModel.tuple(japanClothSize, 'M', null),
          ],
          expectedParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothesSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(heightParam, 1.7, 1,
                      unit: meter),
                ],
              )
            ],
            selectedIndex: 0,
          ),
        );
      });

      test('Height param value is not acceptable for the new unit', () async {
        await testCase(
          unitGroup: clothesSizeGroup,
          useCase: useCase,
          delta: ReplaceConversionParamUnitDelta(
            paramId: heightParam.id,
            paramSetId: heightParam.paramSetId,
            newUnit: meter,
          ),
          currentParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothesSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(heightParam, 180, 1,
                      unit: centimeter),
                ],
              )
            ],
            selectedIndex: 0,
          ),
          currentSrc:
              ConversionUnitValueModel.tuple(europeanClothSize, 50, null),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(europeanClothSize, 50, null),
            ConversionUnitValueModel.tuple(japanClothSize, '3L', null),
          ],
          expectedSrc:
              ConversionUnitValueModel.tuple(europeanClothSize, 56, null),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(europeanClothSize, 56, null),
            ConversionUnitValueModel.tuple(japanClothSize, '6L', null),
          ],
          expectedParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothesSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(heightParam, 180, 1,
                      unit: meter),
                ],
              )
            ],
            selectedIndex: 0,
          ),
        );
      });

      test('New height default param value is not empty', () async {
        await testCase(
          unitGroup: clothesSizeGroup,
          useCase: useCase,
          delta: ReplaceConversionParamUnitDelta(
            paramId: heightParam.id,
            paramSetId: heightParam.paramSetId,
            newUnit: meter,
          ),
          currentSrc:
              ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
          currentParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothesSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(heightParam, null, 1,
                      unit: centimeter),
                ],
              )
            ],
            selectedIndex: 0,
          ),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
            ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
          ],
          expectedSrc:
              ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
            ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
          ],
          expectedParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothesSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(heightParam, null, 1,
                      unit: meter),
                ],
              )
            ],
            selectedIndex: 0,
          ),
        );
      });

      test(
        'New height param values are empty '
        '(the value of the unit type should be used for calculation)',
        () async {
          await testCase(
            unitGroup: clothesSizeGroup,
            useCase: useCase,
            delta: ReplaceConversionParamUnitDelta(
              paramId: heightParam.id,
              paramSetId: heightParam.paramSetId,
              newUnit: meter,
            ),
            currentParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothesSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, "Man", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, null, null,
                        unit: centimeter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
            currentSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
              ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
            ],
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
              ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
            ],
            expectedParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothesSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, "Man", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, null, 1,
                        unit: meter),
                  ],
                )
              ],
              selectedIndex: 0,
            ),
          );
        },
      );
    });
  });

  group('Change param unit in the conversion by coefficients', () {
    group('Change list parameter unit (bar weight)', () {
      test(
          'Param list value should change as well, '
          'conversion values should remain as is', () async {
        double expectedNum = 22 * pound.coefficient! + 45 * 2;

        await testCase(
          unitGroup: massGroup,
          useCase: useCase,
          delta: ReplaceConversionParamUnitDelta(
            paramId: barWeightParam.id,
            paramSetId: barWeightParam.paramSetId,
            newUnit: pound,
          ),
          currentParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: barbellWeightParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(barWeightParam, 10, null,
                      unit: kilogram),
                  ConversionParamValueModel.tuple(oneSideWeightParam, 45, 1,
                      unit: kilogram),
                ],
              )
            ],
            selectedIndex: 0,
          ),
          currentSrc: ConversionUnitValueModel.tuple(kilogram, expectedNum, 1),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(kilogram, expectedNum, 1),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(kilogram, expectedNum, 1),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(kilogram, expectedNum, 1),
          ],
          expectedParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: barbellWeightParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(barWeightParam, 22, null,
                      unit: pound),
                  ConversionParamValueModel.tuple(oneSideWeightParam, 45, 1,
                      unit: kilogram),
                ],
              ),
            ],
            selectedIndex: 0,
          ),
        );
      });
    });
  });
}
