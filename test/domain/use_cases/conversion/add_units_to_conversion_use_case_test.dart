import 'package:collection/collection.dart';
import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/add_units_to_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/convert_unit_values_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';
import '../../repositories/mock/mock_dynamic_value_repository.dart';
import '../../repositories/mock/mock_unit_repository.dart';

void main() {
  late AddUnitsToConversionUseCase useCase;

  setUp(() {
    useCase = const AddUnitsToConversionUseCase(
      convertUnitValuesUseCase: ConvertUnitValuesUseCase(),
      calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
        dynamicValueRepository: MockDynamicValueRepository(),
        listValueRepository: ListValueRepositoryImpl(),
      ),
      unitRepository: MockUnitRepository(),
    );
  });

  Future<void> testCase({
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel? src,
    required List<ConversionUnitValueModel> currentUnitValues,
    required List<ConversionUnitValueModel> expectedUnitValues,
    required ConversionUnitValueModel? expectedSrc,
    required List<int> newUnitIds,
    required ConversionParamSetValueBulkModel? params,
  }) async {
    ConversionModel actual = ObjectUtils.tryGet(
      await useCase.execute(
        InputConversionModifyModel<AddUnitsToConversionDelta>(
          conversion: ConversionModel(
            unitGroup: unitGroup,
            srcUnitValue: src,
            convertedUnitValues: currentUnitValues,
            params: params,
          ),
          delta: AddUnitsToConversionDelta(
            unitIds: newUnitIds,
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
    required ConversionUnitValueModel? src,
    required List<int> newUnitIds,
    required List<ConversionUnitValueModel> currentUnitValues,
    required List<ConversionUnitValueModel> expectedUnitValues,
    required ConversionUnitValueModel? expectedSrc,
  }) async {
    await testCase(
      unitGroup: clothingSizeGroup,
      src: src,
      newUnitIds: newUnitIds,
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

  Future<void> testCaseWithRingSizeParams({
    required double? diameter,
    required double? defaultDiameter,
    required bool calculated,
    required ConversionUnitValueModel? src,
    required List<int> newUnitIds,
    required List<ConversionUnitValueModel> currentUnitValues,
    required List<ConversionUnitValueModel> expectedUnitValues,
    required ConversionUnitValueModel? expectedSrc,
  }) async {
    await testCase(
      unitGroup: ringSizeGroup,
      src: src,
      newUnitIds: newUnitIds,
      currentUnitValues: currentUnitValues,
      expectedUnitValues: expectedUnitValues,
      expectedSrc: expectedSrc,
      params: ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: ringSizeByDiameterParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(
                diameterParam,
                diameter,
                defaultDiameter,
                unit: millimeter,
                calculated: calculated,
              ),
            ],
          ),
        ],
      ),
    );
  }

  group('Add units to the conversion by coefficients', () {
    group('Without params', () {
      test('Source unit values do not exist', () async {
        await testCase(
          unitGroup: lengthGroup,
          src: null,
          params: null,
          newUnitIds: [
            centimeter.id,
            kilometer.id,
            decimeter.id,
          ],
          currentUnitValues: [],
          expectedSrc: ConversionUnitValueModel.tuple(centimeter, null, 1),
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(centimeter, null, 1),
            ConversionUnitValueModel.tuple(kilometer, null, 0.00001),
            ConversionUnitValueModel.tuple(decimeter, null, 0.1),
          ],
        );
      });

      test('Add duplicated or already used units', () async {
        await testCase(
          unitGroup: lengthGroup,
          src: ConversionUnitValueModel.tuple(decimeter, 10, 1),
          params: null,
          newUnitIds: [
            centimeter.id,
            kilometer.id,
            decimeter.id,
            kilometer.id,
          ],
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

      test('Source unit default value exists', () async {
        await testCase(
          unitGroup: lengthGroup,
          src: ConversionUnitValueModel.tuple(decimeter, null, 1),
          params: null,
          newUnitIds: [
            centimeter.id,
            kilometer.id,
          ],
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

      test('Source unit values exist', () async {
        await testCase(
          unitGroup: lengthGroup,
          src: ConversionUnitValueModel.tuple(decimeter, 10, 1),
          params: null,
          newUnitIds: [
            centimeter.id,
            kilometer.id,
          ],
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
    });

    group('With params', () {
      group('Source unit values do not exist', () {
        test('Param is set', () async {
          await testCaseWithRingSizeParams(
            src: null,
            diameter: 15,
            defaultDiameter: 1,
            calculated: false,
            newUnitIds: [
              usaRingSize.id,
              frRingSize.id,
            ],
            currentUnitValues: [],
            expectedSrc: ConversionUnitValueModel.tuple(usaRingSize, 4, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(usaRingSize, 4, null),
              ConversionUnitValueModel.tuple(frRingSize, 46.5, null),
            ],
          );
        });

        test('''Param is not set 
          (for optional params default ring sizes should be set)''', () async {
          await testCaseWithRingSizeParams(
            src: null,
            diameter: null,
            defaultDiameter: null,
            calculated: false,
            newUnitIds: [
              usaRingSize.id,
              frRingSize.id,
            ],
            currentUnitValues: [],
            expectedSrc: ConversionUnitValueModel.tuple(usaRingSize, 3, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(usaRingSize, 3, null),
              ConversionUnitValueModel.tuple(frRingSize, 44, null),
            ],
          );
        });
      });

      group('Source unit default value exists', () {
        test('Param is set', () async {
          await testCaseWithRingSizeParams(
            src: ConversionUnitValueModel.tuple(usaRingSize, null, 3),
            diameter: 14,
            defaultDiameter: 1,
            calculated: false,
            newUnitIds: [
              usaRingSize.id,
              frRingSize.id,
            ],
            currentUnitValues: [
              ConversionUnitValueModel.tuple(usaRingSize, null, 3),
            ],
            expectedSrc: ConversionUnitValueModel.tuple(usaRingSize, 3, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(usaRingSize, 3, null),
              ConversionUnitValueModel.tuple(frRingSize, 44, null),
            ],
          );
        });

        test('Param is not set', () async {
          await testCaseWithRingSizeParams(
            src: ConversionUnitValueModel.tuple(usaRingSize, null, 3.5),
            diameter: null,
            defaultDiameter: null,
            calculated: false,
            newUnitIds: [
              usaRingSize.id,
              frRingSize.id,
            ],
            currentUnitValues: [
              ConversionUnitValueModel.tuple(usaRingSize, null, 3.5),
            ],
            expectedSrc: ConversionUnitValueModel.tuple(usaRingSize, 3.5, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(usaRingSize, 3.5, null),
              ConversionUnitValueModel.tuple(frRingSize, null, null),
            ],
          );
        });
      });

      group('Source unit values exist', () {

      });
    });
  });

  group('Add units to the conversion by formula', () {
    group('With params', () {
      group('All param values are set', () {
        test('Source unit value does not exist', () async {
          await testCaseWithClothingSizeParams(
            src: null,
            gender: "Male",
            garment: "Shirt",
            height: 150,
            defaultHeight: 1,
            newUnitIds: [
              japanClothSize.id,
              italianClothSize.id,
            ],
            currentUnitValues: [],
            expectedSrc:
                ConversionUnitValueModel.tuple(japanClothSize, 3, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(japanClothSize, 3, null),
              ConversionUnitValueModel.tuple(italianClothSize, 36, null),
            ],
          );
        });

        test('Source unit value exists', () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
            gender: "Male",
            garment: "Shirt",
            height: 150,
            defaultHeight: 1,
            newUnitIds: [
              japanClothSize.id,
              italianClothSize.id,
            ],
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

        test('Add duplicated or already used units', () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
            gender: "Male",
            garment: "Shirt",
            height: 150,
            defaultHeight: 1,
            newUnitIds: [
              japanClothSize.id,
              italianClothSize.id,
              italianClothSize.id,
              europeanClothSize.id,
            ],
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

        test('Source unit value exists (list default value is ignored)',
            () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanClothSize, 32, 32),
            gender: "Male",
            garment: "Shirt",
            height: 150,
            defaultHeight: 1,
            newUnitIds: [
              japanClothSize.id,
              italianClothSize.id,
            ],
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
      });

      group('All param values are set (default param value is set)', () {
        test('Source unit value does not exist', () async {
          await testCaseWithClothingSizeParams(
            src: null,
            gender: "Male",
            garment: "Shirt",
            height: null,
            defaultHeight: 1,
            newUnitIds: [
              japanClothSize.id,
              italianClothSize.id,
            ],
            currentUnitValues: [],
            expectedSrc:
                ConversionUnitValueModel.tuple(japanClothSize, 3, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(japanClothSize, 3, null),
              ConversionUnitValueModel.tuple(italianClothSize, 36, null),
            ],
          );
        });

        test('Source unit value exists', () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
            gender: "Male",
            garment: "Shirt",
            height: null,
            defaultHeight: 1,
            newUnitIds: [
              japanClothSize.id,
              italianClothSize.id,
            ],
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

        test('Source unit value exists (list default value is ignored)',
            () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanClothSize, 32, 32),
            gender: "Male",
            garment: "Shirt",
            height: null,
            defaultHeight: 1,
            newUnitIds: [
              japanClothSize.id,
              italianClothSize.id,
            ],
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
      });

      group('Some param values are not set', () {
        test('Source unit value does not exist', () async {
          await testCaseWithClothingSizeParams(
            src: null,
            gender: "Male",
            garment: null,
            height: 150,
            defaultHeight: 1,
            newUnitIds: [
              japanClothSize.id,
              italianClothSize.id,
            ],
            currentUnitValues: [],
            expectedSrc:
                ConversionUnitValueModel.tuple(japanClothSize, 3, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(japanClothSize, 3, null),
              ConversionUnitValueModel.tuple(italianClothSize, null, null),
            ],
          );
        });

        test('Source unit value exists', () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
            gender: null,
            garment: "Shirt",
            height: 150,
            defaultHeight: 1,
            newUnitIds: [
              japanClothSize.id,
              italianClothSize.id,
            ],
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

        test('Source unit value exists (list default value is ignored)',
            () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanClothSize, 32, 32),
            gender: null,
            garment: "Shirt",
            height: 150,
            defaultHeight: 1,
            newUnitIds: [
              japanClothSize.id,
              italianClothSize.id,
            ],
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
      });

      group('No param values are set', () {
        test('Source unit value does not exist', () async {
          await testCaseWithClothingSizeParams(
            src: null,
            gender: null,
            garment: null,
            height: null,
            defaultHeight: null,
            newUnitIds: [
              japanClothSize.id,
              italianClothSize.id,
            ],
            currentUnitValues: [],
            expectedSrc:
                ConversionUnitValueModel.tuple(japanClothSize, 3, null),
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(japanClothSize, 3, null),
              ConversionUnitValueModel.tuple(italianClothSize, null, null),
            ],
          );
        });

        test('Source unit value exists', () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanClothSize, 32, null),
            gender: null,
            garment: null,
            height: null,
            defaultHeight: null,
            newUnitIds: [
              japanClothSize.id,
              italianClothSize.id,
            ],
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

        test('Source unit value exists (list default value is ignored)',
            () async {
          await testCaseWithClothingSizeParams(
            src: ConversionUnitValueModel.tuple(europeanClothSize, 32, 32),
            gender: null,
            garment: null,
            height: null,
            defaultHeight: null,
            newUnitIds: [
              japanClothSize.id,
              italianClothSize.id,
            ],
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
      });
    });
  });
}
