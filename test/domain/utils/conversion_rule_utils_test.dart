import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/conversion_param_constants/clothing_size.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_values_model.dart';
import 'package:convertouch/domain/model/conversion_rule.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/conversion_rule_utils.dart';
import 'package:test/test.dart';

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
              ValueModel.empty,
              srcUnitRule: fahrenheitCalcRule,
              tgtUnitRule: kelvinCalcRule,
            ),
            ValueModel.empty,
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
            ValueModel.undef,
          );

          expect(
            ConversionRuleUtils.calculate(
              ValueModel.empty,
              srcUnitRule: strLen,
              tgtUnitRule: ConversionRule.identity(),
            ),
            ValueModel.empty,
          );
        },
      );
    });

    group('With parameters', () {
      ConversionParamSetValuesModel params = ConversionParamSetValuesModel(
        paramSet: const ConversionParamSetModel(
          name: "Clothing Size",
          mandatory: true,
          groupId: -1,
        ),
        values: [
          ConversionParamValueModel(
            param: ConversionParamModel.listBased(
              name: "Gender",
              listValueType: ConvertouchListType.gender,
              paramSetId: 1,
            ),
            value: ValueModel.listVal(Gender.male),
          ),
          ConversionParamValueModel(
            param: ConversionParamModel.listBased(
              name: "Garment",
              listValueType: ConvertouchListType.garment,
              paramSetId: 1,
            ),
            value: ValueModel.listVal(Garment.shirt),
          ),
          ConversionParamValueModel(
            param: const ConversionParamModel.unitBased(
              name: "Height",
              unitGroupId: -1,
              paramSetId: -1,
              valueType: ConvertouchValueType.decimalPositive,
            ),
            unit: const UnitModel(name: "Centimeter", code: "cm"),
            value: ValueModel.numeric(150),
          ),
        ],
      );

      test(
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

          expect(
            ConversionRuleUtils.calculate(
              ValueModel.numeric(38),
              srcUnitRule: ruSizeCalc,
              tgtUnitRule: euSizeCalc,
              params: params,
            ),
            ValueModel.numeric(32),
          );

          expect(
            ConversionRuleUtils.calculate(
              ValueModel.numeric(32),
              srcUnitRule: euSizeCalc,
              tgtUnitRule: ruSizeCalc,
              params: params,
            ),
            ValueModel.numeric(38),
          );

          expect(
            ConversionRuleUtils.calculate(
              ValueModel.listVal(ClothingSizeInter.xxs),
              srcUnitRule: interSizeCalc,
              tgtUnitRule: ruSizeCalc,
              params: params,
            ),
            ValueModel.numeric(38),
          );

          expect(
            ConversionRuleUtils.calculate(
              ValueModel.numeric(32),
              srcUnitRule: euSizeCalc,
              tgtUnitRule: interSizeCalc,
              params: params,
            ),
            ValueModel.listVal(ClothingSizeInter.xxs),
          );

          expect(
            ConversionRuleUtils.calculate(
              ValueModel.numeric(33),
              srcUnitRule: euSizeCalc,
              tgtUnitRule: ruSizeCalc,
              params: params,
            ),
            ValueModel.undef,
          );

          expect(
            ConversionRuleUtils.calculate(
              ValueModel.empty,
              srcUnitRule: ruSizeCalc,
              tgtUnitRule: euSizeCalc,
              params: params,
            ),
            ValueModel.empty,
          );

          expect(
            ConversionRuleUtils.calculate(
              ValueModel.numeric(38),
              srcUnitRule: ruSizeCalc,
              tgtUnitRule: ruSizeCalc,
              params: params,
            ),
            ValueModel.numeric(38),
          );
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
              ConversionRule.fromCoefficient(0.01);
          ConversionRule kilometerCalcRule =
              ConversionRule.fromCoefficient(1000);

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
              ValueModel.empty,
              srcUnitRule: kilometerCalcRule,
              tgtUnitRule: kilometerCalcRule,
            ),
            ValueModel.empty,
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
            ValueModel.undef,
          );

          expect(
            ConversionRuleUtils.calculate(
              ValueModel.empty,
              srcUnitRule: strLen,
              tgtUnitRule: ConversionRule.identity(),
            ),
            ValueModel.empty,
          );
        },
      );
    });
  });
}
