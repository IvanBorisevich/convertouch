import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/replace_item_unit_use_case.dart';
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
      replaceUnitInConversionItemUseCase: ReplaceUnitInConversionItemUseCase(
        listValueRepository: ListValueRepositoryImpl(),
        calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
          dynamicValueRepository: MockDynamicValueRepository(),
          listValueRepository: ListValueRepositoryImpl(),
        ),
      ),
    );
  });

  group('Change unit in the conversion by coefficients', () {
    group('Without params', () {
      group('Source value is not empty', () {
        test('Should recalculate other values', () async {
          await testCase(
            useCase: useCase,
            delta: ReplaceConversionItemUnitDelta(
              newUnit: meter,
              oldUnitId: decimeter.id,
              recalculationMode: RecalculationOnUnitChange.otherValues,
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

        test('Should recalculate current value', () async {
          await testCase(
            useCase: useCase,
            delta: ReplaceConversionItemUnitDelta(
              newUnit: meter,
              oldUnitId: decimeter.id,
              recalculationMode: RecalculationOnUnitChange.currentValue,
            ),
            unitGroup: lengthGroup,
            currentSrc: ConversionUnitValueModel.tuple(decimeter, 10, 1),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(decimeter, 10, 1),
              ConversionUnitValueModel.tuple(centimeter, 100, 10),
            ],
            expectedSrc: ConversionUnitValueModel.tuple(meter, 1, 0.1),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(meter, 1, 0.1),
              ConversionUnitValueModel.tuple(centimeter, 100, 10),
            ],
          );
        });
      });

      group('Source default value is not empty', () {
        test('Should recalculate other values', () async {
          await testCase(
            useCase: useCase,
            delta: ReplaceConversionItemUnitDelta(
              newUnit: meter,
              oldUnitId: decimeter.id,
              recalculationMode: RecalculationOnUnitChange.otherValues,
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

        test('Should recalculate current value', () async {
          await testCase(
            useCase: useCase,
            delta: ReplaceConversionItemUnitDelta(
              newUnit: meter,
              oldUnitId: decimeter.id,
              recalculationMode: RecalculationOnUnitChange.currentValue,
            ),
            unitGroup: lengthGroup,
            currentSrc: ConversionUnitValueModel.tuple(decimeter, null, 1),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(decimeter, null, 1),
              ConversionUnitValueModel.tuple(centimeter, null, 10),
            ],
            expectedSrc: ConversionUnitValueModel.tuple(meter, null, 0.1),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(meter, null, 0.1),
              ConversionUnitValueModel.tuple(centimeter, null, 10),
            ],
          );
        });
      });

      group('Both source values are empty', () {
        test('Should recalculate other values', () async {
          await testCase(
            useCase: useCase,
            delta: ReplaceConversionItemUnitDelta(
              newUnit: meter,
              oldUnitId: decimeter.id,
              recalculationMode: RecalculationOnUnitChange.otherValues,
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

        test('Should recalculate current value', () async {
          await testCase(
            useCase: useCase,
            delta: ReplaceConversionItemUnitDelta(
              newUnit: meter,
              oldUnitId: decimeter.id,
              recalculationMode: RecalculationOnUnitChange.currentValue,
            ),
            unitGroup: lengthGroup,
            currentSrc: ConversionUnitValueModel.tuple(decimeter, null, null),
            currentUnitValues: [
              ConversionUnitValueModel.tuple(decimeter, null, null),
              ConversionUnitValueModel.tuple(centimeter, null, null),
            ],
            expectedSrc: ConversionUnitValueModel.tuple(meter, null, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(meter, null, null),
              ConversionUnitValueModel.tuple(centimeter, null, null),
            ],
          );
        });
      });
    });
  });

  group('Change unit in the conversion by formula', () {
    group('With params', () {
      group('All param values are set', () {
        group('Source value is not empty', () {
          test('Should recalculate other values', () async {
            await testCase(
              unitGroup: clothesSizeGroup,
              useCase: useCase,
              delta: ReplaceConversionItemUnitDelta(
                newUnit: usaClothSize,
                oldUnitId: europeanClothSize.id,
                recalculationMode: RecalculationOnUnitChange.otherValues,
              ),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothesSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, "Man", null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, 165, 1,
                          unit: centimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
              currentSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 44, null),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, 44, null),
                ConversionUnitValueModel.tuple(japanClothSize, 'M', null),
              ],
              expectedSrc:
                  ConversionUnitValueModel.tuple(usaClothSize, 2, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(usaClothSize, 2, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothesSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, "Man", null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, 165, 1,
                          unit: centimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
            );
          });

          test('Should recalculate current value', () async {
            await testCase(
              unitGroup: clothesSizeGroup,
              useCase: useCase,
              delta: ReplaceConversionItemUnitDelta(
                newUnit: usaClothSize,
                oldUnitId: europeanClothSize.id,
                recalculationMode: RecalculationOnUnitChange.currentValue,
              ),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothesSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, "Man", null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, 165, 1,
                          unit: centimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
              currentSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 44, null),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, 44, null),
                ConversionUnitValueModel.tuple(japanClothSize, 'M', null),
              ],
              expectedSrc:
                  ConversionUnitValueModel.tuple(usaClothSize, 30, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(usaClothSize, 30, null),
                ConversionUnitValueModel.tuple(japanClothSize, 'M', null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothesSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, "Man", null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, 165, 1,
                          unit: centimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
            );
          });
        });
      });

      group('All param values are set (default param value is set)', () {
        group('Source value is not empty', () {
          test('Should recalculate other values', () async {
            await testCase(
              unitGroup: clothesSizeGroup,
              useCase: useCase,
              delta: ReplaceConversionItemUnitDelta(
                newUnit: usaClothSize,
                oldUnitId: europeanClothSize.id,
                recalculationMode: RecalculationOnUnitChange.otherValues,
              ),
              currentSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 42, null),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothesSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, "Man", null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
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
                  ConversionUnitValueModel.tuple(usaClothSize, 42, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(usaClothSize, 42, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
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
                          unit: centimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
            );
          });

          test('Should recalculate current value', () async {
            await testCase(
              unitGroup: clothesSizeGroup,
              useCase: useCase,
              delta: ReplaceConversionItemUnitDelta(
                newUnit: usaClothSize,
                oldUnitId: europeanClothSize.id,
                recalculationMode: RecalculationOnUnitChange.currentValue,
              ),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothesSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, "Man", null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, null, 1,
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
                  ConversionUnitValueModel.tuple(usaClothSize, 28, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(usaClothSize, 28, null),
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
                          unit: centimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
            );
          });
        });
      });

      group('Some param values are not set', () {
        group('Source value is not empty', () {
          test('Should recalculate other values', () async {
            await testCase(
              unitGroup: clothesSizeGroup,
              useCase: useCase,
              delta: ReplaceConversionItemUnitDelta(
                newUnit: usaClothSize,
                oldUnitId: europeanClothSize.id,
                recalculationMode: RecalculationOnUnitChange.otherValues,
              ),
              currentSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothesSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, null, null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, null, 1,
                          unit: centimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, null, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
              expectedSrc:
                  ConversionUnitValueModel.tuple(usaClothSize, 2, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(usaClothSize, 2, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothesSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, null, null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, null, 1,
                          unit: centimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
            );
          });

          test('Should recalculate current value', () async {
            await testCase(
              unitGroup: clothesSizeGroup,
              useCase: useCase,
              delta: ReplaceConversionItemUnitDelta(
                newUnit: usaClothSize,
                oldUnitId: europeanClothSize.id,
                recalculationMode: RecalculationOnUnitChange.currentValue,
              ),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothesSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, null, null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, null, 1,
                          unit: centimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
              currentSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, null, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
              expectedSrc:
                  ConversionUnitValueModel.tuple(usaClothSize, null, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(usaClothSize, null, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothesSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, null, null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, null, 1,
                          unit: centimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
            );
          });
        });

        group('Source value is empty', () {
          test('Should recalculate other values', () async {
            await testCase(
              unitGroup: clothesSizeGroup,
              useCase: useCase,
              delta: ReplaceConversionItemUnitDelta(
                newUnit: usaClothSize,
                oldUnitId: europeanClothSize.id,
                recalculationMode: RecalculationOnUnitChange.otherValues,
              ),
              currentSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, null, null),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothesSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, null, null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, null, 1,
                          unit: centimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, null, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
              expectedSrc:
                  ConversionUnitValueModel.tuple(usaClothSize, 2, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(usaClothSize, 2, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothesSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, null, null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, null, 1,
                          unit: centimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
            );
          });

          test('Should recalculate current value', () async {
            await testCase(
              unitGroup: clothesSizeGroup,
              useCase: useCase,
              delta: ReplaceConversionItemUnitDelta(
                newUnit: usaClothSize,
                oldUnitId: europeanClothSize.id,
                recalculationMode: RecalculationOnUnitChange.currentValue,
              ),
              currentParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothesSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, null, null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, null, 1,
                          unit: centimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
              currentSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, null, null),
              currentUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, null, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
              expectedSrc:
                  ConversionUnitValueModel.tuple(usaClothSize, null, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(usaClothSize, null, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
              expectedParams: ConversionParamSetValueBulkModel(
                paramSetValues: [
                  ConversionParamSetValueModel(
                    paramSet: clothesSizeParamSet,
                    paramValues: [
                      ConversionParamValueModel.tuple(personParam, null, null),
                      ConversionParamValueModel.tuple(
                          garmentParam, "Shirt", null),
                      ConversionParamValueModel.tuple(heightParam, null, 1,
                          unit: centimeter),
                    ],
                  )
                ],
                selectedIndex: 0,
              ),
            );
          });
        });
      });
    });
  });
}
