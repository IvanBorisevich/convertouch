import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/conversion_rule.dart';
import 'package:convertouch/domain/utils/conversion_rule_utils.dart' as rules;
import 'package:either_dart/either.dart';

class ConvertUnitValuesUseCase
    extends UseCase<InputConversionModel, List<ConversionUnitValueModel>> {
  const ConvertUnitValuesUseCase();

  @override
  Future<Either<ConvertouchException, List<ConversionUnitValueModel>>> execute(
    InputConversionModel input,
  ) async {
    try {
      List<ConversionUnitValueModel> convertedUnitValues = [];

      Map<String, String>? mappingTable;
      if (input.params != null && input.params!.hasAllValues) {
        mappingTable = rules.getMappingTableByParams(
          unitGroupName: input.unitGroup.name,
          params: input.params,
        );
      } else {
        mappingTable = rules.getMappingTableByValue(
          unitGroupName: input.unitGroup.name,
          value: input.sourceUnitValue,
        );
      }

      ConversionRule? xToBase = rules
          .getRule(
            unitGroup: input.unitGroup,
            unit: input.sourceUnitValue.unit,
            mappingTable: mappingTable,
          )
          ?.xToBase;

      for (var tgtUnit in input.targetUnits) {
        if (tgtUnit.name == input.sourceUnitValue.unit.name) {
          convertedUnitValues.add(input.sourceUnitValue);
          continue;
        }

        ConversionRule? baseToY = mappingTable != null
            ? UnitRule.mappingTable(
                mapping: mappingTable,
                unitCode: tgtUnit.code,
              ).baseToY
            : rules
                .getRule(
                  unitGroup: input.unitGroup,
                  unit: tgtUnit,
                )
                ?.baseToY;

        ValueModel? resultValue = Converter(input.sourceUnitValue.value)
            .apply(xToBase)
            .apply(baseToY)
            .value
            ?.betweenOrNull(tgtUnit.minValue, tgtUnit.maxValue);

        ValueModel? resultDefValue = tgtUnit.listType == null
            ? Converter(input.sourceUnitValue.defaultValue)
                .apply(xToBase)
                .apply(baseToY)
                .value
                ?.betweenOrNull(tgtUnit.minValue, tgtUnit.maxValue)
            : null;

        convertedUnitValues.add(
          ConversionUnitValueModel(
            unit: tgtUnit,
            value: resultValue,
            defaultValue: resultDefValue,
          ),
        );
      }
      return Right(convertedUnitValues);
    } catch (e, stackTrace) {
      return Left(
        InternalException(
          message: "Error when converting unit values",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
