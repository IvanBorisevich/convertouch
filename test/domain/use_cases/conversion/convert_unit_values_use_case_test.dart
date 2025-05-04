import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/use_cases/conversion/convert_unit_values_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';

void main() {
  late ConvertUnitValuesUseCase useCase;

  setUp(() {
    useCase = const ConvertUnitValuesUseCase();
  });

  Future<void> testCase({
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel src,
    required List<UnitModel> tgtUnits,
    required List<ConversionUnitValueModel> expectedUnitValues,
    required ConversionParamSetValueModel? params,
  }) async {
    var actualUnitValues = ObjectUtils.tryGet(
      await useCase.execute(
        InputConversionModel(
          unitGroup: unitGroup,
          sourceUnitValue: src,
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
    required ConversionUnitValueModel src,
    required List<UnitModel> tgtUnits,
    required String? gender,
    required String? garment,
    required double? height,
    required double? defaultHeight,
    required List<ConversionUnitValueModel> expectedUnitValues,
  }) async {
    await testCase(
      unitGroup: unitGroup,
      src: src,
      tgtUnits: tgtUnits,
      expectedUnitValues: expectedUnitValues,
      params: ConversionParamSetValueModel(
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
    );
  }

  group('Convert unit values by coefficients', () {
    group('Without params', () {
      test('Source unit values exist', () async {
        await testCase(
          unitGroup: lengthGroup,
          src: ConversionUnitValueModel.tuple(decimeter, 10, 1),
          params: null,
          tgtUnits: const [
            decimeter,
            centimeter,
            kilometer,
          ],
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(decimeter, 10, 1),
            ConversionUnitValueModel.tuple(centimeter, 100, 10),
            ConversionUnitValueModel.tuple(kilometer, 0.001, 0.0001),
          ],
        );
      });

      test('Source unit default value only exists', () async {
        await testCase(
          unitGroup: lengthGroup,
          src: ConversionUnitValueModel.tuple(decimeter, null, 1),
          params: null,
          tgtUnits: const [
            centimeter,
            kilometer,
          ],
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(centimeter, null, 10),
            ConversionUnitValueModel.tuple(kilometer, null, 0.0001),
          ],
        );
      });

      test('Source unit values do not exist', () async {
        await testCase(
          unitGroup: lengthGroup,
          src: ConversionUnitValueModel.tuple(decimeter, null, null),
          params: null,
          tgtUnits: const [
            centimeter,
            kilometer,
          ],
          expectedUnitValues: [
            ConversionUnitValueModel.tuple(centimeter, null, null),
            ConversionUnitValueModel.tuple(kilometer, null, null),
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
            src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            tgtUnits: const [
              japanSize,
              italianSize,
            ],
            gender: "Male",
            garment: "Shirt",
            height: 150,
            defaultHeight: 1,
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(japanSize, 3, null),
              ConversionUnitValueModel.tuple(italianSize, 36, null),
            ],
          );
        });

        test('Source unit value does not exist', () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            src: ConversionUnitValueModel.tuple(europeanSize, null, null),
            tgtUnits: const [
              japanSize,
              italianSize,
            ],
            gender: "Male",
            garment: "Shirt",
            height: 150,
            defaultHeight: 1,
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(japanSize, null, null),
              ConversionUnitValueModel.tuple(italianSize, null, null),
            ],
          );
        });
      });

      group('All param values are set | default param value is set', () {
        test('Source unit value exists', () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            tgtUnits: const [
              japanSize,
              italianSize,
            ],
            gender: "Male",
            garment: "Shirt",
            height: null,
            defaultHeight: 1,
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(japanSize, 3, null),
              ConversionUnitValueModel.tuple(italianSize, 36, null),
            ],
          );
        });

        test('Source unit value does not exist', () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            src: ConversionUnitValueModel.tuple(europeanSize, null, null),
            tgtUnits: const [
              japanSize,
              italianSize,
            ],
            gender: "Male",
            garment: "Shirt",
            height: null,
            defaultHeight: 1,
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(japanSize, null, null),
              ConversionUnitValueModel.tuple(italianSize, null, null),
            ],
          );
        });
      });

      group('Some param values are not set', () {
        test('Source unit value exists', () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            tgtUnits: const [
              japanSize,
              italianSize,
            ],
            gender: "Male",
            garment: null,
            height: 150,
            defaultHeight: 1,
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(japanSize, null, null),
              ConversionUnitValueModel.tuple(italianSize, null, null),
            ],
          );
        });

        test('Source unit value does not exist', () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            src: ConversionUnitValueModel.tuple(europeanSize, null, null),
            tgtUnits: const [
              japanSize,
              italianSize,
            ],
            gender: null,
            garment: null,
            height: 150,
            defaultHeight: 1,
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(japanSize, null, null),
              ConversionUnitValueModel.tuple(italianSize, null, null),
            ],
          );
        });
      });

      group('No param values are set', () {
        test('Source unit value exists', () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            tgtUnits: const [
              japanSize,
              italianSize,
            ],
            gender: null,
            garment: null,
            height: null,
            defaultHeight: null,
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(japanSize, null, null),
              ConversionUnitValueModel.tuple(italianSize, null, null),
            ],
          );
        });

        test('Source unit value does not exist', () async {
          await testCaseWithClothingSizeParams(
            unitGroup: clothingSizeGroup,
            src: ConversionUnitValueModel.tuple(europeanSize, null, null),
            tgtUnits: const [
              japanSize,
              italianSize,
            ],
            gender: null,
            garment: null,
            height: null,
            defaultHeight: null,
            expectedUnitValues: [
              ConversionUnitValueModel.tuple(japanSize, null, null),
              ConversionUnitValueModel.tuple(italianSize, null, null),
            ],
          );
        });
      });
    });
  });
}
