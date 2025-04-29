import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_single_value_conversion_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
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
    required UnitModel srcUnit,
    required ValueModel? srcValue,
    required ValueModel? srcDefaultValue,
    required ConversionParamSetValueModel? params,
    required UnitModel tgtUnit,
    required ValueModel? expectedTgtValue,
    required ValueModel? expectedTgtDefaultValue,
  }) async {
    expect(
      ObjectUtils.tryGet(
        await useCase.execute(
          InputSingleValueConversionModel(
            unitGroup: unitGroup,
            srcItem: ConversionUnitValueModel(
              unit: srcUnit,
              value: srcValue,
              defaultValue: srcDefaultValue,
            ),
            tgtUnit: tgtUnit,
            params: params,
          ),
        ),
      ).toJson(),
      ConversionUnitValueModel(
        unit: tgtUnit,
        value: expectedTgtValue,
        defaultValue: expectedTgtDefaultValue,
      ).toJson(),
    );
  }

  Future<void> testCaseWithClothingSizeParams({
    required UnitModel srcUnit,
    required ValueModel? srcSizeValue,
    required ValueModel? gender,
    required ValueModel? garment,
    required ValueModel? height,
    required ValueModel? defaultHeight,
    required UnitModel tgtUnit,
    required ValueModel? tgtSizeValue,
  }) async {
    await testCase(
      unitGroup: clothingSizeGroup,
      srcUnit: srcUnit,
      srcValue: srcSizeValue,
      srcDefaultValue: null,
      tgtUnit: tgtUnit,
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
      expectedTgtValue: tgtSizeValue,
      expectedTgtDefaultValue: null,
    );
  }

  group('Convert a single value by coefficients', () {
    group('Convert to a different unit', () {
      test('Without params', () async {
        await testCase(
          unitGroup: lengthGroup,
          srcUnit: decimeter,
          srcValue: ValueModel.numeric(2.5),
          srcDefaultValue: ValueModel.one,
          params: null,
          tgtUnit: centimeter,
          expectedTgtValue: ValueModel.numeric(25),
          expectedTgtDefaultValue: ValueModel.numeric(10),
        );
      });
    });

    group('Convert to the same unit', () {
      test('Without params', () async {
        await testCase(
          unitGroup: lengthGroup,
          srcUnit: decimeter,
          srcValue: ValueModel.numeric(2.5),
          srcDefaultValue: ValueModel.one,
          params: null,
          tgtUnit: decimeter,
          expectedTgtValue: ValueModel.numeric(2.5),
          expectedTgtDefaultValue: ValueModel.one,
        );
      });
    });
  });

  group("Convert a single value by formula (clothing size)", () {
    group('Convert to a different unit', () {
      group('With params', () {
        test('All param values are set', () async {
          await testCaseWithClothingSizeParams(
            srcUnit: europeanSize,
            srcSizeValue: ValueModel.numeric(32),
            gender: ValueModel.str("Male"),
            garment: ValueModel.str("Shirt"),
            height: ValueModel.numeric(150),
            defaultHeight: ValueModel.one,
            tgtUnit: japanSize,
            tgtSizeValue: ValueModel.numeric(3),
          );
        });

        test('All param values are set (default param value is set)', () async {
          await testCaseWithClothingSizeParams(
            srcUnit: europeanSize,
            srcSizeValue: ValueModel.numeric(32),
            gender: ValueModel.str("Male"),
            garment: ValueModel.str("Shirt"),
            height: null,
            defaultHeight: ValueModel.one,
            tgtUnit: japanSize,
            tgtSizeValue: ValueModel.numeric(3),
          );
        });

        group('Some param values are not set', () {
          test('Height param is not set', () async {
            await testCaseWithClothingSizeParams(
              srcUnit: europeanSize,
              srcSizeValue: ValueModel.numeric(32),
              gender: ValueModel.str("Male"),
              garment: ValueModel.str("Shirt"),
              height: null,
              defaultHeight: null,
              tgtUnit: japanSize,
              tgtSizeValue: null,
            );
          });

          test('Garment param is not set', () async {
            await testCaseWithClothingSizeParams(
              srcUnit: europeanSize,
              srcSizeValue: ValueModel.numeric(32),
              gender: ValueModel.str("Male"),
              garment: null,
              height: ValueModel.numeric(150),
              defaultHeight: ValueModel.one,
              tgtUnit: japanSize,
              tgtSizeValue: null,
            );
          });

          test('Gender param is not set', () async {
            await testCaseWithClothingSizeParams(
              srcUnit: europeanSize,
              srcSizeValue: ValueModel.numeric(32),
              gender: null,
              garment: ValueModel.str("Shirt"),
              height: ValueModel.numeric(150),
              defaultHeight: ValueModel.one,
              tgtUnit: japanSize,
              tgtSizeValue: null,
            );
          });
        });

        test('No param values are set', () async {
          await testCaseWithClothingSizeParams(
            srcUnit: europeanSize,
            srcSizeValue: ValueModel.numeric(32),
            gender: null,
            garment: null,
            height: null,
            defaultHeight: ValueModel.one,
            tgtUnit: japanSize,
            tgtSizeValue: null,
          );
        });
      });
    });

    group('Convert to the same unit', () {
      group('With params', () {
        test('All param values are set', () async {
          await testCaseWithClothingSizeParams(
            gender: ValueModel.str("Male"),
            garment: ValueModel.str("Shirt"),
            height: ValueModel.numeric(150),
            defaultHeight: ValueModel.one,
            srcUnit: europeanSize,
            srcSizeValue: ValueModel.numeric(32),
            tgtUnit: europeanSize,
            tgtSizeValue: ValueModel.numeric(32),
          );
        });

        test('All param values are set (default param value is set)', () async {
          await testCaseWithClothingSizeParams(
            gender: ValueModel.str("Male"),
            garment: ValueModel.str("Shirt"),
            height: null,
            defaultHeight: ValueModel.one,
            srcUnit: europeanSize,
            srcSizeValue: ValueModel.numeric(32),
            tgtUnit: europeanSize,
            tgtSizeValue: ValueModel.numeric(32),
          );
        });

        group('Some param values are not set', () {
          test('Height param is not set', () async {
            await testCaseWithClothingSizeParams(
              gender: ValueModel.str("Male"),
              garment: ValueModel.str("Shirt"),
              height: null,
              defaultHeight: null,
              srcUnit: europeanSize,
              srcSizeValue: null,
              tgtUnit: europeanSize,
              tgtSizeValue: null,
            );
          });

          test('Garment param is not set', () async {
            await testCaseWithClothingSizeParams(
              gender: ValueModel.str("Male"),
              garment: null,
              height: ValueModel.numeric(150),
              defaultHeight: ValueModel.one,
              srcUnit: europeanSize,
              srcSizeValue: null,
              tgtUnit: europeanSize,
              tgtSizeValue: null,
            );
          });

          test('Gender param is not set', () async {
            await testCaseWithClothingSizeParams(
              gender: null,
              garment: ValueModel.str("Shirt"),
              height: ValueModel.numeric(150),
              defaultHeight: ValueModel.one,
              srcUnit: europeanSize,
              srcSizeValue: null,
              tgtUnit: europeanSize,
              tgtSizeValue: null,
            );
          });
        });

        test('No param values are set', () async {
          await testCaseWithClothingSizeParams(
            gender: null,
            garment: null,
            height: null,
            defaultHeight: ValueModel.one,
            srcUnit: europeanSize,
            srcSizeValue: null,
            tgtUnit: europeanSize,
            tgtSizeValue: null,
          );
        });
      });
    });
  });
}
