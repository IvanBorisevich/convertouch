import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/conversion/convert_single_value_use_case.dart'
    show ConvertSingleValueUseCase;
import 'package:convertouch/domain/use_cases/conversion/convert_unit_values_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';

void main() {
  late ConvertUnitValuesUseCase useCase;

  setUp(() {
    useCase = const ConvertUnitValuesUseCase(
      convertSingleValueUseCase: ConvertSingleValueUseCase(),
    );
  });

  Future<void> testCase({
    required UnitGroupModel unitGroup,
    required UnitModel srcUnit,
    required ValueModel? srcValue,
    required ValueModel? srcDefaultValue,
    required List<UnitModel> tgtUnits,
    required List<ConversionUnitValueModel> expectedUnitValues,
    required ConversionParamSetValueModel? params,
  }) async {
    var actualUnitValues = ObjectUtils.tryGet(
      await useCase.execute(
        InputConversionModel(
          unitGroup: unitGroup,
          sourceUnitValue: ConversionUnitValueModel(
            unit: srcUnit,
            value: srcValue,
            defaultValue: srcDefaultValue,
          ),
          targetUnits: tgtUnits,
          params: params,
        ),
      ),
    );

    expect(
      actualUnitValues.sortedBy((e) => e.name),
      expectedUnitValues.sortedBy((e) => e.name),
    );
  }

  Future<void> testCaseWithClothingSizeParams({
    required UnitGroupModel unitGroup,
    required UnitModel srcUnit,
    required ValueModel? srcValue,
    required ValueModel? srcDefaultValue,
    required List<UnitModel> tgtUnits,
    required ValueModel? gender,
    required ValueModel? garment,
    required ValueModel? height,
    required ValueModel? defaultHeight,
    required List<ConversionUnitValueModel> expectedUnitValues,
  }) async {
    await testCase(
      unitGroup: unitGroup,
      srcUnit: srcUnit,
      srcValue: srcValue,
      srcDefaultValue: srcDefaultValue,
      tgtUnits: tgtUnits,
      expectedUnitValues: expectedUnitValues,
      params: ConversionParamSetValueModel(
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
    );
  }

  group('Convert unit values by coefficients', () {
    group('Without params', () {
      test('Source unit values exist', () async {
        await testCase(
          unitGroup: lengthGroup,
          srcUnit: decimeter,
          srcValue: ValueModel.numeric(10),
          srcDefaultValue: ValueModel.one,
          params: null,
          tgtUnits: const [
            decimeter,
            centimeter,
            kilometer,
          ],
          expectedUnitValues: [
            ConversionUnitValueModel(
              unit: decimeter,
              value: ValueModel.numeric(10),
              defaultValue: ValueModel.one,
            ),
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
          ],
        );
      });

      test('Source unit default value only exists', () async {
        await testCase(
          unitGroup: lengthGroup,
          srcUnit: decimeter,
          srcValue: null,
          srcDefaultValue: ValueModel.one,
          params: null,
          tgtUnits: const [
            centimeter,
            kilometer,
          ],
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
          ],
        );
      });

      test('Source unit values do not exist', () async {
        await testCase(
          unitGroup: lengthGroup,
          srcUnit: decimeter,
          srcValue: null,
          srcDefaultValue: null,
          params: null,
          tgtUnits: const [
            centimeter,
            kilometer,
          ],
          expectedUnitValues: [
            const ConversionUnitValueModel(
              unit: centimeter,
            ),
            const ConversionUnitValueModel(
              unit: kilometer,
            ),
          ],
        );
      });
    });
  });

  group('Convert values by formula', () {
    group('With params', () {
      group('All param values are set', () {
        test('Source unit value exists', () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            srcUnit: europeanSize,
            srcValue: ValueModel.numeric(32),
            srcDefaultValue: null,
            tgtUnits: const [
              japanSize,
              italianSize,
            ],
            gender: ValueModel.str("Male"),
            garment: ValueModel.str("Shirt"),
            height: ValueModel.numeric(150),
            defaultHeight: ValueModel.one,
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

        test('Source unit value does not exist', () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            srcUnit: europeanSize,
            srcValue: null,
            srcDefaultValue: null,
            tgtUnits: const [
              japanSize,
              italianSize,
            ],
            gender: ValueModel.str("Male"),
            garment: ValueModel.str("Shirt"),
            height: ValueModel.numeric(150),
            defaultHeight: ValueModel.one,
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
      });

      group('All param values are set | default param value is set', () {
        test('Source unit value exists', () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            srcUnit: europeanSize,
            srcValue: ValueModel.numeric(32),
            srcDefaultValue: null,
            tgtUnits: const [
              japanSize,
              italianSize,
            ],
            gender: ValueModel.str("Male"),
            garment: ValueModel.str("Shirt"),
            height: null,
            defaultHeight: ValueModel.one,
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

        test('Source unit value does not exist', () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            srcUnit: europeanSize,
            srcValue: null,
            srcDefaultValue: null,
            tgtUnits: const [
              japanSize,
              italianSize,
            ],
            gender: ValueModel.str("Male"),
            garment: ValueModel.str("Shirt"),
            height: null,
            defaultHeight: ValueModel.one,
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
      });

      group('Some param values are not set', () {
        test('Source unit value exists', () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            srcUnit: europeanSize,
            srcValue: ValueModel.numeric(32),
            srcDefaultValue: null,
            tgtUnits: const [
              japanSize,
              italianSize,
            ],
            gender: ValueModel.str("Male"),
            garment: null,
            height: ValueModel.numeric(150),
            defaultHeight: ValueModel.one,
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

        test('Source unit value does not exist', () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            srcUnit: europeanSize,
            srcValue: null,
            srcDefaultValue: null,
            tgtUnits: const [
              japanSize,
              italianSize,
            ],
            gender: null,
            garment: null,
            height: ValueModel.numeric(150),
            defaultHeight: ValueModel.one,
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
      });

      group('No param values are set', () {
        test('Source unit value exists', () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            srcUnit: europeanSize,
            srcValue: ValueModel.numeric(32),
            srcDefaultValue: null,
            tgtUnits: const [
              japanSize,
              italianSize,
            ],
            gender: null,
            garment: null,
            height: null,
            defaultHeight: null,
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

        test('Source unit value does not exist', () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            srcUnit: europeanSize,
            srcValue: null,
            srcDefaultValue: null,
            tgtUnits: const [
              japanSize,
              italianSize,
            ],
            gender: null,
            garment: null,
            height: null,
            defaultHeight: null,
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
      });
    });
  });
}
