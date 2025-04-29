import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_single_value_conversion_model.dart';
import 'package:convertouch/domain/use_cases/conversion/convert_single_value_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import '../../model/mock/mock_param.dart';
import '../../model/mock/mock_unit.dart';
import '../../model/mock/mock_unit_group.dart';

void main() {
  late ConvertSingleValueUseCase useCase;

  setUp(() {
    useCase = const ConvertSingleValueUseCase();
  });

  Future<void> testCase({
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel src,
    required ConversionParamSetValueModel? params,
    required ConversionUnitValueModel expectedTgt,
  }) async {
    expect(
      ObjectUtils.tryGet(
        await useCase.execute(
          InputSingleValueConversionModel(
            unitGroup: unitGroup,
            srcItem: src,
            tgtUnit: expectedTgt.unit,
            params: params,
          ),
        ),
      ).toJson(),
      expectedTgt.toJson(),
    );
  }

  Future<void> testCaseWithClothingSizeParams({
    required String? gender,
    required String? garment,
    required double? height,
    required double? defaultHeight,
    required ConversionUnitValueModel src,
    required ConversionUnitValueModel expectedTgt,
  }) async {
    await testCase(
      unitGroup: clothingSizeGroup,
      src: src,
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
      expectedTgt: expectedTgt,
    );
  }

  group('Convert a single value by coefficients', () {
    group('Convert to a different unit', () {
      test('Without params', () async {
        await testCase(
          unitGroup: lengthGroup,
          src: ConversionUnitValueModel.tuple(decimeter, 2.5, 1),
          params: null,
          expectedTgt: ConversionUnitValueModel.tuple(centimeter, 25, 10),
        );
      });
    });

    group('Convert to the same unit', () {
      test('Without params', () async {
        await testCase(
          unitGroup: lengthGroup,
          src: ConversionUnitValueModel.tuple(decimeter, 2.5, 1),
          params: null,
          expectedTgt: ConversionUnitValueModel.tuple(decimeter, 2.5, 1),
        );
      });
    });
  });

  group("Convert a single value by formula (clothing size)", () {
    group('Convert to a different unit', () {
      group('With params', () {
        test('All param values are set', () async {
          await testCaseWithClothingSizeParams(
            gender: "Male",
            garment: "Shirt",
            height: 150,
            defaultHeight: 1,
            src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            expectedTgt: ConversionUnitValueModel.tuple(japanSize, 3, null),
          );
        });

        test('All param values are set (default param value is set)', () async {
          await testCaseWithClothingSizeParams(
            gender: "Male",
            garment: "Shirt",
            height: null,
            defaultHeight: 1,
            src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            expectedTgt: ConversionUnitValueModel.tuple(japanSize, 3, null),
          );
        });

        group('Some param values are not set', () {
          test('Height param is not set', () async {
            await testCaseWithClothingSizeParams(
              gender: "Male",
              garment: "Shirt",
              height: null,
              defaultHeight: null,
              src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
              expectedTgt:
                  ConversionUnitValueModel.tuple(japanSize, null, null),
            );
          });

          test('Garment param is not set', () async {
            await testCaseWithClothingSizeParams(
              gender: "Male",
              garment: null,
              height: 150,
              defaultHeight: 1,
              src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
              expectedTgt:
                  ConversionUnitValueModel.tuple(japanSize, null, null),
            );
          });

          test('Gender param is not set', () async {
            await testCaseWithClothingSizeParams(
              gender: null,
              garment: "Shirt",
              height: 150,
              defaultHeight: 1,
              src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
              expectedTgt:
                  ConversionUnitValueModel.tuple(japanSize, null, null),
            );
          });
        });

        test('No param values are set', () async {
          await testCaseWithClothingSizeParams(
            gender: null,
            garment: null,
            height: null,
            defaultHeight: 1,
            src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            expectedTgt: ConversionUnitValueModel.tuple(japanSize, null, null),
          );
        });
      });
    });

    group('Convert to the same unit', () {
      group('With params', () {
        test('All param values are set', () async {
          await testCaseWithClothingSizeParams(
            gender: "Male",
            garment: "Shirt",
            height: 150,
            defaultHeight: 1,
            src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            expectedTgt: ConversionUnitValueModel.tuple(europeanSize, 32, null),
          );
        });

        test('All param values are set (default param value is set)', () async {
          await testCaseWithClothingSizeParams(
            gender: "Male",
            garment: "Shirt",
            height: null,
            defaultHeight: 1,
            src: ConversionUnitValueModel.tuple(europeanSize, 32, null),
            expectedTgt: ConversionUnitValueModel.tuple(europeanSize, 32, null),
          );
        });

        group('Some param values are not set', () {
          test('Height param is not set', () async {
            await testCaseWithClothingSizeParams(
              gender: "Male",
              garment: "Shirt",
              height: null,
              defaultHeight: null,
              src: ConversionUnitValueModel.tuple(europeanSize, null, null),
              expectedTgt:
                  ConversionUnitValueModel.tuple(europeanSize, null, null),
            );
          });

          test('Garment param is not set', () async {
            await testCaseWithClothingSizeParams(
              gender: "Male",
              garment: null,
              height: 150,
              defaultHeight: 1,
              src: ConversionUnitValueModel.tuple(europeanSize, null, null),
              expectedTgt:
                  ConversionUnitValueModel.tuple(europeanSize, null, null),
            );
          });

          test('Gender param is not set', () async {
            await testCaseWithClothingSizeParams(
              gender: null,
              garment: "Shirt",
              height: 150,
              defaultHeight: 1,
              src: ConversionUnitValueModel.tuple(europeanSize, null, null),
              expectedTgt:
                  ConversionUnitValueModel.tuple(europeanSize, null, null),
            );
          });
        });

        test('No param values are set', () async {
          await testCaseWithClothingSizeParams(
            gender: null,
            garment: null,
            height: null,
            defaultHeight: 1,
            src: ConversionUnitValueModel.tuple(europeanSize, null, null),
            expectedTgt:
                ConversionUnitValueModel.tuple(europeanSize, null, null),
          );
        });
      });
    });
  });
}
