import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/conversion_rule.dart';
import 'package:convertouch/domain/utils/conversion_rule_utils.dart' as rules;
import 'package:test/test.dart';

import '../model/mock/mock_param.dart';
import '../model/mock/mock_unit.dart';

void main() {
  group('Convert by a formula rule', () {
    group('Without parameters', () {
      test(
        'Two-way conversion (e. g. temperature)',
        () {
          UnitRule fahrenheitRule = rules.getFormulaRule(
            unitGroupName: GroupNames.temperature,
            unitCode: UnitCodes.degreeFahrenheit,
          )!;

          UnitRule? kelvinRule = rules.getFormulaRule(
            unitGroupName: GroupNames.temperature,
            unitCode: UnitCodes.degreeKelvin,
          );

          expect(
            Converter(ValueModel.numeric(32))
                .apply(fahrenheitRule.xToBase)
                .apply(kelvinRule?.baseToY)
                .value,
            ValueModel.numeric(273.15),
          );

          expect(
            Converter(ValueModel.numeric(273.15))
                .apply(kelvinRule?.xToBase)
                .apply(fahrenheitRule.baseToY)
                .value,
            ValueModel.numeric(32),
          );

          expect(
            Converter(ValueModel.numeric(32))
                .apply(fahrenheitRule.xToBase)
                .apply(fahrenheitRule.baseToY)
                .value,
            ValueModel.numeric(32),
          );

          expect(
            const Converter(null)
                .apply(fahrenheitRule.xToBase)
                .apply(fahrenheitRule.baseToY)
                .value,
            null,
          );
        },
      );

      test(
        'One-way conversion (e. g. text size)',
        () {
          ConversionRule strLen = ConversionRule.noParams(
            func: (x) => ValueModel.numeric(x.raw.length),
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
          Map<String, String> mappingTable = rules.getMappingTableByParams(
            unitGroupName: GroupNames.clothingSize,
            params: params,
          )!;

          UnitRule ruSize = UnitRule.mappingTable(
            mapping: mappingTable,
            unitCode: CountryCode.ru.name,
          );

          UnitRule euSize = UnitRule.mappingTable(
            mapping: mappingTable,
            unitCode: CountryCode.eu.name,
          );

          UnitRule interSize = UnitRule.mappingTable(
            mapping: mappingTable,
            unitCode: CountryCode.inter.name,
          );

          test('RU -> EU', () {
            expect(
              Converter(ValueModel.numeric(38), params: params)
                  .apply(ruSize.xToBase)
                  .apply(euSize.baseToY)
                  .value,
              ValueModel.numeric(32),
            );
          });

          test('EU -> RU', () {
            expect(
              Converter(ValueModel.numeric(32), params: params)
                  .apply(euSize.xToBase)
                  .apply(ruSize.baseToY)
                  .value,
              ValueModel.numeric(38),
            );
          });

          test('INT -> RU', () {
            expect(
              Converter(ValueModel.str("XXS"), params: params)
                  .apply(interSize.xToBase)
                  .apply(ruSize.baseToY)
                  .value,
              ValueModel.numeric(38),
            );
          });

          test('EU -> INT', () {
            expect(
              Converter(ValueModel.numeric(32), params: params)
                  .apply(euSize.xToBase)
                  .apply(interSize.baseToY)
                  .value,
              ValueModel.str("XXS"),
            );
          });

          test('EU -> RU (unacceptable value)', () {
            expect(
              Converter(ValueModel.numeric(33), params: params)
                  .apply(euSize.xToBase)
                  .apply(ruSize.baseToY)
                  .value,
              null,
            );
          });

          test('RU -> EU (no value)', () {
            expect(
              Converter(null, params: params)
                  .apply(ruSize.xToBase)
                  .apply(euSize.baseToY)
                  .value,
              null,
            );
          });

          test('RU -> RU', () {
            expect(
              Converter(ValueModel.numeric(38), params: params)
                  .apply(ruSize.xToBase)
                  .apply(ruSize.baseToY)
                  .value,
              ValueModel.numeric(38),
            );
          });
        },
      );
    });
  });

  group('Convert by a coefficient rule', () {
    group('Without parameters', () {
      group(
        'Two-way conversion',
        () {
          UnitRule centimeterRule = UnitRule.coefficient(0.01);
          UnitRule kilometerRule = UnitRule.coefficient(1000);

          test('cm -> km', () {
            expect(
              Converter(ValueModel.numeric(32))
                  .apply(centimeterRule.xToBase)
                  .apply(kilometerRule.baseToY)
                  .value,
              ValueModel.numeric(0.00032),
            );
          });

          test('km -> cm', () {
            expect(
              Converter(ValueModel.numeric(32))
                  .apply(kilometerRule.xToBase)
                  .apply(centimeterRule.baseToY)
                  .value,
              ValueModel.numeric(3200000),
            );
          });

          test('km -> km', () {
            expect(
              Converter(ValueModel.numeric(32))
                  .apply(kilometerRule.xToBase)
                  .apply(kilometerRule.baseToY)
                  .value,
              ValueModel.numeric(32),
            );
          });

          test('km -> km (no value)', () {
            expect(
              const Converter(null)
                  .apply(kilometerRule.xToBase)
                  .apply(kilometerRule.baseToY)
                  .value,
              null,
            );
          });
        },
      );
    });
  });
}
