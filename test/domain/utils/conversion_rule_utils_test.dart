import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/conversion_param_constants/clothing_size.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/conversion_rule.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/conversion_rule_utils.dart';
import 'package:test/test.dart';

import '../model/mock/mock_param.dart';
import '../model/mock/mock_unit.dart';

void main() {
  group('Convert by a formula rule', () {
    group('Without parameters', () {
      test(
        'Two-way conversion (e. g. temperature)',
        () {
          ConversionRule fahrenheitCalcRule =
              ConversionRuleUtils.getFormulaRule(
            unitGroupName: GroupNames.temperature,
            unitCode: UnitCodes.degreeFahrenheit,
          );

          ConversionRule kelvinCalcRule = ConversionRuleUtils.getFormulaRule(
            unitGroupName: GroupNames.temperature,
            unitCode: UnitCodes.degreeKelvin,
          );

          expect(
            ConversionRuleUtils.calculate(
              ValueModel.numeric(32),
              srcUnitRule: fahrenheitCalcRule,
              tgtUnitRule: kelvinCalcRule,
            ),
            ValueModel.numeric(273.15),
          );

          expect(
            ConversionRuleUtils.calculate(
              ValueModel.numeric(273.15),
              srcUnitRule: kelvinCalcRule,
              tgtUnitRule: fahrenheitCalcRule,
            ),
            ValueModel.numeric(32),
          );

          expect(
            ConversionRuleUtils.calculate(
              ValueModel.numeric(32),
              srcUnitRule: fahrenheitCalcRule,
              tgtUnitRule: fahrenheitCalcRule,
            ),
            ValueModel.numeric(32),
          );

          expect(
            ConversionRuleUtils.calculate(
              null,
              srcUnitRule: fahrenheitCalcRule,
              tgtUnitRule: kelvinCalcRule,
            ),
            null,
          );
        },
      );

      test(
        'One-way conversion (e. g. text size)',
        () {
          ConversionRule strLen = ConversionRule.noParams(
            toBase: null,
            fromBase: (x) => ValueModel.numeric(x.raw.length),
          );

          expect(
            ConversionRuleUtils.calculate(
              ValueModel.str("Example"),
              srcUnitRule: ConversionRule.identity(),
              tgtUnitRule: strLen,
            ),
            ValueModel.numeric(7),
          );

          expect(
            ConversionRuleUtils.calculate(
              ValueModel.numeric(7),
              srcUnitRule: strLen,
              tgtUnitRule: ConversionRule.identity(),
            ),
            null,
          );

          expect(
            ConversionRuleUtils.calculate(
              null,
              srcUnitRule: strLen,
              tgtUnitRule: ConversionRule.identity(),
            ),
            null,
          );
        },
      );
    });

    group('With parameters', () {
      ConversionParamSetValueModel params = ConversionParamSetValueModel(
        paramSet: clothingSizeParamSet,
        paramValues: [
          ConversionParamValueModel.tuple(genderParam, "Male", null),
          ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
          ConversionParamValueModel.tuple(heightParam, 150, 1,
              unit: centimeter),
        ],
      );

      group(
        'Two-way conversion (e. g. clothing size)',
        () {
          ConversionRule ruSizeCalc = ConversionRuleUtils.getFormulaRule(
            unitGroupName: GroupNames.clothingSize,
            unitCode: ClothingSizeCode.ru.name,
          );

          ConversionRule euSizeCalc = ConversionRuleUtils.getFormulaRule(
            unitGroupName: GroupNames.clothingSize,
            unitCode: ClothingSizeCode.eu.name,
          );

          ConversionRule interSizeCalc = ConversionRuleUtils.getFormulaRule(
            unitGroupName: GroupNames.clothingSize,
            unitCode: ClothingSizeCode.inter.name,
          );

          test('RU -> EU', () {
            expect(
              ConversionRuleUtils.calculate(
                ValueModel.numeric(38),
                srcUnitRule: ruSizeCalc,
                tgtUnitRule: euSizeCalc,
                params: params,
              ),
              ValueModel.numeric(32),
            );
          });

          test('EU -> RU', () {
            expect(
              ConversionRuleUtils.calculate(
                ValueModel.numeric(32),
                srcUnitRule: euSizeCalc,
                tgtUnitRule: ruSizeCalc,
                params: params,
              ),
              ValueModel.numeric(38),
            );
          });

          test('INT -> RU', () {
            expect(
              ConversionRuleUtils.calculate(
                ValueModel.str(ClothingSizeInter.xxs.name),
                srcUnitRule: interSizeCalc,
                tgtUnitRule: ruSizeCalc,
                params: params,
              ),
              ValueModel.numeric(38),
            );
          });

          test('EU -> INT', () {
            expect(
              ConversionRuleUtils.calculate(
                ValueModel.numeric(32),
                srcUnitRule: euSizeCalc,
                tgtUnitRule: interSizeCalc,
                params: params,
              ),
              ValueModel.str(ClothingSizeInter.xxs.name),
            );
          });

          test('EU -> RU (unacceptable value)', () {
            expect(
              ConversionRuleUtils.calculate(
                ValueModel.numeric(33),
                srcUnitRule: euSizeCalc,
                tgtUnitRule: ruSizeCalc,
                params: params,
              ),
              null,
            );
          });

          test('RU -> EU (no value)', () {
            expect(
              ConversionRuleUtils.calculate(
                null,
                srcUnitRule: ruSizeCalc,
                tgtUnitRule: euSizeCalc,
                params: params,
              ),
              null,
            );
          });

          test('RU -> RU', () {
            expect(
              ConversionRuleUtils.calculate(
                ValueModel.numeric(38),
                srcUnitRule: ruSizeCalc,
                tgtUnitRule: ruSizeCalc,
                params: params,
              ),
              ValueModel.numeric(38),
            );
          });
        },
      );
    });
  });

  group('Convert by a coefficient rule', () {
    group('Without parameters', () {
      test(
        'Two-way conversion',
        () {
          ConversionRule centimeterCalcRule =
              ConversionRule.byCoefficient(0.01);
          ConversionRule kilometerCalcRule = ConversionRule.byCoefficient(1000);

          expect(
            ConversionRuleUtils.calculate(
              ValueModel.numeric(32),
              srcUnitRule: centimeterCalcRule,
              tgtUnitRule: kilometerCalcRule,
            ),
            ValueModel.numeric(0.00032),
          );

          expect(
            ConversionRuleUtils.calculate(
              ValueModel.numeric(32),
              srcUnitRule: kilometerCalcRule,
              tgtUnitRule: centimeterCalcRule,
            ),
            ValueModel.numeric(3200000),
          );

          expect(
            ConversionRuleUtils.calculate(
              ValueModel.numeric(32),
              srcUnitRule: kilometerCalcRule,
              tgtUnitRule: kilometerCalcRule,
            ),
            ValueModel.numeric(32),
          );

          expect(
            ConversionRuleUtils.calculate(
              null,
              srcUnitRule: kilometerCalcRule,
              tgtUnitRule: kilometerCalcRule,
            ),
            null,
          );
        },
      );

      test(
        'One-way conversion',
        () {
          ConversionRule strLen = ConversionRule.noParams(
            toBase: null,
            fromBase: (x) => ValueModel.numeric(x.raw.length),
          );

          expect(
            ConversionRuleUtils.calculate(
              ValueModel.str("Example"),
              srcUnitRule: ConversionRule.identity(),
              tgtUnitRule: strLen,
            ),
            ValueModel.numeric(7),
          );

          expect(
            ConversionRuleUtils.calculate(
              ValueModel.numeric(7),
              srcUnitRule: strLen,
              tgtUnitRule: ConversionRule.identity(),
            ),
            null,
          );

          expect(
            ConversionRuleUtils.calculate(
              null,
              srcUnitRule: strLen,
              tgtUnitRule: ConversionRule.identity(),
            ),
            null,
          );
        },
      );
    });
  });
}
