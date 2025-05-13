import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/convert_unit_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/replace_conversion_item_unit_use_case.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';
import 'helpers/helpers.dart';

void main() {
  late ReplaceConversionItemUnitUseCase useCase;

  setUp(() {
    useCase = const ReplaceConversionItemUnitUseCase(
      convertUnitValuesUseCase: ConvertUnitValuesUseCase(),
      calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
        dynamicValueRepository: MockDynamicValueRepository(),
      ),
      listValueRepository: ListValueRepositoryImpl(),
    );
  });

  group('Change unit in the conversion by coefficients', () {
    group('Without params', () {
      test('Source value is not empty', () async {
        await testCase(
          useCase: useCase,
          delta: ReplaceConversionItemUnitDelta(
            newUnit: meter,
            oldUnitId: decimeter.id,
          ),
          unitGroup: lengthGroup,
          currentSrc: ConversionUnitValueModel.tuple(decimeter, 10, 1),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, 10, 1),
            ConversionUnitValueModel.tuple(centimeter, 100, 10),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(meter, 10, 1),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(meter, 10, 1),
            ConversionUnitValueModel.tuple(centimeter, 1000, 100),
          ],
        );
      });

      test('Source default value is not empty', () async {
        await testCase(
          useCase: useCase,
          delta: ReplaceConversionItemUnitDelta(
            newUnit: meter,
            oldUnitId: decimeter.id,
          ),
          unitGroup: lengthGroup,
          currentSrc: ConversionUnitValueModel.tuple(decimeter, null, 1),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, null, 1),
            ConversionUnitValueModel.tuple(centimeter, null, 10),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(meter, null, 1),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(meter, null, 1),
            ConversionUnitValueModel.tuple(centimeter, null, 100),
          ],
        );
      });

      test('Both source values are empty', () async {
        await testCase(
          useCase: useCase,
          delta: ReplaceConversionItemUnitDelta(
            newUnit: meter,
            oldUnitId: decimeter.id,
          ),
          unitGroup: lengthGroup,
          currentSrc: ConversionUnitValueModel.tuple(decimeter, null, null),
          currentUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, null, null),
            ConversionUnitValueModel.tuple(centimeter, null, null),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(meter, null, 1),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(meter, null, 1),
            ConversionUnitValueModel.tuple(centimeter, null, 100),
          ],
        );
      });
    });
  });

  group('Change unit in the conversion by formula', () {
    group('With params', () {
      group('All param values are set', () {
        test('Source value is not empty', () async {
          await testCase(
            unitGroup: clothingSizeGroup,
            useCase: useCase,
            delta: ReplaceConversionItemUnitDelta(
              newUnit: usaClothSize,
              oldUnitId: europeanClothSize.id,
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
                    ConversionParamValueModel.tuple(heightParam, 165, 1,
                        unit: centimeter),
                  ],
                )
              ],
            ),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              ConversionUnitValueModel.tuple(japanClothSize, 3, null),
            ],
            expectedSrc: ConversionUnitValueModel.tuple(usaClothSize, 0, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(usaClothSize, 0, null),
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
                    ConversionParamValueModel.tuple(heightParam, 165, 1,
                        unit: centimeter),
                  ],
                )
              ],
            ),
          );
        });
      });

      group('All param values are set (default param value is set)', () {
        test('Source value is not empty', () async {
          await testCase(
            unitGroup: clothingSizeGroup,
            useCase: useCase,
            delta: ReplaceConversionItemUnitDelta(
              newUnit: usaClothSize,
              oldUnitId: europeanClothSize.id,
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
                    ConversionParamValueModel.tuple(heightParam, null, 1,
                        unit: centimeter),
                  ],
                )
              ],
            ),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              ConversionUnitValueModel.tuple(japanClothSize, 3, null),
            ],
            expectedSrc: ConversionUnitValueModel.tuple(usaClothSize, 0, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(usaClothSize, 0, null),
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
                    ConversionParamValueModel.tuple(heightParam, null, 1,
                        unit: centimeter),
                  ],
                )
              ],
            ),
          );
        });
      });

      group('Some param values are not set', () {
        test('Source value is not empty', () async {
          await testCase(
            unitGroup: clothingSizeGroup,
            useCase: useCase,
            delta: ReplaceConversionItemUnitDelta(
              newUnit: usaClothSize,
              oldUnitId: europeanClothSize.id,
            ),
            currentSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
            currentParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(genderParam, null, null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, null, 1,
                        unit: centimeter),
                  ],
                )
              ],
            ),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, null, null),
              ConversionUnitValueModel.tuple(japanClothSize, null, null),
            ],
            expectedSrc:
                ConversionUnitValueModel.tuple(usaClothSize, 0, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(usaClothSize, 0, null),
              ConversionUnitValueModel.tuple(japanClothSize, null, null),
            ],
            expectedParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(genderParam, null, null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, null, 1,
                        unit: centimeter),
                  ],
                )
              ],
            ),
          );
        });

        test('Source value is empty', () async {
          await testCase(
            unitGroup: clothingSizeGroup,
            useCase: useCase,
            delta: ReplaceConversionItemUnitDelta(
              newUnit: usaClothSize,
              oldUnitId: europeanClothSize.id,
            ),
            currentSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, null, null),
            currentParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(genderParam, null, null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, null, 1,
                        unit: centimeter),
                  ],
                )
              ],
            ),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, null, null),
              ConversionUnitValueModel.tuple(japanClothSize, null, null),
            ],
            expectedSrc:
                ConversionUnitValueModel.tuple(usaClothSize, 0, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(usaClothSize, 0, null),
              ConversionUnitValueModel.tuple(japanClothSize, null, null),
            ],
            expectedParams: ConversionParamSetValueBulkModel(
              paramSetValues: [
                ConversionParamSetValueModel(
                  paramSet: clothingSizeParamSet,
                  paramValues: [
                    ConversionParamValueModel.tuple(genderParam, null, null),
                    ConversionParamValueModel.tuple(
                        garmentParam, "Shirt", null),
                    ConversionParamValueModel.tuple(heightParam, null, 1,
                        unit: centimeter),
                  ],
                )
              ],
            ),
          );
        });
      });
    });
  });
}
