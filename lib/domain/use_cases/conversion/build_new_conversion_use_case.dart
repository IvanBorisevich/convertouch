import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/dynamic_value_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/formula_utils.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:convertouch/domain/utils/value_model_utils.dart';
import 'package:either_dart/either.dart';

class BuildNewConversionUseCase
    extends UseCase<InputConversionModel, OutputConversionModel> {
  final DynamicValueRepository dynamicValueRepository;

  const BuildNewConversionUseCase({
    required this.dynamicValueRepository,
  });

  @override
  Future<Either<ConvertouchException, OutputConversionModel>> execute(
    InputConversionModel input,
  ) async {
    try {
      if (input.unitGroup == null) {
        return const Right(OutputConversionModel.none());
      }

      if (input.targetUnits.isEmpty) {
        return Right(OutputConversionModel.noItems(input.unitGroup));
      }

      ConversionItemModel srcItem = await _getSourceConversionItem(input);

      List<ConversionItemModel> convertedUnitValues = [];
      double? srcValue = double.tryParse(srcItem.value.strValue);
      double srcDefaultValue = double.parse(srcItem.defaultValue.strValue);
      double srcCoefficient = srcItem.unit.coefficient!;

      for (UnitModel tgtUnit in input.targetUnits) {
        if (tgtUnit.id! == srcItem.unit.id!) {
          convertedUnitValues.add(srcItem);
          continue;
        }

        double? tgtValue;
        double tgtDefaultValue;

        if (input.unitGroup!.conversionType != ConversionType.formula) {
          double tgtCoefficient = tgtUnit.coefficient!;
          tgtValue = srcValue != null
              ? srcValue * srcCoefficient / tgtCoefficient
              : null;
          tgtDefaultValue = srcDefaultValue * srcCoefficient / tgtCoefficient;
        } else {
          String groupName = input.unitGroup!.name;

          var srcToBase = FormulaUtils.getFormula(
            unitGroupName: groupName,
            unitCode: srcItem.unit.code,
          );
          var baseToTgt = FormulaUtils.getFormula(
            unitGroupName: groupName,
            unitCode: tgtUnit.code,
          );

          double? baseValue = srcToBase.applyForward(srcValue);
          double? normalizedBaseValue = srcToBase.applyForward(srcDefaultValue);

          tgtValue = baseToTgt.applyReverse(baseValue);
          tgtDefaultValue = baseToTgt.applyReverse(normalizedBaseValue)!;
        }

        double? minValue = tgtUnit.minValue ?? input.unitGroup?.minValue;
        double? maxValue = tgtUnit.maxValue ?? input.unitGroup?.maxValue;

        ValueModel tgtValueModel = ValueModelUtils.betweenOrUndefined(
          rawValue: tgtValue,
          min: minValue,
          max: maxValue,
        );

        ValueModel tgtDefaultValueModel = tgtValueModel.isDefined
            ? ValueModelUtils.betweenOrUndefined(
                rawValue: tgtDefaultValue,
                min: minValue,
                max: maxValue,
              )
            : ValueModel.undefined;

        convertedUnitValues.add(
          ConversionItemModel(
            unit: tgtUnit,
            value:
                tgtValueModel.isDefined ? tgtValueModel : ValueModel.emptyVal,
            defaultValue: tgtDefaultValueModel,
          ),
        );
      }

      return Right(
        OutputConversionModel(
          unitGroup: input.unitGroup,
          sourceConversionItem: srcItem,
          targetConversionItems: convertedUnitValues,
        ),
      );
    } catch (e, stackTrace) {
      return Left(
        InternalException(
          message: "Error when converting unit value",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  Future<ConversionItemModel> _getSourceConversionItem(
    InputConversionModel input,
  ) async {
    UnitModel srcUnit =
        input.sourceConversionItem?.unit ?? input.targetUnits.first;
    ValueModel srcValue =
        input.sourceConversionItem?.value ?? ValueModel.emptyVal;
    ValueModel srcDefaultValue = ValueModel.ofString(
      ObjectUtils.tryGet(await dynamicValueRepository.get(srcUnit.id!)).value,
    );

    return ConversionItemModel(
      unit: srcUnit,
      value: srcValue,
      defaultValue: srcDefaultValue,
    );
  }
}
