import 'package:collection/collection.dart';
import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/convert_unit_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/edit_conversion_item_value_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';

void main() {
  late EditConversionItemValueUseCase useCase;

  setUp(() {
    useCase = const EditConversionItemValueUseCase(
      convertUnitValuesUseCase: ConvertUnitValuesUseCase(),
      calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
        dynamicValueRepository: MockDynamicValueRepository(),
        listValueRepository: ListValueRepositoryImpl(),
      ),
    );
  });

  Future<void> testCase({
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel src,
    required String? newValue,
    required String? newDefaultValue,
    required List<ConversionUnitValueModel> currentUnitValues,
    required List<ConversionUnitValueModel> expectedUnitValues,
    required ConversionUnitValueModel? expectedSrc,
    required ConversionParamSetValueBulkModel? params,
  }) async {
    ConversionModel actual = ObjectUtils.tryGet(
      await useCase.execute(
        InputConversionModifyModel<EditConversionItemValueDelta>(
          conversion: ConversionModel(
            unitGroup: unitGroup,
            srcUnitValue: src,
            convertedUnitValues: currentUnitValues,
            params: params,
          ),
          delta: EditConversionItemValueDelta(
            newValue: newValue,
            newDefaultValue: newDefaultValue,
            unitId: src.unit.id,
          ),
        ),
      ),
    );

    ConversionModel expected = ConversionModel(
      unitGroup: unitGroup,
      srcUnitValue: expectedSrc,
      convertedUnitValues: expectedUnitValues,
      params: params,
    );

    expect(actual.id, expected.id);
    expect(actual.name, expected.name);
    expect(actual.unitGroup, expected.unitGroup);
    expect(actual.srcUnitValue, expected.srcUnitValue);
    expect(actual.params, expected.params);
    expect(
      actual.convertedUnitValues.sortedBy((e) => e.name),
      expected.convertedUnitValues.sortedBy((e) => e.name),
    );
  }

  Future<void> testCaseWithClothingSizeParams({
    required String? gender,
    required String? garment,
    required double? height,
    required double? defaultHeight,
    required ConversionUnitValueModel src,
    required String? newValue,
    required String? newDefaultValue,
    required List<ConversionUnitValueModel> currentUnitValues,
    required List<ConversionUnitValueModel> expectedUnitValues,
    required ConversionUnitValueModel? expectedSrc,
  }) async {
    await testCase(
      unitGroup: clothingSizeGroup,
      src: src,
      newValue: newValue,
      newDefaultValue: newDefaultValue,
      currentUnitValues: currentUnitValues,
      expectedUnitValues: expectedUnitValues,
      expectedSrc: expectedSrc,
      params: ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: clothingSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(genderParam, gender, null),
              ConversionParamValueModel.tuple(garmentParam, garment, null),
              ConversionParamValueModel.tuple(
                heightParam,
                height,
                defaultHeight,
                unit: centimeter,
              ),
            ],
          ),
        ],
      ),
    );
  }

  group('Change value in the conversion by coefficients', () {
    var currentUnitValues = [
      ConversionUnitValueModel.tuple(decimeter, 10, 1),
      ConversionUnitValueModel.tuple(centimeter, 100, 10),
    ];

    group('Without params', () {
      test('New value is not empty', () async {
        await testCase(
          unitGroup: lengthGroup,
          src: ConversionUnitValueModel.tuple(decimeter, 10, 1),
          params: null,
          newValue: "2",
          newDefaultValue: null,
          currentUnitValues: currentUnitValues,
          expectedSrc: ConversionUnitValueModel.tuple(decimeter, 2, 1),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, 2, 1),
            ConversionUnitValueModel.tuple(centimeter, 20, 10),
          ],
        );
      });

      test('New default value is not empty', () async {
        await testCase(
          unitGroup: lengthGroup,
          src: ConversionUnitValueModel.tuple(decimeter, 10, 1),
          params: null,
          newValue: null,
          newDefaultValue: "2",
          currentUnitValues: currentUnitValues,
          expectedSrc: ConversionUnitValueModel.tuple(decimeter, null, 2),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, null, 2),
            ConversionUnitValueModel.tuple(centimeter, null, 20),
          ],
        );
      });

      test('Both new values are not empty', () async {
        await testCase(
          unitGroup: lengthGroup,
          src: ConversionUnitValueModel.tuple(decimeter, 10, 1),
          params: null,
          newValue: "2",
          newDefaultValue: "2",
          currentUnitValues: currentUnitValues,
          expectedSrc: ConversionUnitValueModel.tuple(decimeter, 2, 2),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, 2, 2),
            ConversionUnitValueModel.tuple(centimeter, 20, 20),
          ],
        );
      });

      test('Both new values are empty', () async {
        await testCase(
          unitGroup: lengthGroup,
          src: ConversionUnitValueModel.tuple(decimeter, 10, 2),
          params: null,
          newValue: null,
          newDefaultValue: null,
          currentUnitValues: currentUnitValues,
          expectedSrc: ConversionUnitValueModel.tuple(decimeter, null, 1),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, null, 1),
            ConversionUnitValueModel.tuple(centimeter, null, 10),
          ],
        );
      });
    });
  });

  group('Change value in the conversion by formula', () {
    var currentUnitValues = [
      ConversionUnitValueModel.tuple(europeanSize, 32, null),
      ConversionUnitValueModel.tuple(japanSize, 3, null),
    ];

    group('With params', () {
      group('All param values are set', () {
        test('New value is not empty', () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            gender: "Male",
            garment: "Shirt",
            height: 165,
            defaultHeight: 1,
            newValue: "34",
            newDefaultValue: "32",
            currentUnitValues: currentUnitValues,
            expectedSrc: ConversionUnitValueModel.tuple(europeanSize, 34, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanSize, 34, null),
              ConversionUnitValueModel.tuple(japanSize, 7, null),
            ],
          );
        });

        test(
          'New default value is not empty (for list param should be ignored)',
          () async {
            await testCaseWithClothingSizeParams(
              src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
              gender: "Male",
              garment: "Shirt",
              height: 165,
              defaultHeight: 1,
              newValue: null,
              newDefaultValue: "34",
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanSize, null, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanSize, null, null),
                ConversionUnitValueModel.tuple(japanSize, null, null),
              ],
            );
          },
        );

        test('Both new values are not empty', () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            gender: "Male",
            garment: "Shirt",
            height: 165,
            defaultHeight: 1,
            newValue: "34",
            newDefaultValue: "32",
            currentUnitValues: currentUnitValues,
            expectedSrc: ConversionUnitValueModel.tuple(europeanSize, 34, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanSize, 34, null),
              ConversionUnitValueModel.tuple(japanSize, 7, null),
            ],
          );
        });

        test('Both new values are empty', () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            gender: "Male",
            garment: "Shirt",
            height: 150,
            defaultHeight: 1,
            newValue: null,
            newDefaultValue: null,
            currentUnitValues: currentUnitValues,
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanSize, null, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanSize, null, null),
              ConversionUnitValueModel.tuple(japanSize, null, null),
            ],
          );
        });
      });

      group('All param values are set (default param value is set)', () {
        test('New value is not empty', () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            gender: "Male",
            garment: "Shirt",
            height: null,
            defaultHeight: 1,
            newValue: "34",
            newDefaultValue: "32",
            currentUnitValues: currentUnitValues,
            expectedSrc: ConversionUnitValueModel.tuple(europeanSize, 34, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanSize, 34, null),
              ConversionUnitValueModel.tuple(japanSize, null, null),
            ],
          );
        });

        test(
          'New default value is not empty (for list param should be ignored)',
          () async {
            await testCaseWithClothingSizeParams(
              src: ConversionUnitValueModel.tuple(europeanSize, 34, null),
              gender: "Male",
              garment: "Shirt",
              height: null,
              defaultHeight: 1,
              newValue: null,
              newDefaultValue: "32",
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanSize, null, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanSize, null, null),
                ConversionUnitValueModel.tuple(japanSize, null, null),
              ],
            );
          },
        );

        test('Both new values are not empty', () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanSize, 48, null),
            gender: "Male",
            garment: "Shirt",
            height: null,
            defaultHeight: 1,
            newValue: "32",
            newDefaultValue: "30",
            currentUnitValues: currentUnitValues,
            expectedSrc: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanSize, 32, null),
              ConversionUnitValueModel.tuple(japanSize, 3, null),
            ],
          );
        });

        test('Both new values are empty', () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            gender: "Male",
            garment: "Shirt",
            height: null,
            defaultHeight: 1,
            newValue: null,
            newDefaultValue: null,
            currentUnitValues: currentUnitValues,
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanSize, null, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanSize, null, null),
              ConversionUnitValueModel.tuple(japanSize, null, null),
            ],
          );
        });
      });

      group('Some param values are not set', () {
        test('New value is not empty', () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanSize, 34, null),
            gender: "Male",
            garment: null,
            height: null,
            defaultHeight: 1,
            newValue: "32",
            newDefaultValue: null,
            currentUnitValues: currentUnitValues,
            expectedSrc: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanSize, 32, null),
              ConversionUnitValueModel.tuple(japanSize, null, null),
            ],
          );
        });

        test(
          'New default value is not empty (for list param should be ignored)',
          () async {
            await testCaseWithClothingSizeParams(
              src: ConversionUnitValueModel.tuple(europeanSize, 34, null),
              gender: "Male",
              garment: null,
              height: null,
              defaultHeight: 1,
              newValue: null,
              newDefaultValue: "32",
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanSize, null, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanSize, null, null),
                ConversionUnitValueModel.tuple(japanSize, null, null),
              ],
            );
          },
        );

        test('Both new values are not empty', () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanSize, 34, null),
            gender: "Male",
            garment: null,
            height: null,
            defaultHeight: 1,
            newValue: "32",
            newDefaultValue: "30",
            currentUnitValues: currentUnitValues,
            expectedSrc: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanSize, 32, null),
              ConversionUnitValueModel.tuple(japanSize, null, null),
            ],
          );
        });

        test('Both new values are empty', () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanSize, 34, null),
            gender: "Male",
            garment: null,
            height: null,
            defaultHeight: 1,
            newValue: null,
            newDefaultValue: null,
            currentUnitValues: currentUnitValues,
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanSize, null, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanSize, null, null),
              ConversionUnitValueModel.tuple(japanSize, null, null),
            ],
          );
        });
      });

      group('No param values are set', () {
        test('New value is not empty', () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanSize, 34, null),
            gender: null,
            garment: null,
            height: null,
            defaultHeight: 1,
            newValue: "32",
            newDefaultValue: null,
            currentUnitValues: currentUnitValues,
            expectedSrc: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanSize, 32, null),
              ConversionUnitValueModel.tuple(japanSize, null, null),
            ],
          );
        });

        test(
          'New default value is not empty (for list param should be ignored)',
          () async {
            await testCaseWithClothingSizeParams(
              src: ConversionUnitValueModel.tuple(europeanSize, 34, null),
              gender: null,
              garment: null,
              height: null,
              defaultHeight: 1,
              newValue: null,
              newDefaultValue: "32",
              currentUnitValues: currentUnitValues,
              expectedSrc:
                  ConversionUnitValueModel.tuple(europeanSize, null, null),
              expectedUnitValues: [
                ConversionUnitValueModel.tuple(europeanSize, null, null),
                ConversionUnitValueModel.tuple(japanSize, null, null),
              ],
            );
          },
        );

        test('Both new values are not empty', () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanSize, 34, null),
            gender: null,
            garment: null,
            height: null,
            defaultHeight: 1,
            newValue: "32",
            newDefaultValue: "30",
            currentUnitValues: currentUnitValues,
            expectedSrc: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanSize, 32, null),
              ConversionUnitValueModel.tuple(japanSize, null, null),
            ],
          );
        });

        test('Both new values are empty', () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanSize, 34, null),
            gender: null,
            garment: null,
            height: null,
            defaultHeight: 1,
            newValue: null,
            newDefaultValue: null,
            currentUnitValues: currentUnitValues,
            expectedSrc:
                ConversionUnitValueModel.tuple(europeanSize, null, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(europeanSize, null, null),
              ConversionUnitValueModel.tuple(japanSize, null, null),
            ],
          );
        });
      });
    });
  });
}
