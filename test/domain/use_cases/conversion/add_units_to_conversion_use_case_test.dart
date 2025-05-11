import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/add_units_to_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/convert_unit_values_use_case.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';
import '../../repositories/mock/mock_unit_repository.dart';
import 'helpers/helpers.dart';

void main() {
  late AddUnitsToConversionUseCase useCase;

  setUp(() {
    useCase = const AddUnitsToConversionUseCase(
      convertUnitValuesUseCase: ConvertUnitValuesUseCase(),
      calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
        dynamicValueRepository: MockDynamicValueRepository(),
      ),
      unitRepository: MockUnitRepository(),
      listValueRepository: ListValueRepositoryImpl(),
    );
  });

  group('By coefficients', () {
    group('Without params', () {
      test('Source item does not exist', () async {
        await testCase(
          useCase: useCase,
          delta: AddUnitsToConversionDelta(
            unitIds: [
              centimeter.id,
              kilometer.id,
              decimeter.id,
            ],
          ),
          unitGroup: lengthGroup,
          src: null,
          params: null,
          currentUnitValues: [],
          expectedSrc: ConversionUnitValueModel.tuple(centimeter, null, 1),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(centimeter, null, 1),
            ConversionUnitValueModel.tuple(kilometer, null, 0.00001),
            ConversionUnitValueModel.tuple(decimeter, null, 0.1),
          ],
        );
      });

      test('Source item value and default value exist', () async {
        await testCase(
          useCase: useCase,
          delta: AddUnitsToConversionDelta(
            unitIds: [
              centimeter.id,
              kilometer.id,
            ],
          ),
          unitGroup: lengthGroup,
          src: ConversionUnitValueModel.tuple(decimeter, 10, 1),
          params: null,
          currentUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, 10, 1),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(decimeter, 10, 1),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(centimeter, 100, 10),
            ConversionUnitValueModel.tuple(kilometer, 0.001, 0.0001),
            ConversionUnitValueModel.tuple(decimeter, 10, 1),
          ],
        );
      });

      test('Source item default value exists only', () async {
        await testCase(
          useCase: useCase,
          delta: AddUnitsToConversionDelta(
            unitIds: [
              centimeter.id,
              kilometer.id,
            ],
          ),
          unitGroup: lengthGroup,
          src: ConversionUnitValueModel.tuple(decimeter, null, 1),
          params: null,
          currentUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, null, 1),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(decimeter, null, 1),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(centimeter, null, 10),
            ConversionUnitValueModel.tuple(kilometer, null, 0.0001),
            ConversionUnitValueModel.tuple(decimeter, null, 1),
          ],
        );
      });

      test('Source item value exists only', () async {
        await testCase(
          useCase: useCase,
          delta: AddUnitsToConversionDelta(
            unitIds: [
              centimeter.id,
              kilometer.id,
            ],
          ),
          unitGroup: lengthGroup,
          src: ConversionUnitValueModel.tuple(decimeter, 10, null),
          params: null,
          currentUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, 10, null),
          ],
          expectedSrc: ConversionUnitValueModel.tuple(decimeter, 10, null),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(centimeter, 100, null),
            ConversionUnitValueModel.tuple(kilometer, 0.001, null),
            ConversionUnitValueModel.tuple(decimeter, 10, null),
          ],
        );
      });
    });
  });

  group('By formula', () {
    group('With params', () {
      group('All params are set', () {
        test('Source item does not exist', () async {
          await testCaseWithClothingSizeParams(
            useCase: useCase,
            delta: AddUnitsToConversionDelta(
              unitIds: [
                japanClothSize.id,
                italianClothSize.id,
              ],
            ),
            src: null,
            gender: "Male",
            garment: "Shirt",
            height: 150,
            defaultHeight: 1,
            currentUnitValues: [],
            expectedSrc:
                ConversionUnitValueModel.tuple(japanClothSize, 3, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(japanClothSize, 3, null),
              ConversionUnitValueModel.tuple(italianClothSize, 36, null),
            ],
          );
        });

        test(
            'Source item value and default value exist '
            '(default list value will be ignored)', () async {
          await testCaseWithClothingSizeParams(
            useCase: useCase,
            delta: AddUnitsToConversionDelta(
              unitIds: [
                japanClothSize.id,
                italianClothSize.id,
              ],
            ),
            src: ConversionUnitValueModel.tuple(europeanClothSize, 32, 32),
            gender: "Male",
            garment: "Shirt",
            height: 150,
            defaultHeight: 1,
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 32, 32),
            ],
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              ConversionUnitValueModel.tuple(japanClothSize, 3, null),
              ConversionUnitValueModel.tuple(italianClothSize, 36, null),
            ],
          );
        });

        test(
            'Source item default value exists only '
            '(default list value will be ignored)', () async {
          await testCaseWithClothingSizeParams(
            useCase: useCase,
            delta: AddUnitsToConversionDelta(
              unitIds: [
                japanClothSize.id,
                italianClothSize.id,
              ],
            ),
            src: ConversionUnitValueModel.tuple(europeanClothSize, null, 32),
            gender: "Male",
            garment: "Shirt",
            height: 150,
            defaultHeight: 1,
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, null, 32),
            ],
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, null, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, null, null),
              ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ConversionUnitValueModel.tuple(italianClothSize, null, null),
            ],
          );
        });

        test('Source item value exists only', () async {
          await testCaseWithClothingSizeParams(
            useCase: useCase,
            delta: AddUnitsToConversionDelta(
              unitIds: [
                japanClothSize.id,
                italianClothSize.id,
              ],
            ),
            src: ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
            gender: "Male",
            garment: "Shirt",
            height: 150,
            defaultHeight: 1,
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 32, null)
            ],
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              ConversionUnitValueModel.tuple(japanClothSize, 3, null),
              ConversionUnitValueModel.tuple(italianClothSize, 36, null),
            ],
          );
        });
      });

      group('Some params are set by default', () {
        test('Source item does not exist', () async {
          await testCaseWithClothingSizeParams(
            useCase: useCase,
            delta: AddUnitsToConversionDelta(
              unitIds: [
                japanClothSize.id,
                italianClothSize.id,
              ],
            ),
            src: null,
            gender: "Male",
            garment: "Shirt",
            height: null,
            defaultHeight: 1,
            currentUnitValues: [],
            expectedSrc:
                ConversionUnitValueModel.tuple(japanClothSize, 3, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(japanClothSize, 3, null),
              ConversionUnitValueModel.tuple(italianClothSize, 36, null),
            ],
          );
        });

        test(
            'Source item value and default value exist '
            '(default list value will be ignored)', () async {
          await testCaseWithClothingSizeParams(
            useCase: useCase,
            delta: AddUnitsToConversionDelta(
              unitIds: [
                japanClothSize.id,
                italianClothSize.id,
              ],
            ),
            src: ConversionUnitValueModel.tuple(europeanClothSize, 32, 32),
            gender: "Male",
            garment: "Shirt",
            height: null,
            defaultHeight: 1,
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 32, 32),
            ],
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              ConversionUnitValueModel.tuple(japanClothSize, 3, null),
              ConversionUnitValueModel.tuple(italianClothSize, 36, null),
            ],
          );
        });

        test(
            'Source item default value exists only '
            '(default list value will be ignored)', () async {
          await testCaseWithClothingSizeParams(
            useCase: useCase,
            delta: AddUnitsToConversionDelta(
              unitIds: [
                japanClothSize.id,
                italianClothSize.id,
              ],
            ),
            src: ConversionUnitValueModel.tuple(europeanClothSize, null, 32),
            gender: "Male",
            garment: "Shirt",
            height: null,
            defaultHeight: 1,
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, null, 32),
            ],
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, null, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, null, null),
              ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ConversionUnitValueModel.tuple(italianClothSize, null, null),
            ],
          );
        });

        test('Source item value exists only', () async {
          await testCaseWithClothingSizeParams(
            useCase: useCase,
            delta: AddUnitsToConversionDelta(
              unitIds: [
                japanClothSize.id,
                italianClothSize.id,
              ],
            ),
            src: ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
            gender: "Male",
            garment: "Shirt",
            height: null,
            defaultHeight: 1,
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
            ],
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              ConversionUnitValueModel.tuple(japanClothSize, 3, null),
              ConversionUnitValueModel.tuple(italianClothSize, 36, null),
            ],
          );
        });
      });

      group('Some params are not set', () {
        group('Optional params', () {
          test('Source item does not exist', () async {
            await testCaseWithRingSizeParams(
              useCase: useCase,
              delta: AddUnitsToConversionDelta(
                unitIds: [
                  usaRingSize.id,
                  frRingSize.id,
                ],
              ),
              src: null,
              diameter: null,
              defaultDiameter: null,
              calculated: false,
              currentUnitValues: [],
              expectedSrc: ConversionUnitValueModel.tuple(usaRingSize, 3, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(usaRingSize, 3, null),
                ConversionUnitValueModel.tuple(frRingSize, 44, null),
              ],
            );
          });

          test(
              'Source item value and default value exist '
              '(default list value will be ignored)', () async {
            await testCaseWithRingSizeParams(
              useCase: useCase,
              delta: AddUnitsToConversionDelta(
                unitIds: [
                  usaRingSize.id,
                  frRingSize.id,
                ],
              ),
              src: ConversionUnitValueModel.tuple(usaRingSize, 3.5, 3.5),
              diameter: null,
              defaultDiameter: null,
              calculated: false,
              currentUnitValues: [
                ConversionUnitValueModel.tuple(usaRingSize, 3.5, 3.5),
              ],
              expectedSrc:
                  ConversionUnitValueModel.tuple(usaRingSize, 3.5, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(usaRingSize, 3.5, null),
                ConversionUnitValueModel.tuple(frRingSize, null, null),
              ],
            );
          });

          test(
              'Source item default value exists only '
              '(default list value will be ignored)', () async {
            await testCaseWithRingSizeParams(
              useCase: useCase,
              delta: AddUnitsToConversionDelta(
                unitIds: [
                  usaRingSize.id,
                  frRingSize.id,
                ],
              ),
              src: ConversionUnitValueModel.tuple(usaRingSize, null, 3.5),
              diameter: null,
              defaultDiameter: null,
              calculated: false,
              currentUnitValues: [
                ConversionUnitValueModel.tuple(usaRingSize, null, 3.5),
              ],
              expectedSrc:
                  ConversionUnitValueModel.tuple(usaRingSize, null, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(usaRingSize, null, null),
                ConversionUnitValueModel.tuple(frRingSize, null, null),
              ],
            );
          });

          test('Source item value exists only', () async {
            await testCaseWithRingSizeParams(
              useCase: useCase,
              delta: AddUnitsToConversionDelta(
                unitIds: [
                  usaRingSize.id,
                  frRingSize.id,
                ],
              ),
              src: ConversionUnitValueModel.tuple(usaRingSize, 3.5, null),
              diameter: null,
              defaultDiameter: null,
              calculated: false,
              currentUnitValues: [
                ConversionUnitValueModel.tuple(usaRingSize, 3.5, null),
              ],
              expectedSrc:
                  ConversionUnitValueModel.tuple(usaRingSize, 3.5, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(usaRingSize, 3.5, null),
                ConversionUnitValueModel.tuple(frRingSize, null, null),
              ],
            );
          });
        });

        group('Mandatory params', () {
          test('Source item does not exist', () async {
            await testCaseWithClothingSizeParams(
              useCase: useCase,
              delta: AddUnitsToConversionDelta(
                unitIds: [
                  japanClothSize.id,
                  italianClothSize.id,
                ],
              ),
              src: null,
              gender: "Male",
              garment: null,
              height: 150,
              defaultHeight: 1,
              currentUnitValues: [],
              expectedSrc:
                  ConversionUnitValueModel.tuple(japanClothSize, null, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
                ConversionUnitValueModel.tuple(italianClothSize, null, null),
              ],
            );
          });

          test(
              'Source item value and default value exist '
              '(default list value will be ignored)', () async {
            await testCaseWithClothingSizeParams(
              useCase: useCase,
              delta: AddUnitsToConversionDelta(
                unitIds: [
                  japanClothSize.id,
                  italianClothSize.id,
                ],
              ),
              src: ConversionUnitValueModel.tuple(europeanClothSize, 32, 32),
              gender: null,
              garment: "Shirt",
              height: 150,
              defaultHeight: 1,
              currentUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, 32, 32),
              ],
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
                ConversionUnitValueModel.tuple(italianClothSize, null, null),
              ],
            );
          });

          test(
              'Source item default value exists only '
              '(default list value will be ignored)', () async {
            await testCaseWithClothingSizeParams(
              useCase: useCase,
              delta: AddUnitsToConversionDelta(
                unitIds: [
                  japanClothSize.id,
                  italianClothSize.id,
                ],
              ),
              src: ConversionUnitValueModel.tuple(europeanClothSize, null, 32),
              gender: null,
              garment: "Shirt",
              height: 150,
              defaultHeight: 1,
              currentUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, null, 32),
              ],
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, null, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, null, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
                ConversionUnitValueModel.tuple(italianClothSize, null, null),
              ],
            );
          });

          test('Source item value exists only', () async {
            await testCaseWithClothingSizeParams(
              useCase: useCase,
              delta: AddUnitsToConversionDelta(
                unitIds: [
                  japanClothSize.id,
                  italianClothSize.id,
                ],
              ),
              src: ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              gender: null,
              garment: "Shirt",
              height: 150,
              defaultHeight: 1,
              currentUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              ],
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
                ConversionUnitValueModel.tuple(italianClothSize, null, null),
              ],
            );
          });
        });
      });

      group('No params are set', () {
        test('Source item does not exist', () async {
          await testCaseWithClothingSizeParams(
            useCase: useCase,
            delta: AddUnitsToConversionDelta(
              unitIds: [
                japanClothSize.id,
                italianClothSize.id,
              ],
            ),
            src: null,
            gender: null,
            garment: null,
            height: null,
            defaultHeight: null,
            currentUnitValues: [],
            expectedSrc:
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ConversionUnitValueModel.tuple(italianClothSize, null, null),
            ],
          );
        });

        test(
            'Source item value and default value exist '
            '(default list value will be ignored)', () async {
          await testCaseWithClothingSizeParams(
            useCase: useCase,
            delta: AddUnitsToConversionDelta(
              unitIds: [
                japanClothSize.id,
                italianClothSize.id,
              ],
            ),
            src: ConversionUnitValueModel.tuple(europeanClothSize, 32, 32),
            gender: null,
            garment: null,
            height: null,
            defaultHeight: null,
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 32, 32),
            ],
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ConversionUnitValueModel.tuple(italianClothSize, null, null),
            ],
          );
        });

        test(
            'Source item default value exists only '
            '(default list value will be ignored)', () async {
          await testCaseWithClothingSizeParams(
            useCase: useCase,
            delta: AddUnitsToConversionDelta(
              unitIds: [
                japanClothSize.id,
                italianClothSize.id,
              ],
            ),
            src: ConversionUnitValueModel.tuple(europeanClothSize, null, 32),
            gender: null,
            garment: null,
            height: null,
            defaultHeight: null,
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, null, 32),
            ],
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, null, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, null, null),
              ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ConversionUnitValueModel.tuple(italianClothSize, null, null),
            ],
          );
        });

        test('Source item value exists only', () async {
          await testCaseWithClothingSizeParams(
            useCase: useCase,
            delta: AddUnitsToConversionDelta(
              unitIds: [
                japanClothSize.id,
                italianClothSize.id,
              ],
            ),
            src: ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
            gender: null,
            garment: null,
            height: null,
            defaultHeight: null,
            currentUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
            ],
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ConversionUnitValueModel.tuple(italianClothSize, null, null),
            ],
          );
        });
      });
    });
  });
}
