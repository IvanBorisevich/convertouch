import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/conversion_rule.dart';
import 'package:convertouch/domain/utils/conversion_rule_utils.dart' as rules;
import 'package:test/test.dart';

import '../model/mock/mock_param.dart';
import '../model/mock/mock_unit.dart';
import '../model/mock/mock_unit_group.dart';

void main() {
  group('Convert by a formula rule', () {
    group('Without parameters', () {
      group('Two-way conversion (e. g. temperature)', () {
        ConversionRule fahrenheitToCelsius = rules.getRule(
          unitGroup: temperatureGroup,
          unit: degreeFahrenheit,
          ruleType: ConversionRuleType.xToBase,
        )!;

        ConversionRule celsiusToFahrenheit = rules.getRule(
          unitGroup: temperatureGroup,
          unit: degreeFahrenheit,
          ruleType: ConversionRuleType.baseToY,
        )!;

        ConversionRule kelvinToCelsius = rules.getRule(
          unitGroup: temperatureGroup,
          unit: degreeKelvin,
          ruleType: ConversionRuleType.xToBase,
        )!;

        ConversionRule celsiusToKelvin = rules.getRule(
          unitGroup: temperatureGroup,
          unit: degreeKelvin,
          ruleType: ConversionRuleType.baseToY,
        )!;

        test('Fahrenheit -> Kelvin', () {
          expect(
            Converter(ValueModel.numeric(32))
                .apply(fahrenheitToCelsius)
                .apply(celsiusToKelvin)
                .value,
            ValueModel.numeric(273.15),
          );
        });

        test('Kelvin -> Fahrenheit', () {
          expect(
            Converter(ValueModel.numeric(273.15))
                .apply(kelvinToCelsius)
                .apply(celsiusToFahrenheit)
                .value,
            ValueModel.numeric(32),
          );
        });

        test('Kelvin -> Celsius', () {
          expect(
            Converter(ValueModel.numeric(273.15)).apply(kelvinToCelsius).value,
            ValueModel.zero,
          );
        });

        test('Celsius -> Kelvin', () {
          expect(
            const Converter(ValueModel.zero).apply(celsiusToKelvin).value,
            ValueModel.numeric(273.15),
          );
        });

        test('Kelvin -> Kelvin', () {
          expect(
            Converter(ValueModel.numeric(100))
                .apply(kelvinToCelsius)
                .apply(celsiusToKelvin)
                .value,
            ValueModel.numeric(100),
          );

          expect(
            const Converter(null)
                .apply(kelvinToCelsius)
                .apply(celsiusToKelvin)
                .value,
            null,
          );
        });
      });

      test(
        'One-way conversion (e. g. text size)',
        () {
          ConversionRule strLen = ConversionRule.functionWithoutParams(
            func: (x) => ValueModel.any(x?.raw.length),
          );

          expect(
            Converter(ValueModel.str("Example"))
                .apply(ConversionRule.identity)
                .apply(strLen)
                .value,
            ValueModel.numeric(7),
          );

          expect(
            Converter(ValueModel.str("Example")).apply(strLen).value,
            ValueModel.numeric(7),
          );

          expect(
            Converter(ValueModel.numeric(7)).apply(strLen).apply(null).value,
            null,
          );

          expect(
            Converter(ValueModel.numeric(7))
                .apply(strLen)
                .apply(ConversionRule.identity)
                .apply(null)
                .value,
            null,
          );

          expect(
            Converter(ValueModel.numeric(7))
                .apply(strLen)
                .apply(null)
                .apply(ConversionRule.identity)
                .value,
            null,
          );
        },
      );
    });

    group('With parameters', () {
      group('Clothes size', () {
        ConversionParamSetValueModel clothesParams =
            ConversionParamSetValueModel(
          paramSet: clothesSizeParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(personParam, "Man", null),
            ConversionParamValueModel.tuple(garmentParam, "Shirt", null),
            ConversionParamValueModel.tuple(heightParam, 150, 1,
                unit: centimeter),
          ],
        );

        Map<String, String> mapping = rules.getMappingByParams(
          unitGroupName: GroupNames.clothesSize,
          params: clothesParams,
        )!;

        MappingConverter converter = MappingConverter(mapping);

        test('RU -> EU', () {
          expect(
            converter.valueBySrcValue(
              srcValue: ValueModel.numeric(42),
              srcUnitCode: CountryCode.ru.name,
              tgtUnitCode: CountryCode.eu.name,
            ),
            ValueModel.numeric(42),
          );
        });

        test('EU -> RU', () {
          expect(
            converter.valueBySrcValue(
              srcValue: ValueModel.numeric(42),
              srcUnitCode: CountryCode.eu.name,
              tgtUnitCode: CountryCode.ru.name,
            ),
            ValueModel.numeric(42),
          );
        });

        test('INT -> RU', () {
          expect(
            converter.valueBySrcValue(
              srcValue: ValueModel.str("XXS"),
              srcUnitCode: CountryCode.inter.name,
              tgtUnitCode: CountryCode.ru.name,
            ),
            ValueModel.numeric(42),
          );
        });

        test('EU -> INT', () {
          expect(
            converter.valueBySrcValue(
              srcValue: ValueModel.numeric(42),
              srcUnitCode: CountryCode.eu.name,
              tgtUnitCode: CountryCode.inter.name,
            ),
            ValueModel.str("XXS"),
          );
        });

        test('EU -> RU (unacceptable value)', () {
          expect(
            converter.valueBySrcValue(
              srcValue: ValueModel.numeric(33),
              srcUnitCode: CountryCode.eu.name,
              tgtUnitCode: CountryCode.ru.name,
            ),
            null,
          );
        });

        test('RU -> EU (no value)', () {
          expect(
            converter.valueBySrcValue(
              srcValue: null,
              srcUnitCode: CountryCode.ru.name,
              tgtUnitCode: CountryCode.eu.name,
            ),
            null,
          );
        });

        test('RU -> RU', () {
          expect(
            converter.valueBySrcValue(
              srcValue: ValueModel.numeric(42),
              srcUnitCode: CountryCode.ru.name,
              tgtUnitCode: CountryCode.ru.name,
            ),
            ValueModel.numeric(42),
          );
        });
      });

      group('Ring size', () {
        ConversionParamSetValueModel ringParams = ConversionParamSetValueModel(
          paramSet: ringSizeByDiameterParamSet,
          paramValues: [
            ConversionParamValueModel.tuple(diameterParam, 24, 1,
                unit: millimeter),
          ],
        );

        Map<String, String> mapping = rules.getMappingByParams(
          unitGroupName: GroupNames.ringSize,
          params: ringParams,
        )!;

        MappingConverter converter = MappingConverter(mapping);

        test('FR -> ES | should find match by non-null src value', () {
          expect(
            converter.valueBySrcValue(
              srcValue: ValueModel.numeric(75),
              srcUnitCode: CountryCode.fr.name,
              tgtUnitCode: CountryCode.es.name,
            ),
            ValueModel.numeric(35),
          );
        });

        test(
            'FR -> ES | should not find match '
            'by src value not from the mapping', () {
          expect(
            converter.valueBySrcValue(
              srcValue: ValueModel.numeric(400),
              srcUnitCode: CountryCode.fr.name,
              tgtUnitCode: CountryCode.es.name,
            ),
            null,
          );
        });

        test('DE -> ES | should find match by null src value', () {
          expect(
            converter.valueBySrcValue(
              srcValue: null,
              srcUnitCode: CountryCode.de.name,
              tgtUnitCode: CountryCode.es.name,
            ),
            ValueModel.numeric(35),
          );
        });
      });
    });
  });

  group('Convert by a coefficient rule', () {
    group('Without parameters', () {
      group(
        'Two-way conversion',
        () {
          ConversionRule cmToM = ConversionRule.coefficient(
            0.01,
            ruleType: ConversionRuleType.xToBase,
          );
          ConversionRule mToCm = ConversionRule.coefficient(
            0.01,
            ruleType: ConversionRuleType.baseToY,
          );

          ConversionRule kmToM = ConversionRule.coefficient(
            1000,
            ruleType: ConversionRuleType.xToBase,
          );
          ConversionRule mToKm = ConversionRule.coefficient(
            1000,
            ruleType: ConversionRuleType.baseToY,
          );

          test('cm -> km', () {
            expect(
              Converter(ValueModel.numeric(32)).apply(cmToM).apply(mToKm).value,
              ValueModel.numeric(0.00032),
            );
          });

          test('cm -> m', () {
            expect(
              Converter(ValueModel.numeric(32)).apply(cmToM).value,
              ValueModel.numeric(0.32),
            );
          });

          test('km -> cm', () {
            expect(
              Converter(ValueModel.numeric(32)).apply(kmToM).apply(mToCm).value,
              ValueModel.numeric(3200000),
            );
          });

          test('km -> m', () {
            expect(
              Converter(ValueModel.numeric(32)).apply(kmToM).value,
              ValueModel.numeric(32000),
            );
          });

          test('km -> km', () {
            expect(
              Converter(ValueModel.numeric(32)).apply(kmToM).apply(mToKm).value,
              ValueModel.numeric(32),
            );
          });

          test('km -> km (no value)', () {
            expect(
              const Converter(null).apply(kmToM).apply(mToKm).value,
              null,
            );
          });
        },
      );
    });
  });

  group('Calculate param value by src value', () {
    group('Non-list param value', () {
      test("Calculate the param 'One Size Weight' (default values only)", () {
        expect(
          rules.calculateParamValueBySrcValue(
            param: oneSideWeightParam,
            srcUnitValue: ConversionUnitValueModel.tuple(ton, null, 1),
            params: ConversionParamSetValueModel(
              paramSet: barbellWeightParamSet,
              paramValues: [
                ConversionParamValueModel.tuple(barWeightParam, 10, null,
                    unit: kilogram),
                ConversionParamValueModel.tuple(oneSideWeightParam, null, 1,
                    unit: kilogram, calculated: true),
              ],
            ),
            unitGroup: massGroup,
          ),
          ConversionParamValueModel.tuple(
              oneSideWeightParam, null, (1000 - 10) / 2,
              unit: kilogram, calculated: true),
        );
      });
    });
  });
}
