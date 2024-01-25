import 'dart:developer';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/refreshable_value_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_params_refreshing_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class RefreshConversionParamsUseCase extends UseCase<
    InputConversionParamsRefreshingModel, InputConversionModel> {
  const RefreshConversionParamsUseCase();

  @override
  Future<Either<Failure, InputConversionModel>> execute(
    InputConversionParamsRefreshingModel input,
  ) async {
    log("RefreshConversionParamsUseCase input: $input");

    try {
      ConversionItemModel? srcConversionItem;
      List<UnitModel> targetUnits = [];
      if (input.refreshableDataPart == RefreshableDataPart.value) {
        srcConversionItem = await _refreshSourceConversionItemFromValues(
          input.conversionParamsToBeRefreshed.sourceConversionItem,
          input.refreshedData as List<RefreshableValueModel>,
        );
        targetUnits = input.conversionParamsToBeRefreshed.targetUnits;
      } else {
        List<UnitModel> refreshedUnitCoefficients =
            input.refreshedData as List<UnitModel>;

        srcConversionItem = await _refreshSourceConversionItemFromCoefficients(
          input.conversionParamsToBeRefreshed.sourceConversionItem,
          refreshedUnitCoefficients,
        );

        targetUnits = await _refreshTargetUnits(
          input.conversionParamsToBeRefreshed.targetUnits,
          refreshedUnitCoefficients,
        );
      }

      return Right(
        InputConversionModel(
          unitGroup: input.conversionParamsToBeRefreshed.unitGroup,
          sourceConversionItem: srcConversionItem,
          targetUnits: targetUnits,
        ),
      );
    } catch (e, stacktrace) {
      return Left(
        InternalFailure(
          "Error when refreshing conversion params before rebuild: $e,"
          "$stacktrace",
        ),
      );
    }
  }

  Future<ConversionItemModel?> _refreshSourceConversionItemFromValues(
    ConversionItemModel? srcConversionItem,
    List<RefreshableValueModel> refreshedValues,
  ) async {
    if (srcConversionItem == null) {
      return null;
    }

    String defaultValueStr = refreshedValues
        .firstWhere((rv) => srcConversionItem.unit.id! == rv.unitId)
        .value!;

    return ConversionItemModel(
        unit: srcConversionItem.unit,
        value: srcConversionItem.value,
        defaultValue: ValueModel(
          strValue: defaultValueStr,
        ));
  }

  Future<ConversionItemModel?> _refreshSourceConversionItemFromCoefficients(
    ConversionItemModel? srcConversionItem,
    List<UnitModel> refreshedUnitCoefficients,
  ) async {
    if (srcConversionItem == null || refreshedUnitCoefficients.isEmpty) {
      return srcConversionItem;
    }

    UnitModel srcUnit = srcConversionItem.unit;

    if (srcUnit.coefficient != 1) {
      srcUnit = refreshedUnitCoefficients.firstWhere(
        (unit) => srcConversionItem.unit.id! == unit.id!,
      );
    }

    return ConversionItemModel(
      unit: srcUnit,
      value: srcConversionItem.value,
      defaultValue: srcConversionItem.defaultValue,
    );
  }

  Future<List<UnitModel>> _refreshTargetUnits(
    List<UnitModel> currentTargetUnits,
    List<UnitModel> refreshedTargetUnits,
  ) async {
    Map<int, UnitModel> refreshedTargetUnitsMap = {
      for (var v in refreshedTargetUnits) v.id!: v
    };

    List<UnitModel> result = [];
    for (int i = 0; i < currentTargetUnits.length; i++) {
      int currentTargetUnitId = currentTargetUnits[i].id!;
      if (refreshedTargetUnitsMap.containsKey(currentTargetUnitId)) {
        result.add(refreshedTargetUnitsMap[currentTargetUnitId]!);
      } else {
        result.add(currentTargetUnits[i]);
      }
    }

    return result;
  }
}
