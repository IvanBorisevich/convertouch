import 'package:collection/collection.dart';
import 'package:convertouch/data/repositories/local/list_value_repository_impl.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/conversion/add_units_to_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/convert_single_value_use_case.dart'
    show ConvertSingleValueUseCase;
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
      convertUnitValuesUseCase: ConvertUnitValuesUseCase(
        convertSingleValueUseCase: ConvertSingleValueUseCase(),
      ),
      calculateDefaultValueUseCase: CalculateDefaultValueUseCase(
        dynamicValueRepository: MockDynamicValueRepository(),
        listValueRepository: ListValueRepositoryImpl(),
      ),
      unitRepository: MockUnitRepository(),
    );
  });

  Future<void> testCase({
    required UnitGroupModel unitGroup,
    required UnitModel? srcUnit,
    required ValueModel? srcValue,
    required ValueModel? srcDefaultValue,
    required List<ConversionUnitValueModel> currentUnitValues,
    required List<ConversionUnitValueModel> expectedUnitValues,
    required ConversionUnitValueModel? expectedSrcUnitValue,
    required List<int> newUnitIds,
    required ConversionParamSetValueBulkModel? params,
  }) async {
    ConversionModel actual = ObjectUtils.tryGet(
      await useCase.execute(
        InputConversionModifyModel<AddUnitsToConversionDelta>(
          conversion: ConversionModel(
            unitGroup: unitGroup,
            srcUnitValue: srcUnit != null
                ? ConversionUnitValueModel(
                    unit: srcUnit,
                    value: srcValue,
                    defaultValue: srcDefaultValue,
                  )
                : null,
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
      srcUnitValue: expectedSrcUnitValue,
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
    required UnitGroupModel unitGroup,
    required UnitModel? srcUnit,
    required ValueModel? srcValue,
    required ValueModel? srcDefaultValue,
    required List<int> newUnitIds,
    required ValueModel? gender,
    required ValueModel? garment,
    required ValueModel? height,
    required ValueModel? defaultHeight,
    required List<ConversionUnitValueModel> currentUnitValues,
    required List<ConversionUnitValueModel> expectedUnitValues,
    required ConversionUnitValueModel? expectedSrcUnitValue,
  }) async {
    await testCase(
      unitGroup: unitGroup,
      srcUnit: srcUnit,
      srcValue: srcValue,
      srcDefaultValue: srcDefaultValue,
      newUnitIds: newUnitIds,
      currentUnitValues: currentUnitValues,
      expectedUnitValues: expectedUnitValues,
      expectedSrcUnitValue: expectedSrcUnitValue,
      params: ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: clothingSizeParamSet,
            paramValues: [
              ConversionParamValueModel(
                param: genderParam,
                value: gender,
              ),
              ConversionParamValueModel(
                param: garmentParam,
                value: garment,
              ),
              ConversionParamValueModel(
                param: heightParam,
                unit: centimeter,
                value: height,
                defaultValue: defaultHeight,
              ),
            ],
          ),
        ],
      ),
    );
  }

  group('Add units to the conversion by coefficients', () {
    group('Without params', () {
      test('Source unit does not exist (empty conversion)', () async {
        await testCase(
          unitGroup: lengthGroup,
          srcUnit: null,
          srcValue: null,
          srcDefaultValue: null,
          params: null,
          newUnitIds: [
            centimeter.id,
            kilometer.id,
            decimeter.id,
          ],
          currentUnitValues: [],
          expectedSrcUnitValue: const ConversionUnitValueModel(
            unit: centimeter,
            value: null,
            defaultValue: ValueModel.one,
          ),
          expectedUnitValues: [
            const ConversionUnitValueModel(
              unit: centimeter,
              value: null,
              defaultValue: ValueModel.one,
            ),
            ConversionUnitValueModel(
              unit: kilometer,
              value: null,
              defaultValue: ValueModel.numeric(0.00001),
            ),
            ConversionUnitValueModel(
              unit: decimeter,
              value: null,
              defaultValue: ValueModel.numeric(0.1),
            ),
          ],
        );
      });

      test('Source unit exists, default value exists', () async {
        await testCase(
          unitGroup: lengthGroup,
          srcUnit: decimeter,
          srcValue: null,
          srcDefaultValue: ValueModel.one,
          params: null,
          newUnitIds: [
            centimeter.id,
            kilometer.id,
          ],
          currentUnitValues: [
            const ConversionUnitValueModel(
              unit: decimeter,
              value: null,
              defaultValue: ValueModel.one,
            ),
          ],
          expectedSrcUnitValue: const ConversionUnitValueModel(
            unit: decimeter,
            value: null,
            defaultValue: ValueModel.one,
          ),
          expectedUnitValues: [
            ConversionUnitValueModel(
              unit: centimeter,
              value: null,
              defaultValue: ValueModel.numeric(10),
            ),
            ConversionUnitValueModel(
              unit: kilometer,
              value: null,
              defaultValue: ValueModel.numeric(0.0001),
            ),
            const ConversionUnitValueModel(
              unit: decimeter,
              value: null,
              defaultValue: ValueModel.one,
            ),
          ],
        );
      });

      test('Source unit exists, value exists, default value exists', () async {
        await testCase(
          unitGroup: lengthGroup,
          srcUnit: decimeter,
          srcValue: ValueModel.numeric(10),
          srcDefaultValue: ValueModel.one,
          params: null,
          newUnitIds: [
            centimeter.id,
            kilometer.id,
          ],
          currentUnitValues: [
            ConversionUnitValueModel(
              unit: decimeter,
              value: ValueModel.numeric(10),
              defaultValue: ValueModel.one,
            ),
          ],
          expectedSrcUnitValue: ConversionUnitValueModel(
            unit: decimeter,
            value: ValueModel.numeric(10),
            defaultValue: ValueModel.one,
          ),
          expectedUnitValues: [
            ConversionUnitValueModel(
              unit: centimeter,
              value: ValueModel.numeric(100),
              defaultValue: ValueModel.numeric(10),
            ),
            ConversionUnitValueModel(
              unit: kilometer,
              value: ValueModel.numeric(0.001),
              defaultValue: ValueModel.numeric(0.0001),
            ),
            ConversionUnitValueModel(
              unit: decimeter,
              value: ValueModel.numeric(10),
              defaultValue: ValueModel.one,
            ),
          ],
        );
      });
    });
  });

  group('Add units to the conversion by formula', () {
    group('With params', () {
      group('All param values are set', () {
        test('Source unit value does not exist', () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            srcUnit: null,
            srcValue: null,
            srcDefaultValue: null,
            gender: ValueModel.str("Male"),
            garment: ValueModel.str("Shirt"),
            height: ValueModel.numeric(150),
            defaultHeight: ValueModel.one,
            newUnitIds: [
              japanSize.id,
              italianSize.id,
            ],
            currentUnitValues: [],
            expectedSrcUnitValue: ConversionUnitValueModel(
              unit: japanSize,
              value: ValueModel.numeric(3),
            ),
            expectedUnitValues: [
              ConversionUnitValueModel(
                unit: japanSize,
                value: ValueModel.numeric(3),
              ),
              ConversionUnitValueModel(
                unit: italianSize,
                value: ValueModel.numeric(36),
              ),
            ],
          );
        });

        test('Source unit value exists', () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            srcUnit: europeanSize,
            srcValue: ValueModel.numeric(32),
            srcDefaultValue: null,
            gender: ValueModel.str("Male"),
            garment: ValueModel.str("Shirt"),
            height: ValueModel.numeric(150),
            defaultHeight: ValueModel.one,
            newUnitIds: [
              japanSize.id,
              italianSize.id,
            ],
            currentUnitValues: [
              ConversionUnitValueModel(
                unit: europeanSize,
                value: ValueModel.numeric(32),
              ),
            ],
            expectedSrcUnitValue: ConversionUnitValueModel(
              unit: europeanSize,
              value: ValueModel.numeric(32),
            ),
            expectedUnitValues: [
              ConversionUnitValueModel(
                unit: europeanSize,
                value: ValueModel.numeric(32),
              ),
              ConversionUnitValueModel(
                unit: japanSize,
                value: ValueModel.numeric(3),
              ),
              ConversionUnitValueModel(
                unit: italianSize,
                value: ValueModel.numeric(36),
              ),
            ],
          );
        });

        test('Source unit value exists (list default value is ignored)',
            () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            srcUnit: europeanSize,
            srcValue: ValueModel.numeric(32),
            srcDefaultValue: null,
            gender: ValueModel.str("Male"),
            garment: ValueModel.str("Shirt"),
            height: ValueModel.numeric(150),
            defaultHeight: ValueModel.one,
            newUnitIds: [
              japanSize.id,
              italianSize.id,
            ],
            currentUnitValues: [
              ConversionUnitValueModel(
                unit: europeanSize,
                value: ValueModel.numeric(32),
              ),
            ],
            expectedSrcUnitValue: ConversionUnitValueModel(
              unit: europeanSize,
              value: ValueModel.numeric(32),
            ),
            expectedUnitValues: [
              ConversionUnitValueModel(
                unit: europeanSize,
                value: ValueModel.numeric(32),
              ),
              ConversionUnitValueModel(
                unit: japanSize,
                value: ValueModel.numeric(3),
              ),
              ConversionUnitValueModel(
                unit: italianSize,
                value: ValueModel.numeric(36),
              ),
            ],
          );
        });
      });

      group('All param values are set (default param value is set)', () {
        test('Source unit value does not exist', () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            srcUnit: null,
            srcValue: null,
            srcDefaultValue: null,
            gender: ValueModel.str("Male"),
            garment: ValueModel.str("Shirt"),
            height: null,
            defaultHeight: ValueModel.one,
            newUnitIds: [
              japanSize.id,
              italianSize.id,
            ],
            currentUnitValues: [],
            expectedSrcUnitValue: ConversionUnitValueModel(
              unit: japanSize,
              value: ValueModel.numeric(3),
            ),
            expectedUnitValues: [
              ConversionUnitValueModel(
                unit: japanSize,
                value: ValueModel.numeric(3),
              ),
              ConversionUnitValueModel(
                unit: italianSize,
                value: ValueModel.numeric(36),
              ),
            ],
          );
        });

        test('Source unit value exists', () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            srcUnit: europeanSize,
            srcValue: ValueModel.numeric(32),
            srcDefaultValue: null,
            gender: ValueModel.str("Male"),
            garment: ValueModel.str("Shirt"),
            height: null,
            defaultHeight: ValueModel.one,
            newUnitIds: [
              japanSize.id,
              italianSize.id,
            ],
            currentUnitValues: [
              ConversionUnitValueModel(
                unit: europeanSize,
                value: ValueModel.numeric(32),
              ),
            ],
            expectedSrcUnitValue: ConversionUnitValueModel(
              unit: europeanSize,
              value: ValueModel.numeric(32),
            ),
            expectedUnitValues: [
              ConversionUnitValueModel(
                unit: europeanSize,
                value: ValueModel.numeric(32),
              ),
              ConversionUnitValueModel(
                unit: japanSize,
                value: ValueModel.numeric(3),
              ),
              ConversionUnitValueModel(
                unit: italianSize,
                value: ValueModel.numeric(36),
              ),
            ],
          );
        });

        test('Source unit value exists (list default value is ignored)',
            () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            srcUnit: europeanSize,
            srcValue: ValueModel.numeric(32),
            srcDefaultValue: ValueModel.numeric(32),
            gender: ValueModel.str("Male"),
            garment: ValueModel.str("Shirt"),
            height: null,
            defaultHeight: ValueModel.one,
            newUnitIds: [
              japanSize.id,
              italianSize.id,
            ],
            currentUnitValues: [
              ConversionUnitValueModel(
                unit: europeanSize,
                value: ValueModel.numeric(32),
              ),
            ],
            expectedSrcUnitValue: ConversionUnitValueModel(
              unit: europeanSize,
              value: ValueModel.numeric(32),
            ),
            expectedUnitValues: [
              ConversionUnitValueModel(
                unit: europeanSize,
                value: ValueModel.numeric(32),
              ),
              ConversionUnitValueModel(
                unit: japanSize,
                value: ValueModel.numeric(3),
              ),
              ConversionUnitValueModel(
                unit: italianSize,
                value: ValueModel.numeric(36),
              ),
            ],
          );
        });
      });

      group('Some param values are not set', () {
        test('Source unit value does not exist', () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            srcUnit: null,
            srcValue: null,
            srcDefaultValue: null,
            gender: ValueModel.str("Male"),
            garment: null,
            height: ValueModel.numeric(150),
            defaultHeight: ValueModel.one,
            newUnitIds: [
              japanSize.id,
              italianSize.id,
            ],
            currentUnitValues: [],
            expectedSrcUnitValue: const ConversionUnitValueModel(
              unit: japanSize,
            ),
            expectedUnitValues: [
              const ConversionUnitValueModel(
                unit: japanSize,
              ),
              const ConversionUnitValueModel(
                unit: italianSize,
              ),
            ],
          );
        });

        test('Source unit value exists', () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            srcUnit: europeanSize,
            srcValue: ValueModel.numeric(32),
            srcDefaultValue: null,
            gender: null,
            garment: ValueModel.str("Shirt"),
            height: ValueModel.numeric(150),
            defaultHeight: ValueModel.one,
            newUnitIds: [
              japanSize.id,
              italianSize.id,
            ],
            currentUnitValues: [
              ConversionUnitValueModel(
                unit: europeanSize,
                value: ValueModel.numeric(32),
              ),
            ],
            expectedSrcUnitValue: const ConversionUnitValueModel(
              unit: europeanSize,
            ),
            expectedUnitValues: [
              const ConversionUnitValueModel(
                unit: europeanSize,
              ),
              const ConversionUnitValueModel(
                unit: japanSize,
              ),
              const ConversionUnitValueModel(
                unit: italianSize,
              ),
            ],
          );
        });

        test('Source unit value exists (list default value is ignored)',
            () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            srcUnit: europeanSize,
            srcValue: ValueModel.numeric(32),
            srcDefaultValue: ValueModel.numeric(32),
            gender: ValueModel.str("Male"),
            garment: ValueModel.str("Shirt"),
            height: null,
            defaultHeight: null,
            newUnitIds: [
              japanSize.id,
              italianSize.id,
            ],
            currentUnitValues: [
              ConversionUnitValueModel(
                unit: europeanSize,
                value: ValueModel.numeric(32),
                defaultValue: ValueModel.numeric(32),
              ),
            ],
            expectedSrcUnitValue: const ConversionUnitValueModel(
              unit: europeanSize,
            ),
            expectedUnitValues: [
              const ConversionUnitValueModel(
                unit: europeanSize,
              ),
              const ConversionUnitValueModel(
                unit: japanSize,
              ),
              const ConversionUnitValueModel(
                unit: italianSize,
              ),
            ],
          );
        });
      });

      group('No param values are set', () {
        test('Source unit value does not exist', () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            srcUnit: null,
            srcValue: null,
            srcDefaultValue: null,
            gender: null,
            garment: null,
            height: null,
            defaultHeight: null,
            newUnitIds: [
              japanSize.id,
              italianSize.id,
            ],
            currentUnitValues: [],
            expectedSrcUnitValue: const ConversionUnitValueModel(
              unit: japanSize,
            ),
            expectedUnitValues: [
              const ConversionUnitValueModel(
                unit: japanSize,
              ),
              const ConversionUnitValueModel(
                unit: italianSize,
              ),
            ],
          );
        });

        test('Source unit value exists', () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            srcUnit: europeanSize,
            srcValue: ValueModel.numeric(32),
            srcDefaultValue: null,
            gender: null,
            garment: null,
            height: null,
            defaultHeight: null,
            newUnitIds: [
              japanSize.id,
              italianSize.id,
            ],
            currentUnitValues: [
              ConversionUnitValueModel(
                unit: europeanSize,
                value: ValueModel.numeric(32),
              ),
            ],
            expectedSrcUnitValue: const ConversionUnitValueModel(
              unit: europeanSize,
            ),
            expectedUnitValues: [
              const ConversionUnitValueModel(
                unit: europeanSize,
              ),
              const ConversionUnitValueModel(
                unit: japanSize,
              ),
              const ConversionUnitValueModel(
                unit: italianSize,
              ),
            ],
          );
        });

        test('Source unit value exists (list default value is ignored)',
            () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            srcUnit: europeanSize,
            srcValue: ValueModel.numeric(32),
            srcDefaultValue: ValueModel.numeric(32),
            gender: null,
            garment: null,
            height: null,
            defaultHeight: null,
            newUnitIds: [
              japanSize.id,
              italianSize.id,
            ],
            currentUnitValues: [
              ConversionUnitValueModel(
                unit: europeanSize,
                value: ValueModel.numeric(32),
                defaultValue: ValueModel.numeric(32),
              ),
            ],
            expectedSrcUnitValue: const ConversionUnitValueModel(
              unit: europeanSize,
            ),
            expectedUnitValues: [
              const ConversionUnitValueModel(
                unit: europeanSize,
              ),
              const ConversionUnitValueModel(
                unit: japanSize,
              ),
              const ConversionUnitValueModel(
                unit: italianSize,
              ),
            ],
          );
        });
      });
    });
  });
}
