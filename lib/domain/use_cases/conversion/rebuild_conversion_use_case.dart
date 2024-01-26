import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/refreshable_value_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_rebuild_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/conversion/build_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class RebuildConversionUseCase
    extends UseCase<InputConversionRebuildModel, OutputConversionModel> {
  final BuildConversionUseCase buildConversionUseCase;

  const RebuildConversionUseCase({
    required this.buildConversionUseCase,
  });

  @override
  Future<Either<ConvertouchException, OutputConversionModel>> execute(
    InputConversionRebuildModel input,
  ) async {
    try {
      InputConversionModel refreshedConversionParams =
          await _buildRefreshedConversionParams(
        currentConversion: input.conversionToBeRebuilt,
        refreshableDataPart: input.refreshableDataPart,
        refreshedData: input.refreshedData,
      );

      return buildConversionUseCase.execute(refreshedConversionParams);
    } catch (e, stacktrace) {
      return Left(
        InternalException(
          message: "Error when rebuilding conversion after data refresh: $e,"
              "\n$stacktrace",
        ),
      );
    }
  }

  Future<InputConversionModel> _buildRefreshedConversionParams({
    required OutputConversionModel currentConversion,
    required RefreshableDataPart refreshableDataPart,
    required List<dynamic> refreshedData,
  }) async {
    return InputConversionModel(
      unitGroup: currentConversion.unitGroup,
      sourceConversionItem: await _buildRefreshedSrcConversionItem(
        srcConversionItem: currentConversion.sourceConversionItem,
        refreshableDataPart: refreshableDataPart,
        refreshedData: refreshedData,
      ),
      targetUnits: await _buildRefreshedTargetUnits(
        currentTargetUnits: currentConversion.targetConversionItems
            .map((item) => item.unit)
            .toList(),
        refreshableDataPart: refreshableDataPart,
        refreshedData: refreshedData,
      ),
    );
  }

  Future<ConversionItemModel?> _buildRefreshedSrcConversionItem({
    required ConversionItemModel? srcConversionItem,
    required RefreshableDataPart refreshableDataPart,
    required List<dynamic> refreshedData,
  }) async {
    switch (refreshableDataPart) {
      case RefreshableDataPart.value:
        return _refreshSourceConversionItemFromValues(
          srcConversionItem: srcConversionItem,
          refreshedValues: refreshedData as List<RefreshableValueModel>,
        );
      case RefreshableDataPart.coefficient:
        return _refreshSourceConversionItemFromCoefficients(
          srcConversionItem: srcConversionItem,
          refreshedUnitCoefficients: refreshedData as List<UnitModel>,
        );
    }
  }

  Future<List<UnitModel>> _buildRefreshedTargetUnits({
    required List<UnitModel> currentTargetUnits,
    required RefreshableDataPart refreshableDataPart,
    required List<dynamic> refreshedData,
  }) async {
    switch (refreshableDataPart) {
      case RefreshableDataPart.value:
        return currentTargetUnits;
      case RefreshableDataPart.coefficient:
        return _refreshTargetUnitsCoefficients(
          currentTargetUnits: currentTargetUnits,
          refreshedTargetUnits: refreshedData as List<UnitModel>,
        );
    }
  }

  Future<ConversionItemModel?> _refreshSourceConversionItemFromValues({
    required ConversionItemModel? srcConversionItem,
    required List<RefreshableValueModel> refreshedValues,
  }) async {
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

  Future<ConversionItemModel?> _refreshSourceConversionItemFromCoefficients({
    required ConversionItemModel? srcConversionItem,
    required List<UnitModel> refreshedUnitCoefficients,
  }) async {
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

  Future<List<UnitModel>> _refreshTargetUnitsCoefficients({
    required List<UnitModel> currentTargetUnits,
    required List<UnitModel> refreshedTargetUnits,
  }) async {
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
