import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/convert_unit_values_use_case.dart';
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
    useCase = const ReplaceConversionParamUnitUseCase(
      convertUnitValuesUseCase: ConvertUnitValuesUseCase(),
      calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
        dynamicValueRepository: MockDynamicValueRepository(),
        listValueRepository: ListValueRepositoryImpl(),
      ),
      listValueRepository: ListValueRepositoryImpl(),
    );
  });

  group('Change param unit in the conversion by formula', () {
    group('Change non-list parameter unit (height)', () {
      test('New height param value is acceptable', () async {
        await testCase(
          unitGroup: clothingSizeGroup,
          useCase: useCase,
          delta: ReplaceConversionParamUnitDelta(
            paramId: heightParam.id,
            paramSetId: heightParam.paramSetId,
            newUnit: meter,
          ),
          currentParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothingSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(heightParam, 1.7, 1,
                      unit: centimeter),
                ],
              )
            ],
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
                paramSet: clothingSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(heightParam, 1.7, 1,
                      unit: meter),
                ],
              )
            ],
          ),
        );
      });

      test('Height param value is not acceptable for the new unit', () async {
        await testCase(
          unitGroup: clothingSizeGroup,
          useCase: useCase,
          delta: ReplaceConversionParamUnitDelta(
            paramId: heightParam.id,
            paramSetId: heightParam.paramSetId,
            newUnit: meter,
          ),
          currentParams: ConversionParamSetValueBulkModel(
            paramSetValues: [
              ConversionParamSetValueModel(
                paramSet: clothingSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(heightParam, 180, 1,
                      unit: centimeter),
                ],
              )
            ],
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
                paramSet: clothingSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(heightParam, 180, 1,
                      unit: meter),
                ],
              )
            ],
          ),
        );
      });

      test('New height default param value is not empty', () async {
        await testCase(
          unitGroup: clothingSizeGroup,
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
                paramSet: clothingSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(heightParam, null, 1,
                      unit: centimeter),
                ],
              )
            ],
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
                paramSet: clothingSizeParamSet,
                paramValues: [
                  ConversionParamValueModel.tuple(personParam, "Man", null),
                  ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
                  ConversionParamValueModel.tuple(heightParam, null, 1,
                      unit: meter),
                ],
              )
            ],
          ),
        );
      });

      test('New height param values are empty '
        '(the value of the unit type should be used for calculation)',
        () async {
          await testCase(
            unitGroup: clothingSizeGroup,
            useCase: useCase,
            delta: ReplaceConversionParamUnitDelta(
              paramId: heightParam.id,
              paramSetId: heightParam.paramSetId,
              newUnit: meter,
            ),
            currentParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, "Man", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, null, null,
                        unit: centimeter),
                  ],
                )
              ],
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
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(personParam, "Man", null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, null, 1,
                        unit: meter),
                  ],
                )
              ],
            ),
          );
        },
      );
    });
  });
}
