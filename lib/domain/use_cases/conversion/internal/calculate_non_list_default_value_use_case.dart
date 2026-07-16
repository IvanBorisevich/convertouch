import 'dart:developer';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_non_list_default_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_dynamic_data_fetch_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/dynamic_data/fetch_dynamic_value_use_use.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class CalculateNonListDefaultValueUseCase<T extends IdNameItemModel>
    extends UseCase<InputNonListDefaultValueCalculationModel<T>, ValueModel?> {
  final FetchDynamicValueUseCase fetchDynamicValueUseCase;

  const CalculateNonListDefaultValueUseCase({
    required this.fetchDynamicValueUseCase,
  });

  @override
  Future<Either<ConvertouchException, ValueModel?>> execute(
    InputNonListDefaultValueCalculationModel<T> input,
  ) async {
    try {
      T item = input.item;

      if (item is! UnitModel && item is! ConversionParamModel) {
        return const Right(null);
      }

      ConvertouchListType? resultListType = input.replacingUnit?.listType;

      if (item is UnitModel) {
        resultListType ??= item.listType;
      } else if (item is ConversionParamModel) {
        resultListType ??= input.currentParamUnit?.listType ?? item.listType;
      }

      UnitModel? resultUnit = input.replacingUnit;

      if (item is UnitModel) {
        resultUnit ??= item;
      } else if (item is ConversionParamModel) {
        resultUnit ??= input.currentParamUnit ?? item.defaultUnit;
      }

      return Right(
        await _calculateDefaultValue(
          groupName: input.conversionGroupName,
          listType: resultListType,
          unit: resultUnit,
        ),
      );
    } catch (e, stackTrace) {
      log("Error when calculating a source default value: $e");
      return Left(
        ConvertouchException(
          message: "Error when calculating a source default value "
              "for the item ${input.item}",
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<ValueModel?> _calculateDefaultValue({
    required String groupName,
    required ConvertouchListType? listType,
    required UnitModel? unit,
  }) async {
    if (unit != null) {
      var dynamicValue = ObjectUtils.tryGet(
        await fetchDynamicValueUseCase.execute(
          InputDynamicValueFetchModel(
            groupName: groupName,
            srcUnit: unit,
          ),
        ),
      );

      String? srcDefaultValueStr = dynamicValue != null &&
              dynamicValue.value != null &&
              dynamicValue.value!.isNotEmpty
          ? dynamicValue.value
          : unit.valueType.defaultValueStr;

      return ValueModel.any(srcDefaultValueStr);
    }

    return null;
  }
}
