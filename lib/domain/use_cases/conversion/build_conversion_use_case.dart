import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/refreshing_jobs.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/refreshable_value_model.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/refreshable_value_repository.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/formula_utils.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class BuildConversionUseCase
    extends UseCase<InputConversionModel, OutputConversionModel> {
  final UnitGroupRepository unitGroupRepository;
  final RefreshableValueRepository refreshableValueRepository;

  const BuildConversionUseCase({
    required this.unitGroupRepository,
    required this.refreshableValueRepository,
  });

  @override
  Future<Either<ConvertouchException, OutputConversionModel>> execute(
    InputConversionModel input,
  ) async {
    try {
      if (input.unitGroup == null || input.targetUnits.isEmpty) {
        return Right(
          OutputConversionModel(
            unitGroup: input.unitGroup,
            sourceConversionItem: null,
          ),
        );
      }

      ConversionItemModel srcConversionItem = input.sourceConversionItem ??
          await _prepareSourceConversionItem(input.targetUnits.first);

      List<ConversionItemModel> convertedUnitValues = [];

      double? srcValue = double.tryParse(srcConversionItem.value.strValue);
      double? srcDefaultValue =
          double.tryParse(srcConversionItem.defaultValue.strValue);
      double? srcCoefficient = srcConversionItem.unit.coefficient;

      for (UnitModel tgtUnit in input.targetUnits) {
        if (tgtUnit.id! == srcConversionItem.unit.id!) {
          convertedUnitValues.add(srcConversionItem);
          continue;
        }

        double? tgtCoefficient = tgtUnit.coefficient;
        double? tgtValue;
        double? tgtDefaultValue;

        if (input.unitGroup!.conversionType != ConversionType.formula) {
          double? normalizedBaseValue =
              srcCoefficient != null && tgtCoefficient != null
                  ? srcCoefficient / tgtCoefficient
                  : null;
          tgtValue = srcValue != null && normalizedBaseValue != null
              ? srcValue * normalizedBaseValue
              : null;
          tgtDefaultValue =
              srcDefaultValue != null && normalizedBaseValue != null
                  ? srcDefaultValue * normalizedBaseValue
                  : null;
        } else {
          String groupName = input.unitGroup!.name;

          var srcToBase = FormulaUtils.getFormula(
            unitGroupName: groupName,
            unitCode: srcConversionItem.unit.code,
          );
          var baseToTgt = FormulaUtils.getFormula(
            unitGroupName: groupName,
            unitCode: tgtUnit.code,
          );

          double? baseValue = srcToBase.applyForward(srcValue);
          double? normalizedBaseValue = srcToBase.applyForward(srcDefaultValue);

          tgtValue = baseToTgt.applyReverse(baseValue);
          tgtDefaultValue = baseToTgt.applyReverse(normalizedBaseValue);
        }

        convertedUnitValues.add(
          ConversionItemModel(
            unit: tgtUnit,
            value: ValueModel.ofDouble(tgtValue),
            defaultValue: ValueModel.ofDouble(tgtDefaultValue),
          ),
        );
      }

      bool emptyConversionItemsExist = convertedUnitValues.any(
        (unitValue) =>
            !unitValue.value.notEmpty && !unitValue.defaultValue.notEmpty,
      );

      return Right(
        OutputConversionModel(
          unitGroup: input.unitGroup,
          sourceConversionItem: srcConversionItem,
          targetConversionItems: convertedUnitValues,
          emptyConversionItemsExist: emptyConversionItemsExist,
        ),
      );
    } catch (e, stackTrace) {
      return Left(
        InternalException(
          message: "Error when converting unit value: $e",
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<ConversionItemModel> _prepareSourceConversionItem(
    UnitModel sourceUnit,
  ) async {
    UnitGroupModel? unitGroup = ObjectUtils.tryGet(
      await unitGroupRepository.get(sourceUnit.unitGroupId),
    );

    if (!unitGroup!.refreshable) {
      return ConversionItemModel(
        unit: sourceUnit,
        value: ValueModel.none,
        defaultValue: ValueModel.one,
      );
    }

    RefreshingJobModel? job =
        RefreshingJobModel.fromJson(refreshingJobsMap[unitGroup.name]);

    if (job == null) {
      return ConversionItemModel(
        unit: sourceUnit,
        value: ValueModel.none,
        defaultValue: ValueModel.none,
      );
    }

    if (job.refreshableDataPart != RefreshableDataPart.value) {
      return ConversionItemModel(
        unit: sourceUnit,
        value: ValueModel.none,
        defaultValue: ValueModel.one,
      );
    }

    RefreshableValueModel? refreshableValue = ObjectUtils.tryGet(
      await refreshableValueRepository.get(sourceUnit.id!),
    );

    return ConversionItemModel(
      unit: sourceUnit,
      value: ValueModel.none,
      defaultValue: refreshableValue?.value != null
          ? ValueModel.ofString(refreshableValue!.value!)
          : ValueModel.one,
    );
  }
}
