import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/convert_unit_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_item_value_use_case.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';
import 'helpers/helpers.dart';

void main() {
  late EditConversionItemValueUseCase useCase;

  setUp(() {
    useCase = const EditConversionItemValueUseCase(
      convertUnitValuesUseCase: ConvertUnitValuesUseCase(),
      calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
        dynamicValueRepository: MockDynamicValueRepository(),
      ),
    );
  });

  group('By coefficients', () {
    var currentUnitValues = [
      ConversionUnitValueModel.tuple(decimeter, 10, 1),
      ConversionUnitValueModel.tuple(centimeter, 100, 10),
    ];

    group('Without params', () {
      test('New source item value and default value do not exist', () async {
        await testCase(
          useCase: useCase,
          delta: EditConversionItemValueDelta(
            newValue: null,
            newDefaultValue: null,
            unitId: decimeter.id,
          ),
          unitGroup: lengthGroup,
          src: ConversionUnitValueModel.tuple(decimeter, 10, 1),
          params: null,
          currentUnitValues: currentUnitValues,
          expectedSrc: ConversionUnitValueModel.tuple(decimeter, null, 1),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, null, 1),
            ConversionUnitValueModel.tuple(centimeter, null, 10),
          ],
        );
      });

      test('New source item value and default value exist', () async {
        await testCase(
          useCase: useCase,
          delta: EditConversionItemValueDelta(
            newValue: '2',
            newDefaultValue: '2',
            unitId: decimeter.id,
          ),
          unitGroup: lengthGroup,
          src: ConversionUnitValueModel.tuple(decimeter, 10, 1),
          params: null,
          currentUnitValues: currentUnitValues,
          expectedSrc: ConversionUnitValueModel.tuple(decimeter, 2, 2),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, 2, 2),
            ConversionUnitValueModel.tuple(centimeter, 20, 20),
          ],
        );
      });

      test('New source item default value exists only', () async {
        await testCase(
          useCase: useCase,
          delta: EditConversionItemValueDelta(
            newValue: null,
            newDefaultValue: '2',
            unitId: decimeter.id,
          ),
          unitGroup: lengthGroup,
          src: ConversionUnitValueModel.tuple(decimeter, 10, 1),
          params: null,
          currentUnitValues: currentUnitValues,
          expectedSrc: ConversionUnitValueModel.tuple(decimeter, null, 2),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, null, 2),
            ConversionUnitValueModel.tuple(centimeter, null, 20),
          ],
        );
      });

      test('New source item value exists only', () async {
        await testCase(
          useCase: useCase,
          delta: EditConversionItemValueDelta(
            newValue: '2',
            newDefaultValue: null,
            unitId: decimeter.id,
          ),
          unitGroup: lengthGroup,
          src: ConversionUnitValueModel.tuple(decimeter, 10, 2),
          params: null,
          currentUnitValues: currentUnitValues,
          expectedSrc: ConversionUnitValueModel.tuple(decimeter, 2, 1),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, 2, 1),
            ConversionUnitValueModel.tuple(centimeter, 20, 10),
          ],
        );
      });
    });
  });

  group('By formula', () {
    var currentUnitValues = [
      ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
      ConversionUnitValueModel.tuple(japanClothSize, 3, null),
    ];

    group('With params', () {
      group('All params are set', () {
        group('Calculated params exist', () {
          test('New source item value and default value do not exist', () {});

          test(
            'New source item value and default value exist '
            '(default list value will be ignored)',
            () {},
          );

          test(
            'New source item default value exists only '
            '(default list value will be ignored)',
            () {},
          );

          test('New source item value exists only', () {});
        });

        group('Calculated params do not exist', () {
          test('New source item value and default value do not exist',
              () async {
            await testCaseWithClothingSizeParams(
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: null,
                newDefaultValue: null,
                unitId: europeanClothSize.id,
              ),
              src: ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              gender: "Male",
              garment: "Shirt",
              height: 150,
              defaultHeight: 1,
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, null, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, null, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
            );
          });

          test(
              'New source item value and default value exist '
              '(default list value will be ignored)', () async {
            await testCaseWithClothingSizeParams(
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: '34',
                newDefaultValue: '32',
                unitId: europeanClothSize.id,
              ),
              src: ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              gender: "Male",
              garment: "Shirt",
              height: 165,
              defaultHeight: 1,
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 34, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, 34, null),
                ConversionUnitValueModel.tuple(japanClothSize, 7, null),
              ],
            );
          });

          test(
              'New source item default value exists only '
              '(default list value will be ignored)', () async {
            await testCaseWithClothingSizeParams(
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: null,
                newDefaultValue: '34',
                unitId: europeanClothSize.id,
              ),
              src: ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              gender: "Male",
              garment: "Shirt",
              height: 165,
              defaultHeight: 1,
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, null, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, null, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
            );
          });

          test('New source item value exists only', () async {
            await testCaseWithClothingSizeParams(
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: '34',
                newDefaultValue: null,
                unitId: europeanClothSize.id,
              ),
              src: ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              gender: "Male",
              garment: "Shirt",
              height: 165,
              defaultHeight: 1,
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 34, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, 34, null),
                ConversionUnitValueModel.tuple(japanClothSize, 7, null),
              ],
            );
          });
        });
      });

      group('Some params are set by default', () {
        group('Calculated params exist', () {
          test('New source item value and default value do not exist', () {});

          test(
            'New source item value and default value exist '
            '(default list value will be ignored)',
            () {},
          );

          test(
            'New source item default value exists only '
            '(default list value will be ignored)',
            () {},
          );

          test('New source item value exists only', () {});
        });

        group('Calculated params do not exist', () {
          test('New source item value and default value do not exist',
              () async {
            await testCaseWithClothingSizeParams(
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: null,
                newDefaultValue: null,
                unitId: europeanClothSize.id,
              ),
              src: ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              gender: "Male",
              garment: "Shirt",
              height: null,
              defaultHeight: 1,
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, null, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, null, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
            );
          });

          test(
              'New source item value and default value exist '
              '(default list value will be ignored)', () async {
            await testCaseWithClothingSizeParams(
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: '34',
                newDefaultValue: '32',
                unitId: europeanClothSize.id,
              ),
              src: ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              gender: "Male",
              garment: "Shirt",
              height: null,
              defaultHeight: 1,
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 34, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, 34, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
            );
          });

          test(
              'New source item default value exists only '
              '(default list value will be ignored)', () async {
            await testCaseWithClothingSizeParams(
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: null,
                newDefaultValue: '32',
                unitId: europeanClothSize.id,
              ),
              src: ConversionUnitValueModel.tuple(europeanClothSize, 34, null),
              gender: "Male",
              garment: "Shirt",
              height: null,
              defaultHeight: 1,
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, null, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, null, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
            );
          });

          test('New source item value exists only', () async {
            await testCaseWithClothingSizeParams(
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: '34',
                newDefaultValue: null,
                unitId: europeanClothSize.id,
              ),
              src: ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              gender: "Male",
              garment: "Shirt",
              height: null,
              defaultHeight: 1,
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 34, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, 34, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
            );
          });
        });
      });

      group('Some params are not set', () {
        group('Optional params', () {
          group('Calculated params exist', () {
            test('New source item value and default value do not exist', () {});

            test(
              'New source item value and default value exist '
              '(default list value will be ignored)',
              () {},
            );

            test(
              'New source item default value exists only '
              '(default list value will be ignored)',
              () {},
            );

            test('New source item value exists only', () {});
          });

          group('Calculated params do not exist', () {
            test('New source item value and default value do not exist', () {});

            test(
              'New source item value and default value exist '
              '(default list value will be ignored)',
              () {},
            );

            test(
              'New source item default value exists only '
              '(default list value will be ignored)',
              () {},
            );

            test('New source item value exists only', () async {});
          });
        });

        group('Mandatory params', () {
          test('New source item value and default value do not exist',
              () async {
            await testCaseWithClothingSizeParams(
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: null,
                newDefaultValue: null,
                unitId: europeanClothSize.id,
              ),
              src: ConversionUnitValueModel.tuple(europeanClothSize, 34, null),
              gender: "Male",
              garment: null,
              height: null,
              defaultHeight: 1,
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, null, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, null, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
            );
          });

          test(
              'New source item value and default value exist '
              '(default list value will be ignored)', () async {
            await testCaseWithClothingSizeParams(
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: '32',
                newDefaultValue: '30',
                unitId: europeanClothSize.id,
              ),
              src: ConversionUnitValueModel.tuple(europeanClothSize, 34, null),
              gender: "Male",
              garment: null,
              height: null,
              defaultHeight: 1,
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
            );
          });

          test(
              'New source item default value exists only '
              '(default list value will be ignored)', () async {
            await testCaseWithClothingSizeParams(
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: null,
                newDefaultValue: '32',
                unitId: europeanClothSize.id,
              ),
              src: ConversionUnitValueModel.tuple(europeanClothSize, 34, null),
              gender: "Male",
              garment: null,
              height: null,
              defaultHeight: 1,
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, null, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, null, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
            );
          });

          test('New source item value exists only', () async {
            await testCaseWithClothingSizeParams(
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: '32',
                newDefaultValue: null,
                unitId: europeanClothSize.id,
              ),
              src: ConversionUnitValueModel.tuple(europeanClothSize, 34, null),
              gender: "Male",
              garment: null,
              height: null,
              defaultHeight: 1,
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
            );
          });
        });
      });

      group('No params are set', () {
        group('Optional params', () {
          group('Calculated params exist', () {
            test('New source item value and default value do not exist', () {});

            test(
              'New source item value and default value exist '
              '(default list value will be ignored)',
              () {},
            );

            test(
              'New source item default value exists only '
              '(default list value will be ignored)',
              () {},
            );

            test('New source item value exists only', () {});
          });

          group('Calculated params do not exist', () {
            test('New source item value and default value do not exist', () {});

            test(
              'New source item value and default value exist '
              '(default list value will be ignored)',
              () {},
            );

            test(
              'New source item default value exists only '
              '(default list value will be ignored)',
              () {},
            );

            test('New source item value exists only', () {});
          });
        });

        group('Mandatory params', () {
          test('New source item value and default value do not exist',
              () async {
            await testCaseWithClothingSizeParams(
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: null,
                newDefaultValue: null,
                unitId: europeanClothSize.id,
              ),
              src: ConversionUnitValueModel.tuple(europeanClothSize, 34, null),
              gender: null,
              garment: null,
              height: null,
              defaultHeight: 1,
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, null, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, null, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
            );
          });

          test(
              'New source item value and default value exist '
              '(default list value will be ignored)', () async {
            await testCaseWithClothingSizeParams(
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: '32',
                newDefaultValue: '30',
                unitId: europeanClothSize.id,
              ),
              src: ConversionUnitValueModel.tuple(europeanClothSize, 34, null),
              gender: null,
              garment: null,
              height: null,
              defaultHeight: 1,
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
            );
          });

          test(
              'New source item default value exists only '
              '(default list value will be ignored)', () async {
            await testCaseWithClothingSizeParams(
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: null,
                newDefaultValue: '32',
                unitId: europeanClothSize.id,
              ),
              src: ConversionUnitValueModel.tuple(europeanClothSize, 34, null),
              gender: null,
              garment: null,
              height: null,
              defaultHeight: 1,
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, null, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, null, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
            );
          });

          test('New source item value exists only', () async {
            await testCaseWithClothingSizeParams(
              useCase: useCase,
              delta: EditConversionItemValueDelta(
                newValue: '32',
                newDefaultValue: null,
                unitId: europeanClothSize.id,
              ),
              src: ConversionUnitValueModel.tuple(europeanClothSize, 34, null),
              gender: null,
              garment: null,
              height: null,
              defaultHeight: 1,
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
                ConversionUnitValueModel.tuple(japanClothSize, null, null),
              ],
            );
          });
        });
      });
    });
  });
}
